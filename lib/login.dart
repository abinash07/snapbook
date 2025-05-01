import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:snapbook/controller/login_controller.dart';
import 'package:snapbook/forgot.dart';
import 'package:snapbook/register.dart';
import 'package:snapbook/utils/constants/sizes.dart';
import 'package:snapbook/utils/constants/text_strings.dart';
import 'package:snapbook/widgets/loginHeader.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController loginController = Get.put(LoginController());

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
                      key: loginController.formKey,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: loginController.emailController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email_outlined),
                                labelText: TTexts.email,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'This field is required.';
                                }
                                // Simple email format check
                                if (!RegExp(
                                  r'^[^@]+@[^@]+\.[^@]+',
                                ).hasMatch(value)) {
                                  return 'Please enter a valid email address.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: TSizes.spaceBtwInputFields),

                            Obx(
                              () => TextFormField(
                                controller: loginController.passwordController,
                                obscureText:
                                    loginController.isPasswordHidden.value,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock_outline),
                                  labelText: TTexts.password,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      loginController.isPasswordHidden.value
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                    onPressed:
                                        loginController
                                            .togglePasswordVisibility,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required.';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            const SizedBox(
                              height: TSizes.spaceBtwInputFields / 2,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => Get.to(() => ForgotScreen()),
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
                                  final email =
                                      loginController.emailController.text
                                          .trim();
                                  final password =
                                      loginController.passwordController.text
                                          .trim();
                                  if (loginController.formKey.currentState!
                                      .validate()) {
                                    loginController.loginUser(email, password);
                                  }
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
                                onPressed: () => Get.to(() => RegisterScreen()),
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
