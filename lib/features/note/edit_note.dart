import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_app/core/helper/spacing.dart';
import 'package:fire_app/core/widgets/app_text_button.dart';
import 'package:fire_app/core/widgets/app_text_form_feild.dart';
import 'package:fire_app/features/note/note_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/themeing/styles.dart';

class EditNoteScreen extends StatefulWidget {
  final String noteId;
  final String value;
  final String categoriesNoteId;

  const EditNoteScreen(
      {super.key,
      required this.noteId,
      required this.categoriesNoteId,
      required this.value});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    bool isLoading = false;
    TextEditingController controller = TextEditingController();

    editNote() async {
      CollectionReference categories = FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.categoriesNoteId)
          .collection('note');
      print("*****************************widget.noteId");
      print(widget.noteId);
      if (formKey.currentState!.validate()) {
        try {
          isLoading = true;
          setState(() {});
          await categories.doc(widget.noteId).update({
            "note": controller.text,
          });
          isLoading = true;
          print("successfully added");
          if (context.mounted) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    NoteScreen(categoryId: widget.categoriesNoteId)));
          }
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
    void dispose() {
      super.dispose();
      controller.dispose();
    }

    @override
    void initState() {
      super.initState();
      controller.text = widget.value;
    }

    return Scaffold(
        appBar: AppBar(title: const Text("Edit Note")),
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
                        hintText: widget.value,
                          validator: (va) {
                            if (va!.isEmpty) {
                              return "Please Enter Note";
                            }
                            return null;
                          },
                      ),
                      verticalSpacing(10),
                      AppTextButton(
                          buttonWidth: 100,
                          onPressed: () {
                            editNote();
                          },
                          buttonText: "Edit",
                          buttonTextStyle: TextStyles.font16WhiteW600)
                    ],
                  ),
          ),
        ));
  }
}
