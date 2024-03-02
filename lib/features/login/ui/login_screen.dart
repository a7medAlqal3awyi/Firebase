import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fire_app/core/helper/exetention.dart';
import 'package:fire_app/core/helper/spacing.dart';
import 'package:fire_app/core/themeing/styles.dart';
import 'package:fire_app/core/widgets/app_text_form_feild.dart';
import 'package:fire_app/features/login/widgets/dont_have_account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/routing/routing.dart';
import '../../../core/widgets/app_text_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObsecure = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();


    if (googleUser== null){
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    context.pushNamedAndRemoveUntil(Routes.homeScreen,
        predicate: (isRoute) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
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
                  AppTextFormField(
                    controller: emailController,
                    hintText: "Email",
                    validator: (val) {
                      if (val == "") {
                        return 'Please enter a valid email ';
                      }
                    },
                  ),
                  verticalSpacing(30),
                  AppTextFormField(
                    validator: (val) {
                      if (val == "") {
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
                        isObsecure
                            ? Icons.remove_red_eye
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  verticalSpacing(30),
              InkWell(
                onTap: () async {
                  if (emailController.text == "") {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Error',
                      desc:
                      "please enter your email.",
                    ).show();
                    return;
                  }

                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: emailController.text);
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      animType: AnimType.rightSlide,
                      title: 'Success',
                      desc:
                      'Please checck your email to reset your password',
                    ).show();
                  } catch (e) {
                    AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc:
                        "Something went wrong.Please try again.",)
                        .show();
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(8.w),
                  alignment: AlignmentDirectional.centerEnd,
                    child: Text("Forget Password",
                    style: TextStyles.font14darkBlueW500,)),
              ),
                  verticalSpacing(20),
                  AppTextButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        try {
                          final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );

                          if (credential.user!.emailVerified) {
                            FirebaseAuth.instance.currentUser!.sendEmailVerification();
                            context.pushReplacementNamed(Routes.homeScreen);
                          } else {
                            FirebaseAuth.instance.currentUser!.sendEmailVerification();

                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.info,
                              animType: AnimType.topSlide,
                              title: 'Failed',
                              desc: 'Please verify your email first',
                            ).show();
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            debugPrint('No user found for that email.');

                            if (context.mounted) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.topSlide,
                                title: 'Failed',
                                desc: 'No user found for that email',
                              ).show();
                            }
                          } else if (e.code == 'wrong-password') {
                            if (context.mounted) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.topSlide,
                                title: 'Failed',
                                desc: 'Wrong password provided for that user',
                              ).show();
                            }

                            debugPrint('Wrong password provided for that user.');
                          }
                        }
                      } else {
                        debugPrint('Not valid user');
                      }


                    },
                    buttonText: 'Login',
                    buttonTextStyle: TextStyles.font16WhiteW600,
                  ),
                  verticalSpacing(20),
                  AppTextButton(
                    widget: SvgPicture.asset("assets/svgs/google.svg"),
                    backgroundColor: Colors.blueGrey,
                    onPressed: () {
                      signInWithGoogle();
                    },
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
      ),
    );
  }
}
