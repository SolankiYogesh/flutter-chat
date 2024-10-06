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
      // Create a new user with email and password
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;

      if (user != null) {
        // Update display name
        await user.updateDisplayName(name);

        // Upload image and get URL
        String url = await uploadImage(image, user.uid);

        // Update user photo URL
        await user.updatePhotoURL(url);

        // Reload user to get updated info
        await user.reload();

        // Save user info to Firestore
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "username": name,
          "email": email,
          "image": url,
          "uid": user.uid,
        });

        // Get the updated user
        user = auth.currentUser;
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e, context);
    } catch (e) {
      // Handle any unexpected errors
      showSnack(context, "An unexpected error occurred: ${e.toString()}");
    }

    return user; // Return user only if registration and data saving were successful
  }

  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      // Sign in with email and password
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e, context);
    } catch (e) {
      // Handle any unexpected errors
      showSnack(context, "An unexpected error occurred: ${e.toString()}");
    }

    return user; // Return the user object if sign-in is successful
  }

  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser; // Return the refreshed user
  }

  static Future<String> uploadImage(File imageFile, String uid) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("user_image")
          .child('${uid}.jpg');

      // Upload the file
      await storageRef.putFile(imageFile);

      // Get the download URL
      String url = await storageRef.getDownloadURL();
      return url;
    } catch (e) {
      // Handle any errors during image upload
      throw Exception("Image upload failed: ${e.toString()}");
    }
  }

  static void _handleAuthError(FirebaseAuthException e, BuildContext context) {
    // Handle authentication errors
    switch (e.code) {
      case 'weak-password':
        showSnack(context, "The password provided is too weak.");
        break;
      case 'email-already-in-use':
        showSnack(context, "The account already exists for that email.");
        break;
      case 'user-not-found':
        showSnack(context, 'No user found for that email.');
        break;
      case 'wrong-password':
        showSnack(context, 'Wrong password provided.');
        break;
      default:
        showSnack(context, "Authentication error: ${e.message}");
    }
  }
}
