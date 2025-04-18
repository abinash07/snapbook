import 'package:flutter/material.dart';
import 'package:snapbook/utils/constants/sizes.dart';
import 'package:snapbook/utils/constants/text_strings.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image(
        //   height: 150,
        //   image: AssetImage(
        //     dark ? TImages.lightAppLogo : TImages.darkAppLogo,
        //   ),
        // ),
        Text(
          TTexts.loginTitle,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(color: Colors.white),
        ),

        const SizedBox(height: TSizes.sm),
        Text(
          TTexts.loginSubTitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
