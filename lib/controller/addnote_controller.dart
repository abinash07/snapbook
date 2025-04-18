import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNoteController extends GetxController {
  final name = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final freeTime = ''.obs;
  final callTime = DateTime.now().obs;

  final formKey = GlobalKey<FormState>();

  void setCallTime(DateTime dateTime) {
    callTime.value = dateTime;
  }

  void saveReminder() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      // Here you can schedule notification using flutter_local_notifications or similar package
      Get.snackbar('Saved', 'Reminder set for ${callTime.value}');
    }
  }
}
