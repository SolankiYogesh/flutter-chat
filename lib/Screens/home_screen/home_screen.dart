import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:folder_stucture/Helpers/Color.dart';
import 'package:folder_stucture/Helpers/Images.dart';

import 'package:folder_stucture/Helpers/Utils.dart';
import 'package:folder_stucture/Models/user_model/UserModel.dart';
import 'package:folder_stucture/Screens/home_screen/user_item.dart';
import 'package:folder_stucture/Screens/login_screen/login_screen.dart';

import 'package:quickalert/quickalert.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<UserModel> users = [];

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  void logOut() async {
    FirebaseAuth.instance.signOut().then((value) {
      showSnack(context, "User logged out successfully.", SnackBarType.info);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ));
    });
  }

  void showAlert(BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Do you want to logout',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      onConfirmBtnTap: () async {
        logOut();
        Navigator.pop(context);
      },
      confirmBtnColor: Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(ColorProvider.PrimaryColor),
        child: const Icon(Icons.add),
      ),
      backgroundColor: const Color(ColorProvider.PrimaryColor),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(ColorProvider.PrimaryColor),
        title: Center(child: Text(user!.displayName ?? "")),
        leading: Align(
          alignment: Alignment.centerRight,
          child: CircleAvatar(
            backgroundColor: const Color(ColorProvider.PrimaryColor),
            backgroundImage: user!.photoURL != null && user!.photoURL != ""
                ? NetworkImage(user!.photoURL ?? "")
                : Image.asset(Images.user).image,
            radius: 25,
          ),
        ),
        actions: [
          Container(
            width: 40,
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                color: Color(0xFF344859),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: InkWell(
              onTap: () => showAlert(context),
              child: const Icon(
                Icons.power_settings_new_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snapshot) {
            final users = (snapshot.data!.docs)
                .where((element) =>
                    element.data()["uid"].compareTo(user!.uid) != 0)
                .toList();
            if (!snapshot.hasData || users.isEmpty) {
              return const Center(
                child: Text("No users found"),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong"),
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
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return UserItem(
                    user: UserModel(
                        email: users[index].data()["email"],
                        uid: users[index].data()["uid"],
                        username: users[index].data()["username"],
                        image: users[index].data()["image"]),
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
