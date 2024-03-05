import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_app/core/helper/exetention.dart';
import 'package:fire_app/core/helper/spacing.dart';
import 'package:fire_app/core/routing/routing.dart';
import 'package:fire_app/core/widgets/app_text_button.dart';
import 'package:fire_app/core/widgets/app_text_form_feild.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/themeing/styles.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    bool isLoading = false;
    TextEditingController controller = TextEditingController();
    CollectionReference categories =
        FirebaseFirestore.instance.collection('categories');
    addCategory() async {
      if (formKey.currentState!.validate()) {
        try {
          // Call the user's CollectionReference to add a new user
          DocumentReference doc = await categories.add({
            "category": controller.text,
            "id": FirebaseAuth.instance.currentUser!.uid,
          });
          isLoading = true;
          setState(() {});
          if (context.mounted) {
            context.pushNamedAndRemoveUntil(Routes.homeScreen,
                predicate: (isRoute) => false);
          }
          print("successfully added");
        } catch (e) {
          isLoading = true;
          setState(() {});
          if (context.mounted) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.topSlide,
              title: 'Failed',
              desc: e.toString(),
            ).show();
            print(e);
          }
        }
      }
    }

    @override
    void dispose() {
      super.dispose();
      controller.dispose();
    }

    return Scaffold(
        appBar: AppBar(title: const Text("Add Category")),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      AppTextFormField(
                        controller: controller,
                        hintText: "Add Category",
                        validator: (va) {},
                      ),
                      verticalSpacing(10),
                      AppTextButton(
                          buttonWidth: 100,
                          onPressed: () {
                            addCategory();
                          },
                          buttonText: "Add",
                          buttonTextStyle: TextStyles.font16WhiteW600)
                    ],
                  ),
          ),
        ));
  }
}
