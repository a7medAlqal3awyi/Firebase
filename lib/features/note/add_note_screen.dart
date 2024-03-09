import 'dart:io';
import 'package:path/path.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_app/core/helper/spacing.dart';
import 'package:fire_app/core/widgets/app_text_button.dart';
import 'package:fire_app/core/widgets/app_text_form_feild.dart';
import 'package:fire_app/features/note/note_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/themeing/styles.dart';

class AddNoteScreen extends StatefulWidget {
  final String docId;

  const AddNoteScreen({super.key, required this.docId});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  var formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController note = TextEditingController();
  File? fileGallery;
  File? file;
  String? url;
  bool? isSelected;

  addNote(context) async {
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
          "url": url ?? "none",
        });
        if (context.mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => NoteScreen(
                      categoryId: widget.docId,
                    )),
          );
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

    @override
    void dispose() {
      super.dispose();
      note.dispose();
    }
  }

  getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageCamera =
        await picker.pickImage(source: ImageSource.camera);
    if (imageCamera != null) {
      file = File(imageCamera!.path);
      var imageName = basename(imageCamera!.path);
      final ref = FirebaseStorage.instance.ref("images").child(imageName);
      await ref.putFile(file!);
      url = await ref.getDownloadURL();
    }
    setState(() {});
  }

  getImageGallery() async {
    final ImagePicker pickerGallary = ImagePicker();
    final XFile? imageGallery =
        await pickerGallary.pickImage(source: ImageSource.gallery);
    if (imageGallery != null) {
      fileGallery = File(imageGallery!.path);
      var imageFromGalleryName = basename(fileGallery!.path);
      final ref =
          FirebaseStorage.instance.ref("images").child(imageFromGalleryName);
      await ref.putFile(fileGallery!);
      url = await ref.getDownloadURL();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Add Note")),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
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
                        verticalSpacing(30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  await getImage();
                                },
                                icon: Icon(
                                  color:
                                      url == null ? Colors.grey : Colors.green,
                                  Icons.camera_alt_outlined,
                                )),
                            AppTextButton(
                                buttonWidth: 140,
                                buttonHeight: 60,
                                onPressed: () {
                                  addNote(context);
                                },
                                buttonText: "Add Note",
                                buttonTextStyle: TextStyles.font16WhiteW600),
                            IconButton(
                              onPressed: () async {
                                await getImageGallery();
                              },
                              icon: Icon(
                                Icons.image_outlined,
                                color: url == null ? Colors.grey : Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ));
  }
}
