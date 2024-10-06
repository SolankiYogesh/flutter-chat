import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/Helpers/Color.dart';
import 'package:chat_app/Helpers/Images.dart';

import 'package:chat_app/Helpers/Utils.dart';
import 'package:chat_app/Models/user_model/UserModel.dart';
import 'package:chat_app/Screens/home_screen/user_item.dart';
import 'package:chat_app/Screens/login_screen/login_screen.dart';

import 'package:quickalert/quickalert.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  void logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      showSnack(context, "User logged out successfully.", SnackBarType.info);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ));
    } catch (e) {
      showSnack(context, "Logout failed: ${e.toString()}", SnackBarType.error);
    }
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
        child: const Icon(Icons.add, color: Colors.white),
      ),
      backgroundColor: const Color(ColorProvider.PrimaryColor),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(ColorProvider.PrimaryColor),
        title: Center(
            child: Text(user?.displayName ?? "",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white))),
        leading: Align(
          alignment: Alignment.centerRight,
          child: CircleAvatar(
            backgroundColor: const Color(ColorProvider.PrimaryColor),
            backgroundImage: user?.photoURL != null && user!.photoURL != ""
                ? NetworkImage(user!.photoURL!)
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

            // Ensure that snapshot has data before accessing it
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("No users found"),
              );
            }

            final userDocs = snapshot.data!.docs
                .where((element) => (element.data() as Map)["uid"] != user?.uid)
                .toList();

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
