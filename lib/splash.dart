import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:snapbook/home.dart';
import 'package:snapbook/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    whereToGo();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 3).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Snap Book',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(3, (int index) {
                    return Opacity(
                      opacity: _animation.value > index ? 1.0 : 0.0,
                      child: Container(
                        width: 10,
                        height: 10,
                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Check login status and auth key
  void whereToGo() async {
    await Future.delayed(Duration(seconds: 2));
    bool? isLoggedin = storage.read("Login");

    if (isLoggedin == true) {
      String? token = storage.read("token");
      if (token != null && await fetchData(token)) {
        Get.off(() => HomeScreen());
      } else {
        Get.off(() => LoginScreen());
      }
    } else {
      Get.off(() => LoginScreen());
    }
  }

  /// Verify authentication key
  Future<bool> fetchData(String authKey) async {
    final url = Uri.parse('http://snapkar.com/api/verify_auth_key.php');
    final payload = {"auth_key": authKey};
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        return responseData['status'] == true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
