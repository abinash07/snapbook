import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snapbook/add_note.dart';
import 'package:snapbook/details.dart';
import 'package:snapbook/edit_note.dart';
import 'package:snapbook/main.dart';
import 'package:snapbook/utils/constants/colors.dart';
import 'package:snapbook/utils/constants/text_strings.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = GetStorage();

  final List<Map<String, dynamic>> sampleReminders = [
    {
      'name': 'Alice Johnson',
      'callTime': DateTime.now().add(Duration(hours: 2)),
    },
    {
      'name': 'Bob Smith',
      'callTime': DateTime.now().add(Duration(days: 1, hours: 3)),
    },
    {
      'name': 'Charlie Davis',
      'callTime': DateTime.now().add(Duration(minutes: 45)),
    },
  ];

  String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy – hh:mm a').format(dateTime);
  }

  void requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      status = await Permission.notification.request();
    }

    print("Notification Permission Status: $status");
  }

  void showNotification() async {
    print("Shedule notificatio");
    var androidDetails = AndroidNotificationDetails(
      "notifications-alarm-id", // Unique channel ID
      "Sample alaram Notifications", // Channel name
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      timeoutAfter: 3000, // 3-second timeout
    );

    var iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    var notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    DateTime scheduleDate = DateTime.now().add(Duration(seconds: 5));

    await notificationsPlugin.zonedSchedule(
      0,
      "Scheduled Notification",
      "This is a test notification after 30 seconds.",
      tz.TZDateTime.from(scheduleDate, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: "notification-payload",
    );
  }

  void showImmediateNotification() async {
    var androidDetails = AndroidNotificationDetails(
      "notifications-channel-id",
      "Sample Notifications",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
    );

    var iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    var notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await notificationsPlugin.show(
      0,
      "Immediate Notification",
      "This is an immediate notification.",
      notificationDetails,
      payload: "notification-payload",
    );
  }

  void checkForNotification() async {
    NotificationAppLaunchDetails? details =
        await notificationsPlugin.getNotificationAppLaunchDetails();

    if (details != null) {
      if (details.didNotificationLaunchApp) {
        NotificationResponse? response = details.notificationResponse;

        if (response != null) {
          String? payload = response.payload;
          print("Notification Payload: $payload");
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
    checkForNotification();
  }

  @override
  Widget build(BuildContext context) {
    String? imagePath = storage.read("image");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          TTexts.appName,
          style: TextStyle(color: TColors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: TColors.primary),
        actionsIconTheme: IconThemeData(color: TColors.primary),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: showImmediateNotification,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: TColors.blueShade, width: 2),
                ),
                child: CircleAvatar(
                  backgroundImage:
                      (imagePath != null && imagePath.isNotEmpty)
                          ? FileImage(File(imagePath))
                          : const AssetImage('assets/images/logo.png')
                              as ImageProvider,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: sampleReminders.length,
        padding: EdgeInsets.all(12),
        separatorBuilder: (_, __) => SizedBox(height: 10),
        itemBuilder: (context, index) {
          final reminder = sampleReminders[index];
          return Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: GestureDetector(
                onTap: () => Get.to(() => DetailsScreen()),
                child: Text(
                  reminder['name'],
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              subtitle: Text(
                'Call at: ${formatDateTime(reminder['callTime'])}',
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () => Get.to(() => EditNoteScreen()),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showNotification,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
