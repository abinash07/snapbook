import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:snapbook/home.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  final storage = GetStorage();
  var isPasswordHidden = true.obs;
  final formKey = GlobalKey<FormState>();

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

  Future<void> loginUser(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter both email and password",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading(true);
    final String apiUrl = 'http://snapkar.com/api/login.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({'username': email, 'password': password}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      var responseData = json.decode(response.body.toString());

      if (response.statusCode == 200 && responseData['status'] == 1) {
        var result = responseData['result'];

        // Save user data
        storage.write("Login", true);
        storage.write("name", result['name']);
        storage.write("username", result['username']);
        storage.write("bio", result['bio']);
        storage.write("email", result['email']);
        storage.write("token", result['auth_key']);

        // Navigate to home page
        Get.offAll(() => HomeScreen());
        //Get.offAllNamed(AppRoutes.home);
      } else {
        Get.snackbar("Login Failed", "Invalid email or password");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Please try again.");
    } finally {
      isLoading(false);
    }
  }
}
