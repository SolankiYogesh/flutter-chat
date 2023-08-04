import 'package:flutter/material.dart';
import 'package:folder_stucture/Helpers/Color.dart';

class TextInput extends StatelessWidget {
  const TextInput(
      {Key? key,
      required this.icon,
      required this.placeHolder,
      this.isPassword = false,
      this.controller,
      this.keyboardType = TextInputType.text,
      this.focusNode,
      this.onSubmitted,
      this.textInputAction = TextInputAction.next})
      : super(key: key);
  final IconData icon;
  final String placeHolder;
  final bool? isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final FocusNode? focusNode;
  final void Function(String)? onSubmitted;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      shadowColor: Colors.white,
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(ColorProvider.BorderColor),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: TextField(
                onSubmitted: onSubmitted,
                focusNode: focusNode,
                textInputAction: textInputAction,
                keyboardType: keyboardType,
                controller: controller,
                obscureText: isPassword!,
                decoration: InputDecoration.collapsed(
                    hintText: placeHolder,
                    hintStyle: const TextStyle(
                        color: Color(ColorProvider.BorderColor))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
