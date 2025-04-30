import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ResetPasswordController extends GetxController {
  var isLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  late String otp;
  late String email;
  var isPasswordHidden = true.obs;
  final TextEditingController passwordController = TextEditingController();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> resetPassword() async {
    final String apiUrl = 'http://snapkar.com/api/resetpassword.php';
    final String password = passwordController.text.trim();
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({'username': email, 'otp': otp, 'password': password}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      var responseData = json.decode(response.body);
      isLoading.value = false;

      if (response.statusCode == 200 && responseData['status'] == 1) {
        //Get.offAll(() => HomeScreen());
        // Get.toNamed(
        //   '/verify',
        //   arguments: {'email': 'abc@example.com', 'otp': '123456'},
        // );
      } else {
        Get.snackbar(
          "Failed to send OTP",
          responseData['message'] ?? "Something went wrong",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
