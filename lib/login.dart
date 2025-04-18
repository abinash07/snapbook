import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:snapbook/controller/login_controller.dart';
//import 'package:snapbook/register.dart';
import 'package:snapbook/utils/constants/sizes.dart';
import 'package:snapbook/utils/constants/text_strings.dart';
import 'package:snapbook/widgets/loginHeader.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController loginController = Get.put(LoginController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/login.png', fit: BoxFit.cover),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.defaultSpace,
                  vertical: TSizes.defaultSpace,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LoginHeader(),

                    Form(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email_outlined),
                                labelText: TTexts.email,
                              ),
                            ),
                            const SizedBox(height: TSizes.spaceBtwInputFields),

                            TextFormField(
                              controller: passwordController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.lock_outline),
                                labelText: TTexts.password,
                                suffixIcon: Icon(Icons.visibility_off_outlined),
                              ),
                            ),

                            const SizedBox(
                              height: TSizes.spaceBtwInputFields / 2,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(TTexts.forgetPassword),
                                ),
                              ],
                            ),
                            const SizedBox(height: TSizes.spaceBtwSections),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  side: const BorderSide(color: Colors.blue),
                                ),
                                onPressed: () {
                                  final email = emailController.text.trim();
                                  final password =
                                      passwordController.text.trim();
                                  loginController.loginUser(email, password);
                                },
                                child: Obx(() {
                                  return loginController.isLoading.value
                                      ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : const Text(TTexts.signIn);
                                }),
                              ),
                            ),

                            const SizedBox(height: TSizes.spaceBtwItems),

                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {},
                                child: const Text(TTexts.createAccount),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
