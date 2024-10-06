import 'package:flutter/material.dart';
import 'package:chat_app/Helpers/Color.dart';
import 'package:chat_app/Helpers/Images.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(top: 0, bottom: 60, left: 40, right: 40),
      decoration: const BoxDecoration(
          color: Color(ColorProvider.PrimaryColor),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(70))),
      child: Stack(
        children: [
          Center(
              child: Image.asset(
            Images.logo,
            width: 100,
            height: 100,
          )),
          Positioned(
              bottom: 0,
              right: 0,
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white),
              ))
        ],
      ),
    );
  }
}
