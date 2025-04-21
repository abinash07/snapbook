import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snapbook/add_note.dart';
import 'package:snapbook/details.dart';
import 'package:snapbook/edit_note.dart';
import 'package:snapbook/utils/constants/colors.dart';
import 'package:snapbook/utils/constants/text_strings.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:snapbook/controller/home_controller.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = GetStorage();
  final controller = Get.put(HomeController());

  String formatDateTime(String isoString) {
    final dt = DateTime.parse(isoString);
    return '${dt.day}/${dt.month}/${dt.year} – ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  void scheduleNotification() async {
    final scheduledTime = tz.TZDateTime.now(
      tz.local,
    ).add(Duration(seconds: 10));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch % 100000,
        channelKey: 'scheduled_channel', // Changed to alarm-specific channel
        title: '🚨 CRITICAL ALERT!',
        body: 'This alert cannot be dismissed!',
        payload: {'type': 'critical'},
        autoDismissible: false, // Prevent swipe-to-dismiss
        wakeUpScreen: true, // Wake device screen
        fullScreenIntent: true, // Android full-screen alert
        criticalAlert: true,
        notificationLayout: NotificationLayout.Inbox,
      ),
      // Removed action buttons to prevent dismissal
      schedule: NotificationCalendar.fromDate(
        date: scheduledTime,
        allowWhileIdle: true,
        repeats: false,
      ),
    );
  }

  void requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      status = await Permission.notification.request();
    }

    print("Notification Permission Status: $status");
  }

  void checkBatteryOptimization() async {
    if (Platform.isAndroid) {
      print("battery");
      var status = await Permission.ignoreBatteryOptimizations.status;
      if (status.isDenied) {
        await Permission.ignoreBatteryOptimizations.request();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
    checkBatteryOptimization();
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
              onTap: scheduleNotification,
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
      // body: ListView.separated(
      //   itemCount: sampleReminders.length,
      //   padding: EdgeInsets.all(12),
      //   separatorBuilder: (_, __) => SizedBox(height: 10),
      //   itemBuilder: (context, index) {
      //     final reminder = sampleReminders[index];
      //     return Container(
      //       padding: EdgeInsets.all(12),
      //       decoration: BoxDecoration(
      //         color: Colors.grey[200],
      //         borderRadius: BorderRadius.circular(12),
      //       ),
      //       child: ListTile(
      //         contentPadding: EdgeInsets.zero,
      //         leading: CircleAvatar(child: Icon(Icons.person)),
      //         title: GestureDetector(
      //           onTap: () => Get.to(() => DetailsScreen()),
      //           child: Text(
      //             reminder['name'],
      //             style: TextStyle(color: Colors.blue),
      //           ),
      //         ),
      //         subtitle: Text(
      //           'Call at: ${formatDateTime(reminder['callTime'])}',
      //           style: TextStyle(fontSize: 12, color: Colors.grey[700]),
      //         ),
      //         trailing: IconButton(
      //           icon: Icon(Icons.edit, color: Colors.blue),
      //           onPressed: () => Get.to(() => EditNoteScreen()),
      //         ),
      //       ),
      //     );
      //   },
      // ),
      body: Obx(() {
        if (controller.reminders.isEmpty) {
          return Center(child: Text('No reminders found.'));
        }

        return ListView.separated(
          itemCount: controller.reminders.length,
          padding: EdgeInsets.all(12),
          separatorBuilder: (_, __) => SizedBox(height: 10),
          itemBuilder: (context, index) {
            final reminder = controller.reminders[index];
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
                  onTap:
                      () => Get.to(() => DetailsScreen(), arguments: reminder),
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
                  onPressed:
                      () => Get.to(
                        () => EditNoteScreen(),
                        arguments: reminder['id'],
                      ),
                ),
              ),
            );
          },
        );
      }),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddNoteScreen()),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
