import 'package:flutter/material.dart';

import '../../../core/helper/spacing.dart';
import '../../../core/widgets/app_text_form_feild.dart';

class EmailAndPassword extends StatefulWidget {
  const EmailAndPassword({super.key});

  @override
  State<EmailAndPassword> createState() => _EmailAndPasswordState();
}

class _EmailAndPasswordState extends State<EmailAndPassword> {
  bool isObsecure = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          AppTextFormField(
            controller: emailController,
            hintText: "Email",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid email ';
              }
            },
          ),
          verticalSpacing(30),
          AppTextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid password ';
              }
            },
            controller: passwordController,
            hintText: "Password",
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
        ],
      ),
    );
  }
}
