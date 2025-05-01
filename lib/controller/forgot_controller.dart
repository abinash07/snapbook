import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:snapbook/verifyotp.dart';

class ForgotController extends GetxController {
  var isLoading = false.obs;
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> sendOTP() async {
    final String apiUrl = 'http://snapkar.com/api/otp_send.php';
    final String email = emailController.text.trim();
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({'username': email}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      var responseData = json.decode(response.body);
      isLoading.value = false;

      if (response.statusCode == 200 && responseData['status'] == 1) {
        Get.offAll(() => VerifyOTPScreen(), arguments: {'email': email});
      } else {
        Get.snackbar(
          "Failed to send OTP",
          responseData['message'] ?? "Something went wrong",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print(e);
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
