import 'package:fire_app/features/signup/ui/widgets/already_have_acc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helper/spacing.dart';
import '../../../core/themeing/styles.dart';
import '../../../core/widgets/app_text_button.dart';
import '../../../core/widgets/app_text_form_feild.dart';
import '../../login/widgets/dont_have_account.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isObsecure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text("Signup Screen"),
    ));
  }
}
