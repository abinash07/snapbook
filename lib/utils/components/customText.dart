import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    Key? key,
    required this.text,
    required this.color1,
    required this.fontWeight,
    required this.fontSize,
    this.textAlign,
    this.onTap,
    this.height,
  }) : super(key: key);

  final String text;
  final Color color1;
  final FontWeight fontWeight;
  final double fontSize;
  final double? height;
  final TextAlign? textAlign;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: onTap,
          child: Text(
            text,
            style: TextStyle(
              color: color1,
              fontFamily: 'Metropolis',
              fontWeight: fontWeight,
              fontSize: fontSize,
            ),
            textAlign: textAlign,
          ),
        ),
        SizedBox(height: height),
      ],
    );
  }
}
