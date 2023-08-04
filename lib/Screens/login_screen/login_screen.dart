import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:folder_stucture/Helpers/Color.dart';

import 'package:folder_stucture/Helpers/Utils.dart';
import 'package:folder_stucture/Helpers/firebase_auth.dart';
import 'package:folder_stucture/Helpers/validator.dart';
import 'package:folder_stucture/Screens/home_screen/home_screen.dart';

import 'package:folder_stucture/Screens/login_screen/welcome_view.dart';
import 'package:folder_stucture/Screens/register_screen/register_screen.dart';
import 'package:folder_stucture/components/LoaderHandler.dart';
import 'package:folder_stucture/components/button.dart';
import 'package:folder_stucture/components/loader.dart';
import 'package:folder_stucture/components/text_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoaderState loader = LoaderState();

  bool isLoading = false;
  late FocusNode passwordNode;

  @override
  void initState() {
    super.initState();

    passwordNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    passwordNode.dispose();
  }

  void onPressRegister(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      ),
    );
  }

  void onPressLogin(BuildContext context) async {
    final String email = emailController.value.text;
    final String password = passwordController.value.text;

    var isEmail = Validator.validateEmail(email: email);
    var isPassword = Validator.validatePassword(password: password);

    if (isEmail != null) {
      showSnack(context, isEmail);
      return;
    }
    if (isPassword != null) {
      showSnack(context, isPassword);
      return;
    }

    loader.activate();
    LoaderHanlder().isLoading(true);

    User? user = await FirebaseAuthHandler.signInUsingEmailPassword(
        email: email, password: password, context: context);
    LoaderHanlder().isLoading(false);

    if (user != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ));
    }
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
                      const WelcomeView(title: "Login"),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 25,
                            ),
                            TextInput(
                                keyboardType: TextInputType.emailAddress,
                                controller: emailController,
                                icon: Icons.email,
                                placeHolder: "Email",
                                onSubmitted: (_) =>
                                    passwordNode.requestFocus()),
                            const SizedBox(
                              height: 25,
                            ),
                            TextInput(
                                focusNode: passwordNode,
                                controller: passwordController,
                                icon: Icons.lock,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => onPressLogin(context),
                                keyboardType: TextInputType.visiblePassword,
                                placeHolder: "Password",
                                isPassword: true),
                            const SizedBox(
                              height: 25,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                child: Text(
                                  "Forgot Password?",
                                  textAlign: TextAlign.end,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: const Color(
                                            ColorProvider.PrimaryColor),
                                      ),
                                ),
                              ),
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
                      isDisabled: false,
                      onPress: () => onPressLogin(context),
                      title: "Login",
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
                        const Text("Don't have account ?"),
                        const SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () => onPressRegister(context),
                          child: Text(
                            "Register",
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
