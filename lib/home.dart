import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snapbook/add_note.dart';
import 'package:snapbook/details.dart';
import 'package:snapbook/edit_note.dart';
import 'package:snapbook/helper/notification_helper.dart';
import 'package:snapbook/utils/constants/colors.dart';
import 'package:snapbook/utils/constants/text_strings.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:snapbook/controller/reminder_controller.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = GetStorage();
  final ReminderController controller = Get.put(ReminderController());

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
    _initializeNotifications();
    _scheduleExistingReminders();
  }

  Future<void> _initializeNotifications() async {
    await NotificationHelper.initialize();
    requestNotificationPermission();
    checkBatteryOptimization();
  }

  void _scheduleExistingReminders() async {
    // Wait for reminders to load
    await controller.fetchReminders();

    for (final reminder in controller.reminders) {
      if (reminder.callTime.isAfter(DateTime.now())) {
        NotificationHelper.scheduleReminderNotification(
          id: reminder.id.hashCode,
          title: 'Reminder: ${reminder.name}',
          body:
              'Scheduled call time: ${DateFormat('MMM dd, yyyy - hh:mm a').format(reminder.callTime)}',
          scheduledTime: reminder.callTime,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return controller.showSearch.value
              ? TextField(
                autofocus: true,
                onChanged: (value) => controller.searchQuery.value = value,
                decoration: InputDecoration(
                  hintText: 'Search reminders...',
                  border: InputBorder.none,
                ),
              )
              : Text(
                TTexts.appName,
                style: TextStyle(
                  color: TColors.black,
                  fontWeight: FontWeight.bold,
                ),
              );
        }),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: TColors.primary),
        actionsIconTheme: IconThemeData(color: TColors.primary),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                controller.showSearch.value ? Icons.close : Icons.search,
              ),
              onPressed: () {
                controller.toggleSearch();
                if (!controller.showSearch.value) {
                  controller.searchQuery.value = '';
                }
              },
            ),
          ),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.filteredReminders.isEmpty) {
          return Center(child: Text('No reminders found.'));
        }

        return ListView.separated(
          itemCount: controller.filteredReminders.length,
          padding: EdgeInsets.all(12),
          separatorBuilder: (_, __) => SizedBox(height: 10),
          itemBuilder: (context, index) {
            final reminder = controller.filteredReminders[index];
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
                      () =>
                          Get.to(() => DetailsScreen(), arguments: reminder.id),
                  child: Text(
                    reminder.name,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                subtitle: Text(
                  'Call at: ${DateFormat('MMM dd, yyyy - hh:mm a').format(reminder.callTime)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed:
                          () => Get.to(
                            () => EditNoteScreen(),
                            arguments: reminder.id,
                          )?.then((_) => controller.fetchReminders()),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => controller.deleteReminder(reminder.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),

      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Get.to(
              () => AddNoteScreen(),
            )?.then((_) => controller.fetchReminders()),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
