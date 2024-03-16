import 'dart:io';
import 'package:path/path.dart';
import 'package:fire_app/core/helper/spacing.dart';
import 'package:fire_app/core/widgets/app_text_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'core/themeing/styles.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
// Pick an image.
  //final XFile? imageGallery = await picker.pickImage(source: ImageSource.gallery);
// Capture a photo.

  File? fileGallery;
  File? file;
  String? url;

  getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageCamera =
        await picker.pickImage(source: ImageSource.camera);
    if (imageCamera != null) {
      file = File(imageCamera.path);
      var imageName = basename(imageCamera.path);
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
    fileGallery = File(imageGallery!.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Picker"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppTextButton(
                  onPressed: () {
                    getImage();
                  },
                  buttonText: 'Get Image from Camera',
                  buttonWidth: 300,
                  buttonTextStyle: TextStyles.font16WhiteW600,
                ),
                if (url != null)
                  Image.network(
                    url!,
                    height: 500,
                  ),
                verticalSpacing(20),
                AppTextButton(
                  onPressed: () {
                    getImageGallery();
                  },
                  buttonText: 'Get Image from Gallery',
                  buttonWidth: 300,
                  buttonTextStyle: TextStyles.font16WhiteW600,
                ),
                if (fileGallery != null)
                  Image.file(
                    fileGallery!,
                    height: 500,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
