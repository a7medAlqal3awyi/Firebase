import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_app/core/helper/exetention.dart';
import 'package:fire_app/features/note/add_note_screen.dart';
import 'package:fire_app/features/note/edit_note.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/routing/routing.dart';

class NoteScreen extends StatefulWidget {
  final String categoryId;

  const NoteScreen({super.key, required this.categoryId});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;

  geNote() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection('note')
        .get();
    data.addAll(querySnapshot.docs);
    isLoading = false;
    setState(() {});
  }

  List<QueryDocumentSnapshot> catData = [];

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    catData.addAll(querySnapshot.docs);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    geNote();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Note"), actions: [
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
        body: PopScope(
          canPop: false,
          onPopInvoked: (va) {
            context.pushNamedAndRemoveUntil(Routes.homeScreen,
                predicate: (Route<dynamic> route) {
              return false;
            });
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : GridView.builder(
                      itemBuilder: (context, index) {
                        return InkWell(
                          onLongPress: () {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.bottomSlide,
                              title: 'Are you sure?',
                              desc: 'Do you want to delete this Note?',
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
                          //edit Note
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditNoteScreen(
                                    noteId: data[index].id,
                                    categoriesNoteId: widget.categoryId,
                                    value: data[index]['note']),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Card(
                              borderOnForeground: true,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(data[index]['note'].toString()),
                                  ],
                                ),
                              ),
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
        ),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddNoteScreen(
                docId: widget.categoryId,
              ),
            ));
          },
          child: const Icon(Icons.add),
        ));
  }
}
