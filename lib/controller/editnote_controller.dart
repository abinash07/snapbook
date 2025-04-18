import 'package:get/get.dart';
import 'package:flutter/material.dart';

class EditNoteController extends GetxController {
  // Observable form fields
  var name = TextEditingController(text: 'Alice Johnson');
  var email = TextEditingController(text: 'alice@example.com');
  var phone = TextEditingController(text: '+1 555 123 4567');
  var freeTime = TextEditingController(text: 'Weekends after 4 PM');
  var callTime = DateTime.now().add(Duration(hours: 2)).obs;

  void updateCallTime(DateTime newTime) {
    callTime.value = newTime;
  }

  void submitForm() {
    // You can extend this for form submission or DB saving
    Get.snackbar("Reminder Updated", "${name.text} updated successfully");
  }
}
