import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapbook/controller/register_controller.dart';
import 'package:snapbook/login.dart';
import 'package:snapbook/utils/components/customText.dart';
import 'package:snapbook/utils/components/customTextButton.dart';
import 'package:snapbook/utils/constants/colors.dart';
import 'package:snapbook/utils/constants/sizes.dart';
import 'package:snapbook/utils/constants/text_strings.dart';
import 'package:snapbook/utils/helpers/helper_functions.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final RegisterController controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
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
                    Text(
                      TTexts.signupTitle,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(color: Colors.white),
                    ),

                    const SizedBox(height: TSizes.spaceBtwItems),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Already Have an Account ? ",
                          color1: dark ? TColors.light : TColors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          height: 10,
                        ),
                        CustomTextButton(
                          text: 'Login Here',
                          color: TColors.primary,
                          fontWeight: FontWeight.w400,
                          font: 15,
                          onPress: () => Get.to(() => LoginScreen()),
                        ),
                      ],
                    ),

                    Form(
                      key: controller.formKey,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: controller.nameController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: TTexts.name,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Name is required.';
                                } else if (value.trim().length < 2) {
                                  return 'Name must be at least 2 characters long.';
                                } else if (!RegExp(
                                  r"^[a-zA-Z\s]+$",
                                ).hasMatch(value.trim())) {
                                  return 'Name can only contain letters and spaces.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: TSizes.spaceBtwInputFields),

                            TextFormField(
                              controller: controller.emailController,
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
                                controller: controller.passwordController,
                                obscureText: controller.isPasswordHidden.value,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock_outline),
                                  labelText: TTexts.password,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.isPasswordHidden.value
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                    onPressed:
                                        controller.togglePasswordVisibility,
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

                            const SizedBox(height: TSizes.spaceBtwSections),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  side: const BorderSide(color: Colors.blue),
                                ),
                                onPressed: () {
                                  if (controller.formKey.currentState!
                                      .validate()) {
                                    controller.registerUser();
                                  }
                                },
                                child: Obx(() {
                                  return controller.isLoading.value
                                      ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : const Text(TTexts.createAccount);
                                }),
                              ),
                            ),

                            const SizedBox(height: TSizes.spaceBtwItems),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: "By Register You Agree Our ",
                                  color1: dark ? TColors.light : TColors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomTextButton(
                                      text: 'Terms & Conditions',
                                      color: TColors.primary,
                                      fontWeight: FontWeight.w400,
                                      font: 12,
                                      onPress: () {},
                                    ),
                                    CustomText(
                                      text: " And ",
                                      color1:
                                          dark ? TColors.light : TColors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      height: 0,
                                    ),
                                    CustomTextButton(
                                      text: 'Privacy Policy',
                                      color: TColors.primary,
                                      fontWeight: FontWeight.w400,
                                      font: 12,
                                      onPress: () {},
                                    ),
                                  ],
                                ),
                              ],
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
