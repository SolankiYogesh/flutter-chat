import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:folder_stucture/Helpers/Color.dart';

import 'package:folder_stucture/Helpers/Utils.dart';
import 'package:folder_stucture/Helpers/firebase_auth.dart';
import 'package:folder_stucture/Helpers/validator.dart';
import 'package:folder_stucture/Screens/home_screen/home_screen.dart';

import 'package:folder_stucture/Screens/login_screen/welcome_view.dart';
import 'package:folder_stucture/components/button.dart';
import 'package:folder_stucture/components/text_input.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  File? image;

  late FocusNode emailnode;
  late FocusNode passwordNode;
  @override
  void initState() {
    super.initState();
    passwordNode = FocusNode();
    emailnode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    passwordNode.dispose();
    emailnode.dispose();
  }

  void onPressImage(BuildContext context) async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img == null) return;
      final imageTemp = File(img.path);
      setState(() => image = imageTemp);
    } catch (e) {
      showSnack(context, 'Failed to pick image: $e');
    }
  }

  void onPressLogin(BuildContext context) {
    Navigator.of(context).pop();
  }

  void onPressRegister(BuildContext context) async {
    final String name = nameController.value.text;
    final String email = emailController.value.text;
    final String password = passwordController.value.text;
    var isName = Validator.validateName(name: name);
    var isEmail = Validator.validateEmail(email: email);
    var isPassword = Validator.validatePassword(password: password);
    if (isName != null) {
      showSnack(context, isName);
      return;
    }
    if (isEmail != null) {
      showSnack(context, isEmail);
      return;
    }
    if (isPassword != null) {
      showSnack(context, isPassword);
      return;
    }
    if (image == null) {
      showSnack(context, "Please select your profile picture");
      return;
    }
    User? user = await FirebaseAuthHandler.registerUsingEmailPassword(
        name: name,
        email: email,
        password: password,
        context: context,
        image: image!);
    if (user != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(ColorProvider.PrimaryColor),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          color: const Color(ColorProvider.BackgroundColor),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const WelcomeView(title: "Register"),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 25,
                            ),
                            InkWell(
                                onTap: () => onPressImage(context),
                                child: CircleAvatar(
                                  backgroundColor:
                                      const Color(ColorProvider.PrimaryColor),
                                  backgroundImage:
                                      image != null ? FileImage(image!) : null,
                                  radius: 40,
                                  child: image == null
                                      ? const Icon(Icons.camera_alt)
                                      : null,
                                )),
                            const SizedBox(
                              height: 25,
                            ),
                            TextInput(
                              controller: nameController,
                              icon: Icons.person,
                              onSubmitted: (_) => emailnode.requestFocus(),
                              keyboardType: TextInputType.name,
                              placeHolder: "Full name",
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            TextInput(
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              icon: Icons.email,
                              focusNode: emailnode,
                              onSubmitted: (_) => passwordNode.requestFocus(),
                              placeHolder: "Email",
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            TextInput(
                              controller: passwordController,
                              icon: Icons.lock,
                              textInputAction: TextInputAction.done,
                              focusNode: passwordNode,
                              onSubmitted: (_) => onPressRegister(context),
                              keyboardType: TextInputType.visiblePassword,
                              placeHolder: "Password",
                              isPassword: true,
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AppButton(
                      isDisabled: isLoading,
                      onPress: () => onPressRegister(context),
                      title: "Register",
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have account ?"),
                        const SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () => onPressLogin(context),
                          child: Text(
                            "Login",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color:
                                      const Color(ColorProvider.PrimaryColor),
                                ),
                          ),
                        )
                      ],
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
