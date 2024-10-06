import 'package:chat_app/components/overlay_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/Models/user_model/UserModel.dart';
import 'package:chat_app/Screens/user_detail_screen/user_detail_screen.dart';

class UserItem extends StatelessWidget {
  UserItem({super.key, required this.user, required this.isFromListScreen});
  final UserModel user;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final bool isFromListScreen;
  final OverlayLoader _overlayLoader = OverlayLoader();

  Future<void> onPress(BuildContext context) async {
    if (!isFromListScreen) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => UserDetailScreen(
                user: user,
              )));
    } else {
      _overlayLoader.show(context);
      await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "added_by": currentUser!.uid,
      }, SetOptions(merge: true));
      _overlayLoader.hide();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPress(context),
      child: ListTile(
        leading: Hero(
          tag: user.uid.toString(),
          child: CircleAvatar(
            backgroundImage: NetworkImage(user.image!),
          ),
        ),
        title: Text(user.username ?? ''),
        subtitle: !isFromListScreen
            ? Text(user.last_msg ?? 'Hey there!')
            : Text(user.email ?? ''),
      ),
    );
  }
}
