import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:snapbook/home.dart';

class RegisterController extends GetxController {
  var isPasswordHidden = true.obs;
  var isLoading = false.obs;
  final box = GetStorage();
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }

  Future<void> registerUser() async {
    final String apiUrl = 'http://snapkar.com/api/resgister.php';
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "All fields are required",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      var responseData = json.decode(response.body);
      isLoading.value = false;

      if (response.statusCode == 200 && responseData['status'] == 1) {
        box.write("isLoggedIn", true);
        box.write("token", responseData['result']['auth_key']);
        Get.offAll(() => HomeScreen());
      } else {
        Get.snackbar(
          "Registration Failed",
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
