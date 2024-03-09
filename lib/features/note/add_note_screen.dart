import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_app/core/helper/spacing.dart';
import 'package:fire_app/core/widgets/app_text_button.dart';
import 'package:fire_app/core/widgets/app_text_form_feild.dart';
import 'package:fire_app/features/note/note_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/themeing/styles.dart';

class AddNoteScreen extends StatefulWidget {
  final String docId;

  const AddNoteScreen({super.key, required this.docId});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    bool isLoading = false;
    TextEditingController note = TextEditingController();

    addNote() async {
      CollectionReference collectionReference = FirebaseFirestore.instance
          .collection("categories")
          .doc(widget.docId)
          .collection("note");
      if (formKey.currentState!.validate()) {
        try {
          isLoading = true;
          setState(() {});
          DocumentReference response = await collectionReference.add({
            "note": note.text,
          });
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => NoteScreen(
                      categoryId: widget.docId,
                    )),
          );
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

      @override
      void dispose() {
        super.dispose();
        note.dispose();
      }
    }

    return Scaffold(
        appBar: AppBar(title: const Text("Add Note")),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      AppTextFormField(
                        controller: note,
                        hintText: "Add Note",
                        validator: (va) {
                          if (va!.isEmpty) {
                            return "Please Enter Note";
                          }
                          return null;
                        },
                      ),
                      verticalSpacing(10),
                      AppTextButton(
                          buttonWidth: 140,
                          buttonHeight: 60,
                          onPressed: () {
                            addNote();
                          },
                          buttonText: "Add Note",
                          buttonTextStyle: TextStyles.font16WhiteW600)
                    ],
                  ),
          ),
        ));
  }
}
