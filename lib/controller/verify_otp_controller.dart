import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:otp_text_field/otp_field.dart';
import 'package:snapbook/resetpassword.dart';

class VerifyOtpController extends GetxController {
  var isLoading = false.obs;
  late String email;
  final OtpFieldController otpController = OtpFieldController();
  String enteredOtp = '';
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    // Safely get the email from Get.arguments
    if (Get.arguments != null && Get.arguments['email'] != null) {
      email = Get.arguments['email'];
    } else {
      // Fallback or debug log
      email = '';
      print('⚠️ Email not passed to VerifyOtpController via Get.arguments');
    }
  }

  Future<void> sendOTP() async {
    final String apiUrl = 'http://snapkar.com/api/verifyotp.php';
    final String otp = enteredOtp.trim();
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({'username': email, 'otp': otp}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      var responseData = json.decode(response.body);
      isLoading.value = false;

      if (response.statusCode == 200 && responseData['status'] == 1) {
        Get.offAll(
          () => ResetPasswordScreen(),
          arguments: {'email': email, 'otp': otp},
        );
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
