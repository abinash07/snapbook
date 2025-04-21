import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:get_storage/get_storage.dart';

class AddNoteController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final freeTimeController = TextEditingController();
  final callTime = DateTime.now().obs;

  final formKey = GlobalKey<FormState>();
  final storage = GetStorage();
  final uuid = Uuid();

  void setCallTime(DateTime dateTime) {
    callTime.value = dateTime;
  }

  void saveReminder() {
    if (formKey.currentState!.validate()) {
      final reminder = {
        'id': uuid.v4(),
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'freeTime': freeTimeController.text.trim(),
        'callTime': callTime.value.toIso8601String(),
      };

      List reminders = storage.read('reminders') ?? [];
      reminders.add(reminder);
      storage.write('reminders', reminders);

      clearFields();
      Get.snackbar('Success', 'Reminder saved for ${callTime.value}');
    }
  }

  void clearFields() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    freeTimeController.clear();
    callTime.value = DateTime.now();
    formKey.currentState?.reset();
  }
}
