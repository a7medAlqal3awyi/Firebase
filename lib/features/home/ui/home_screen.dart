import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fire_app/core/helper/exetention.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/routing/routing.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                context.pushReplacementNamed(Routes.loginScreen);
              },
              icon: const Icon(Icons.logout))

   ]   ),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: FirebaseAuth.instance.currentUser!.emailVerified
                  ? GestureDetector(
                onTap: (){
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.info,
                    title: 'Failed',
                    desc:
                    'The password provided is too weak.........',
                  ).show();
                },
                  child: const Text("Welcome to Fire App"))
                  : MaterialButton(
                color: Colors.red,
                  onPressed: () {
                  FirebaseAuth.instance.currentUser!.sendEmailVerification();
                  },
                  child: const Text("Please validate")),
            )
          ],
        ),
      ),
    );
  }
}
