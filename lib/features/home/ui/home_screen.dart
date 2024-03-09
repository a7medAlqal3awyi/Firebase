import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_app/core/helper/exetention.dart';
import 'package:fire_app/features/note/add_note_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/routing/routing.dart';
import '../../../core/themeing/styles.dart';
import '../../../core/widgets/app_text_button.dart';
import '../../edit_category/edit_category_screen.dart';
import '../../note/note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data.addAll(querySnapshot.docs);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Home"), actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                final GoogleSignIn googleUser = GoogleSignIn();
                await googleUser.disconnect();
                if (context.mounted) {
                  context.pushReplacementNamed(Routes.loginScreen);
                }
              },
              icon: const Icon(Icons.logout))
        ]),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NoteScreen(
                              categoryId: data[index].id,
                            ),
                          ));
                        },
                        onLongPress: () {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            animType: AnimType.bottomSlide,
                            title: 'Are you sure?',
                            desc: 'Do you want to delete this category?',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () async {
                              await FirebaseFirestore.instance
                                  .collection('categories')
                                  .doc(data[index].id)
                                  .delete();
                              data.removeAt(index);
                              setState(() {});
                            },
                          ).show();
                        },
                        child: Card(
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset("assets/images/folder.png"),
                                  Text(data[index]['category'].toString()),
                                ],
                              ),
                              Positioned(
                                right: 0,
                                top: -5,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => EditCategoryScreen(
                                        docId: data[index].id,
                                        oldName: '${data[index]['category']}',
                                      ),
                                    ));
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: data.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 200,
                            crossAxisSpacing: 8),
                  ),
          ),
        ),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.pushNamed(Routes.addCategoryScreen);
          },
          child: const Icon(Icons.add),
        ));
  }
}
