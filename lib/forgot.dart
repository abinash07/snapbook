import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapbook/controller/forgot_controller.dart';
import 'package:snapbook/utils/components/customText.dart';
import 'package:snapbook/utils/constants/colors.dart';
import 'package:snapbook/utils/constants/sizes.dart';
import 'package:snapbook/utils/constants/text_strings.dart';

class ForgotScreen extends StatelessWidget {
  ForgotScreen({super.key});

  final ForgotController forgotController = Get.put(ForgotController());

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
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Forgot Password?",
                          color1: TColors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          height: 10,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text:
                              'Enter the registered email address\nand send the OTP',
                          color1: TColors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                          textAlign: TextAlign.center,
                          height: 60,
                        ),
                      ],
                    ),

                    Form(
                      key: forgotController.formKey,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: forgotController.emailController,
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

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  side: const BorderSide(color: Colors.blue),
                                ),
                                onPressed: () {
                                  if (forgotController.formKey.currentState!
                                      .validate()) {
                                    forgotController.sendOTP();
                                  }
                                },
                                child: Obx(() {
                                  return forgotController.isLoading.value
                                      ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : const Text(TTexts.sendOTP);
                                }),
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
