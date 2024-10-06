import 'package:flutter/material.dart';
import 'package:chat_app/Helpers/Images.dart';

List<String> emojis = [
  Images.emoji1,
  Images.emoji3,
  Images.emoji4,
  Images.emoji5,
  Images.emoji6,
  Images.emoji7,
  Images.emoji8,
  Images.emoji9,
];

class ToopTipEmoji extends StatelessWidget {
  const ToopTipEmoji({super.key, required this.onPress});
  final void Function(String emoji) onPress;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            for (final emoji in emojis)
              InkWell(
                onTap: () => onPress(emoji),
                child: Image.asset(
                  emoji,
                  height: 25,
                  width: 25,
                ),
              )
          ],
        ),
      ),
    );
  }
}
