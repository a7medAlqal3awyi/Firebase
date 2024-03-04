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
  bool isLoading = false;

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
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
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.w),
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
                                isLoading = true;
                                setState(() {});
                                final credential = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: emailController.text,
                                        password: passwordController.text);
                                isLoading = false;
                                setState(() {});

                                if (credential.user!.emailVerified) {
                                  FirebaseAuth.instance.currentUser!
                                      .sendEmailVerification();
                                  context
                                      .pushReplacementNamed(Routes.homeScreen);
                                } else {
                                  FirebaseAuth.instance.currentUser!
                                      .sendEmailVerification();

                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.info,
                                    animType: AnimType.topSlide,
                                    title: 'Failed',
                                    desc: 'Please verify your email first',
                                  ).show();
                                }
                              } on FirebaseAuthException catch (e) {
                                isLoading = false;
                                setState(() {});

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
                                  } else if (e.code == 'wrong-password') {
                                    if (context.mounted) {
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.error,
                                        animType: AnimType.topSlide,
                                        title: 'Failed',
                                        desc:
                                            'Wrong password provided for that user',
                                      ).show();
                                    }
                                    debugPrint(
                                        'Wrong password provided for that user.');
                                  }
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
                            isLoading = true;
                            setState(() {});
                            signInWithGoogle();
                            isLoading = false;
                            setState(() {});
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
