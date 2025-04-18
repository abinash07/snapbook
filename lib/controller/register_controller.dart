import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:snapbook/widgets/bottomNavBar.dart';

class RegisterController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var isLoading = false.obs;
  final box = GetStorage();

  Future<void> registerUser() async {
    final String apiUrl = 'http://snapkar.com/api/register.php';
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
        // ✅ Store login status & token in GetStorage
        box.write("isLoggedIn", true);
        box.write("token", responseData['result']['auth_key']);

        Get.offAll(() => BottomNavBar()); // Navigate to home
      } else {
        Get.snackbar(
          "Registration Failed",
          responseData['message'] ?? "Something went wrong",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      isLoading.value = false;
      print("Register Error: $e");
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
