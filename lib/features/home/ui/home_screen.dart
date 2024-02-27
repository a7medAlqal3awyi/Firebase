import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_app/core/helper/exetention.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/routing/routing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;
  getData() async {

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('categories').get();
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
            child: isLoading? const Center(child: CircularProgressIndicator(),): GridView.builder(
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      Image.asset("assets/images/folder.png"),
                      Text(data[index]['category'].toString()),
                    ],
                  ),
                );
              },
              itemCount: data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisExtent: 200, crossAxisSpacing: 8),
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
