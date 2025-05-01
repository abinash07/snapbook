import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:snapbook/controller/reminder_controller.dart';
import 'package:snapbook/helper/notification_helper.dart';
import 'package:uuid/uuid.dart';
import '../database/database_helper.dart';
import '../models/reminder.dart';

class AddNoteController extends GetxController {
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final locationController = TextEditingController();
  final dob = DateTime(1900).obs;
  final remarkController = TextEditingController();
  final anniversary = DateTime(1900).obs;
  final howWeMet = ''.obs;
  final callTime = DateTime.now().obs;

  final formKey = GlobalKey<FormState>();
  final uuid = Uuid();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  void setCallTime(DateTime dateTime) {
    callTime.value = dateTime;
  }

  Future<void> pickDob(BuildContext context) async {
    final picked = await _pickDate(context);
    if (picked != null) dob.value = picked;
  }

  Future<void> pickAnniversary(BuildContext context) async {
    final picked = await _pickDate(context);
    if (picked != null) anniversary.value = picked;
  }

  Future<DateTime?> _pickDate(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(Duration(days: 365 * 100)),
    );
  }

  Future<void> saveReminder() async {
    if (formKey.currentState!.validate()) {
      final reminder = Reminder(
        id: uuid.v4(),
        name: nameController.text.trim(),
        mobile: mobileController.text.trim(),
        location: locationController.text.trim(),
        dob: dob.value,
        howWeMet: howWeMet.value,
        anniversary: anniversary.value,
        remark: remarkController.text.trim(),
        callTime: callTime.value,
      );

      try {
        await _dbHelper.insertReminder(reminder);

        if (reminder.callTime.isAfter(DateTime.now())) {
          await NotificationHelper.scheduleReminderNotification(
            id: reminder.id.hashCode,
            title: 'Reminder: ${reminder.name}',
            body:
                'Scheduled call time: ${DateFormat('MMM dd, yyyy - hh:mm a').format(reminder.callTime)}',
            scheduledTime: reminder.callTime,
          );
        }

        Get.find<ReminderController>().fetchReminders();

        clearFields();
        Get.back();
        Get.snackbar(
          'Success',
          'Reminder saved successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        print(e);
        Get.snackbar(
          'Error',
          'Failed to save reminder: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  void clearFields() {
    nameController.clear();
    callTime.value = DateTime.now();
    formKey.currentState?.reset();
  }
}
