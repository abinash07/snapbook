import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapbook/details.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationHelper {
  static Future<void> initialize() async {
    tz.initializeTimeZones();
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: 'scheduled_channel',
        channelName: 'Scheduled Reminders',
        channelDescription: 'Channel for reminder notifications',
        importance: NotificationImportance.Max,
        //soundSource: 'resource://raw/alert',
        playSound: true,
        defaultColor: Colors.blue,
        ledColor: Colors.blue,
        criticalAlerts: true,
        enableVibration: true,
        locked: true,
        defaultRingtoneType: DefaultRingtoneType.Alarm,
      ),
    ]);
  }

  static Future<void> scheduleReminderNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(
      scheduledTime,
      tz.local,
    );
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'scheduled_channel',
        title: title,
        body: body,
        payload: {'id': id.toString()},
        autoDismissible: false,
        wakeUpScreen: true,
        fullScreenIntent: true,
        criticalAlert: true,
        category: NotificationCategory.Reminder,
      ),
      schedule: NotificationCalendar.fromDate(
        date: tzScheduledTime,
        allowWhileIdle: true,
        repeats: true,
        preciseAlarm: true,
      ),
    );
  }

  static void listenToNotificationTap() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: (ReceivedAction receivedAction) async {
        final reminderId = receivedAction.payload?['id'];
        if (reminderId != null) {
          Get.to(() => DetailsScreen(), arguments: reminderId);
        }
      },
    );
  }

  static Future<bool> checkAndRequestNotificationPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
      isAllowed = await AwesomeNotifications().isNotificationAllowed();
    }
    return isAllowed;
  }

  static Future<void> cancelScheduledNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }
}
