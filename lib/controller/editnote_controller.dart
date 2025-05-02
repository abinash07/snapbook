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
  final mobileController = TextEditingController();
  final locationController = TextEditingController();
  final commentController = TextEditingController();
  final dob = DateTime(1900).obs;
  final anniversary = DateTime(1900).obs;
  final howWeMet = ''.obs;
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
      locationController.text = reminder.location;
      mobileController.text = reminder.mobile;
      dob.value = reminder.dob;
      anniversary.value = reminder.anniversary;
      howWeMet.value = reminder.howWeMet;
      commentController.text = reminder.comment;
      callTime.value = reminder.callTime;
    } finally {
      isLoading(false);
    }
  }

  void setCallTime(DateTime dateTime) {
    callTime.value = dateTime;
  }

  Future<void> pickDob(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dob.value,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) dob.value = picked;
  }

  Future<void> pickAnniversary(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: anniversary.value,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) anniversary.value = picked;
  }

  Future<void> updateReminder() async {
    if (formKey.currentState!.validate()) {
      try {
        final updatedReminder = Reminder(
          id: reminderId.value,
          name: nameController.text.trim(),
          mobile: mobileController.text.trim(),
          location: locationController.text.trim(),
          dob: dob.value,
          howWeMet: howWeMet.value,
          anniversary: anniversary.value,
          comment: commentController.text.trim(),
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
    mobileController.dispose();
    locationController.dispose();
    super.onClose();
  }
}
