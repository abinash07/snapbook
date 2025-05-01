import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:snapbook/controller/verify_otp_controller.dart';
import 'package:snapbook/utils/components/customText.dart';
import 'package:snapbook/utils/constants/colors.dart';
import 'package:snapbook/utils/constants/sizes.dart';

class VerifyOTPScreen extends StatelessWidget {
  VerifyOTPScreen({super.key});

  final VerifyOtpController verifyOtpController = Get.put(
    VerifyOtpController(),
  );
  //final OtpFieldController otpController = OtpFieldController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .07),
            SizedBox(height: 45),
            Column(
              children: [
                CustomText(
                  text: 'Enter OTP',
                  color1: TColors.black,
                  fontWeight: FontWeight.w500,
                  height: 50,
                  fontSize: 22,
                ),
              ],
            ),
            OTPTextField(
              controller: verifyOtpController.otpController,
              width: MediaQuery.of(context).size.width,
              textFieldAlignment: MainAxisAlignment.center,
              spaceBetween: 20,
              fieldWidth: 45,
              obscureText: true,
              fieldStyle: FieldStyle.box,
              outlineBorderRadius: 10,
              otpFieldStyle: OtpFieldStyle(
                focusBorderColor: TColors.black,
                enabledBorderColor: TColors.otpColor.withOpacity(.1),
                backgroundColor: TColors.otpColor.withOpacity(.1),
              ),
              style: TextStyle(fontSize: 17),
              onChanged: (pin) {
                verifyOtpController.enteredOtp = pin;
              },
              onCompleted: (pin) {
                verifyOtpController.enteredOtp = pin;
              },
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue),
                ),
                child: Obx(() {
                  return verifyOtpController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Verify OTP");
                }),
                onPressed: () {
                  if (verifyOtpController.enteredOtp.isNotEmpty) {
                    verifyOtpController.sendOTP();
                  } else {
                    Get.snackbar("Error", "Please enter the OTP first");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
