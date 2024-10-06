import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/Helpers/Utils.dart';

class FirebaseAuthHandler {
  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
    required File image,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await user!.updateDisplayName(name);
      String url = await FirebaseAuthHandler.uploadImage(image, user.uid);

      await user.updatePhotoURL(url);
      await user.reload();
      await FirebaseFirestore.instance.collection("users").doc(user.uid).set(
          {"username": name, "email": email, "image": url, "uid": user.uid});
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnack(context, "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        showSnack(context, "The account already exists for that email.");
      }
    }

    return user;
  }

  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnack(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showSnack(context, 'Wrong password provided.');
      }
    }

    return user;
  }

  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }

  static Future<String> uploadImage(File imageFile, String uid) async {
    final storageRef =
        FirebaseStorage.instance.ref().child("user_image").child('${uid}.jpg');
    await storageRef.putFile(imageFile);
    String url = await storageRef.getDownloadURL();
    return url;
  }
}
