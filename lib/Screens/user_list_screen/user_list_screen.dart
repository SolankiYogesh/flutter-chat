import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/Helpers/Color.dart';

import 'package:chat_app/Models/user_model/UserModel.dart';
import 'package:chat_app/Screens/home_screen/user_item.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(ColorProvider.PrimaryColor),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(ColorProvider.PrimaryColor),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            }),
        title: Center(
            child: Text("Add user to chat",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white))),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong"),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final userDocs = snapshot.data!.docs
                .where((element) => (element.data() as Map)["uid"] != user?.uid)
                .toList();

            if (userDocs.isEmpty) {
              return const Center(
                child: Text("No users found."),
              );
            }

            return Align(
              alignment: Alignment.topCenter,
              child: ListView.builder(
                addRepaintBoundaries: false,
                addAutomaticKeepAlives: true,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                cacheExtent: 10,
                itemCount: userDocs.length,
                itemBuilder: (context, index) {
                  final userData = userDocs[index].data() as Map;
                  if (userData == null) {
                    return const SizedBox(); // Return an empty box if userData is null
                  }
                  return UserItem(
                    isFromListScreen: true,
                    user: UserModel(
                      email: userData["email"] ?? "",
                      uid: userData["uid"] ?? "",
                      username: userData["username"] ?? "",
                      image: userData["image"] ?? "",
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
