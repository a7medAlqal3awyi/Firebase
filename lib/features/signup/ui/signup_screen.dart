import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fire_app/core/helper/exetention.dart';
import 'package:fire_app/features/signup/ui/widgets/already_have_acc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helper/spacing.dart';
import '../../../core/routing/routing.dart';
import '../../../core/themeing/styles.dart';
import '../../../core/widgets/app_text_button.dart';
import '../../../core/widgets/app_text_form_feild.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isObsecure = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.w),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create Account",
                    style: TextStyles.font24BlueW700,
                  ),
                  verticalSpacing(8),
                  Text(
                    "Sign up now and start exploring all that our app has to offer. We're excited to welcome you to our community!",
                    style: TextStyles.font14GreyW400,
                  ),
                  verticalSpacing(30),
                  AppTextFormField(
                    controller: nameController,
                    hintText: "User Name",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid name ';
                      }
                    },
                  ),
                  verticalSpacing(30),
                  AppTextFormField(
                    controller: emailController,
                    hintText: "Email",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid email ';
                      }
                    },                  ),
                  verticalSpacing(30),
                  AppTextFormField(
                    controller: passwordController,
                    hintText: "Password",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid password ';
                      }
                    },
                    isSecureText: isObsecure,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isObsecure = !isObsecure;
                        });
                      },
                      icon: Icon(
                        isObsecure
                            ? Icons.remove_red_eye
                            : Icons.visibility_off,
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
                    onPressed: () async {
                       if (formKey.currentState!.validate()) {
                        try {
                          final credential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          FirebaseAuth.instance.currentUser!.sendEmailVerification();
                          context.pushReplacementNamed(Routes.loginScreen);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            if (context.mounted) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.topSlide,
                                title: 'Failed',
                                desc:
                                    'The password provided is too weak.........',
                              ).show();
                            }

                            print('The password provided is too weak.');
                          } else if (e.code == 'email-already-in-use') {
                            if (context.mounted) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.topSlide,
                                title: 'Failed',
                                desc:
                                    'The account already exists for that email',
                              ).show();
                            }
                            print('The account already exists for that email.');
                          }
                        } catch (e) {
                          print(e);
                        }
                      } else {
                        debugPrint("Please enter a valid email and password");
                      }
                    },
                    buttonText: 'Register',
                    buttonTextStyle: TextStyles.font16WhiteW600,
                  ),
                  verticalSpacing(20),
                  const AlreadyHaveAnAccount()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
