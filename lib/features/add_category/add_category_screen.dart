import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_app/core/helper/exetention.dart';
import 'package:fire_app/core/helper/spacing.dart';
import 'package:fire_app/core/routing/routing.dart';
import 'package:fire_app/core/widgets/app_text_button.dart';
import 'package:fire_app/core/widgets/app_text_form_feild.dart';
import 'package:flutter/material.dart';

import '../../../core/themeing/styles.dart';

class AddCategoryScreen extends StatelessWidget {
  const AddCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();

    TextEditingController controller = TextEditingController();
    CollectionReference categories =
        FirebaseFirestore.instance.collection('categories');
    addCategory() async {
      if (formKey.currentState!.validate()) {
        try {
          // Call the user's CollectionReference to add a new user
          DocumentReference doc = await categories.add({
            "category": controller.text,
          });
          if (context.mounted) context.pushReplacementNamed(Routes.homeScreen);
          print("successfully added");
        } catch (e) {
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

    return Scaffold(
        appBar: AppBar(title: const Text("Add Category")),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
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
