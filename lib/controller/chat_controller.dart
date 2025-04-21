import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class EditNoteController extends GetxController {
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final freeTime = TextEditingController();
  final callTime = DateTime.now().obs;

  final storage = GetStorage();
  late Map<String, dynamic> originalReminder;

  @override
  void onInit() {
    super.onInit();
    final id = Get.arguments; // ID passed from HomeScreen
    final reminders = storage.read('reminders') ?? [];

    final reminder = reminders.firstWhere(
      (r) => r['id'] == id,
      orElse: () => null,
    );

    if (reminder == null) {
      Get.snackbar("Error", "Reminder not found");
      Get.back();
      return;
    }

    originalReminder = reminder;

    name.text = reminder['name'] ?? '';
    email.text = reminder['email'] ?? '';
    phone.text = reminder['phone'] ?? '';
    freeTime.text = reminder['freeTime'] ?? '';
    callTime.value = DateTime.parse(reminder['callTime']);
  }

  void updateCallTime(DateTime newTime) {
    callTime.value = newTime;
  }

  void submitForm() {
    final updatedReminder = {
      'id': originalReminder['id'],
      'name': name.text.trim(),
      'email': email.text.trim(),
      'phone': phone.text.trim(),
      'freeTime': freeTime.text.trim(),
      'callTime': callTime.value.toIso8601String(),
    };

    List reminders = storage.read('reminders') ?? [];

    final index = reminders.indexWhere((r) => r['id'] == updatedReminder['id']);
    if (index != -1) {
      reminders[index] = updatedReminder;
      storage.write('reminders', reminders);
      Get.snackbar("Success", "Reminder updated successfully");
    } else {
      Get.snackbar("Error", "Reminder not found");
    }
  }
}
