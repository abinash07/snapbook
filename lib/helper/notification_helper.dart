import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
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
        importance: NotificationImportance.High,
        soundSource: 'resource://raw/alert',
        defaultColor: Colors.blue,
        ledColor: Colors.blue,
        criticalAlerts: true,
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
      ),
      schedule: NotificationCalendar.fromDate(
        date: tzScheduledTime,
        allowWhileIdle: true,
        repeats: false,
      ),
    );
  }

  static Future<void> cancelScheduledNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }
}
