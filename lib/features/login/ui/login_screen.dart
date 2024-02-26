import 'package:fire_app/core/helper/spacing.dart';
import 'package:fire_app/core/themeing/styles.dart';
import 'package:fire_app/core/widgets/app_text_form_feild.dart';
import 'package:fire_app/features/login/widgets/dont_have_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widgets/app_text_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObsecure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Back",
                  style: TextStyles.font24BlueW700,
                ),
                verticalSpacing(8),
                Text(
                  "We're excited to have you back, can't wait to see what you've been up to since you last logged in.",
                  style: TextStyles.font14GreyW400,
                ),
                verticalSpacing(30),
                AppTextFormField(hintText: "Email", validator: (val) {}),
                verticalSpacing(30),
                AppTextFormField(
                  hintText: "Password",
                  validator: (val) {},
                  isSecureText: isObsecure,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isObsecure = !isObsecure;
                      });
                    },
                    icon: Icon(
                      isObsecure ? Icons.remove_red_eye : Icons.visibility_off,
                    ),
                  ),
                ),
                verticalSpacing(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forget Password?",
                      style: TextStyles.font14darkBlueW500,
                    ),
                  ],
                ),
                verticalSpacing(20),
                AppTextButton(
                  onPressed: () {},
                  buttonText: 'Login',
                  buttonTextStyle: TextStyles.font16WhiteW600,
                ),
                verticalSpacing(20),
                AppTextButton(
                  backgroundColor: Colors.red,
                  onPressed: () {},
                  buttonText: 'Login with Google',
                  buttonTextStyle: TextStyles.font16WhiteW600,

                ),
                verticalSpacing(20),
                const DontHaveAnAccount()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
