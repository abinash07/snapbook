import 'package:flutter/material.dart';
import 'package:snapbook/utils/components/customText.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    Key? key,
    required this.text,
    required this.color,
    required this.fontWeight,
    required this.font,
    required this.onPress,
  }) : super(key: key);

  final String text;
  final Color color;
  final FontWeight fontWeight;
  final double font;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: CustomText(
        text: text,
        color1: color,
        fontWeight: fontWeight,
        fontSize: font,
      ),
    );
  }
}
