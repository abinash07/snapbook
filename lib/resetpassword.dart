import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapbook/controller/reset_password_controller.dart';
import 'package:snapbook/utils/components/customText.dart';
import 'package:snapbook/utils/constants/colors.dart';
import 'package:snapbook/utils/constants/sizes.dart';
import 'package:snapbook/utils/constants/text_strings.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final ResetPasswordController resetPasswordController = Get.put(
    ResetPasswordController(),
  );

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
                      key: resetPasswordController.formKey,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Column(
                          children: [
                            Obx(
                              () => TextFormField(
                                controller:
                                    resetPasswordController.passwordController,
                                obscureText:
                                    resetPasswordController
                                        .isPasswordHidden
                                        .value,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock_outline),
                                  labelText: TTexts.password,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      resetPasswordController
                                              .isPasswordHidden
                                              .value
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                    onPressed:
                                        resetPasswordController
                                            .togglePasswordVisibility,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required.';
                                  } else if (value.length < 8) {
                                    return 'Password must be at least 8 characters.';
                                  } else if (!RegExp(
                                    r'[A-Z]',
                                  ).hasMatch(value)) {
                                    return 'Include at least one uppercase letter.';
                                  } else if (!RegExp(
                                    r'[a-z]',
                                  ).hasMatch(value)) {
                                    return 'Include at least one lowercase letter.';
                                  } else if (!RegExp(
                                    r'[0-9]',
                                  ).hasMatch(value)) {
                                    return 'Include at least one number.';
                                  } else if (!RegExp(
                                    r'[!@#\$&*~]',
                                  ).hasMatch(value)) {
                                    return 'Include at least one special character (!@#\$&*~).';
                                  }
                                  return null;
                                },
                              ),
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
                                  if (resetPasswordController
                                      .formKey
                                      .currentState!
                                      .validate()) {
                                    resetPasswordController.resetPassword();
                                  }
                                },
                                child: Obx(() {
                                  return resetPasswordController.isLoading.value
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
