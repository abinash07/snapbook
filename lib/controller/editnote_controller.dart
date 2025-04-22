import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:snapbook/controller/reminder_controller.dart';
import 'package:snapbook/database/database_helper.dart';
import 'package:snapbook/helper/notification_helper.dart';
import 'package:snapbook/models/reminder.dart';

class EditNoteController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final formKey = GlobalKey<FormState>();
  final isLoading = true.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final freeTimeController = TextEditingController();
  final callTime = DateTime.now().obs;
  final RxString reminderId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    reminderId.value = Get.arguments;
  }

  Future<void> loadReminder(String id) async {
    try {
      isLoading(true);
      final reminder = await _dbHelper.getReminderById(id);
      nameController.text = reminder.name;
      emailController.text = reminder.email;
      phoneController.text = reminder.phone;
      freeTimeController.text = reminder.freeTime;
      callTime.value = reminder.callTime;
    } finally {
      isLoading(false);
    }
  }

  void setCallTime(DateTime dateTime) {
    callTime.value = dateTime;
  }

  Future<void> updateReminder() async {
    if (formKey.currentState!.validate()) {
      try {
        final updatedReminder = Reminder(
          id: reminderId.value,
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim(),
          freeTime: freeTimeController.text.trim(),
          callTime: callTime.value,
        );

        await _dbHelper.updateReminder(updatedReminder);

        if (updatedReminder.callTime.isAfter(DateTime.now())) {
          await NotificationHelper.scheduleReminderNotification(
            id: updatedReminder.id.hashCode,
            title: 'Updated Reminder: ${updatedReminder.name}',
            body:
                'New call time: ${DateFormat('MMM dd, yyyy - hh:mm a').format(updatedReminder.callTime)}',
            scheduledTime: updatedReminder.callTime,
          );
        }

        Get.find<ReminderController>().fetchReminders();

        Get.back();
        Get.snackbar(
          'Success',
          'Reminder updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to update reminder: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    freeTimeController.dispose();
    super.onClose();
  }
}
