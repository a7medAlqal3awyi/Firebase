import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../themeing/app_colors.dart';

class AppTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final String buttonText;
  final TextStyle buttonTextStyle;
  final double? borderRadius;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? buttonWidth;
  final double? buttonHeight;

  const AppTextButton(
      {super.key,
        required this.onPressed,
        this.backgroundColor,
        required this.buttonText,
        required this.buttonTextStyle,
        this.borderRadius,
        this.verticalPadding,
        this.horizontalPadding,
        this.buttonWidth,
        this.buttonHeight});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 25.r)),
          ),
          padding: MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(
              vertical: verticalPadding ?? 12.h,
              horizontal: horizontalPadding ?? 12.w)),
          fixedSize: MaterialStateProperty.all(
              Size(buttonWidth ?? double.maxFinite, buttonHeight ?? 50.h)),
          backgroundColor: MaterialStatePropertyAll(
              backgroundColor ?? ColorManager.primary)),
      onPressed: onPressed,
      child: Text(
        buttonText ,
        style: buttonTextStyle ,
      ),
    );
  }
}