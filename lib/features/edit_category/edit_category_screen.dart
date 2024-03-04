import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_app/core/helper/exetention.dart';
import 'package:fire_app/core/helper/spacing.dart';
import 'package:fire_app/core/routing/routing.dart';
import 'package:fire_app/core/widgets/app_text_button.dart';
import 'package:fire_app/core/widgets/app_text_form_feild.dart';
import 'package:flutter/material.dart';

import '../../../core/themeing/styles.dart';

class EditCategoryScreen extends StatefulWidget {
  final String docId;
  final String oldName;

  const EditCategoryScreen(
      {super.key, required this.docId, required this.oldName});

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    bool isLoading = false;
    TextEditingController controller = TextEditingController();
    CollectionReference categories =
        FirebaseFirestore.instance.collection('categories');
    editCategory() async {
      if (formKey.currentState!.validate()) {
        try {
          var response = await categories.doc(widget.docId).update({
            "category": controller.text,
          });
          isLoading = true;
          if (context.mounted) {
            context.pushNamedAndRemoveUntil(Routes.homeScreen,
                predicate: (isRoute) => false);
          }
          print("successfully added");
        } catch (e) {
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
    void initState() {
      super.initState();
      controller.text = widget.oldName;
    }

    @override
    void dispose() {
      super.dispose();
      controller.dispose();
    }

    return Scaffold(
        appBar: AppBar(title: const Text("Edit Category")),
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
                        hintText: widget.oldName,
                        validator: (va) {
                          if (va == "") return "Please,Enter valid text. ";
                        },
                      ),
                      verticalSpacing(10),
                      AppTextButton(
                          buttonWidth: 100,
                          onPressed: () {
                            editCategory();
                          },
                          buttonText: "Edit",
                          buttonTextStyle: TextStyles.font16WhiteW600)
                    ],
                  ),
          ),
        ));
  }
}
