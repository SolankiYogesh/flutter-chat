import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  const ChatInput(
      {super.key, required this.onPressSend, required this.msgController});

  final void Function() onPressSend;
  final TextEditingController msgController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: msgController,
            decoration: InputDecoration(
              hintText: 'Type a message...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            ),
            onSubmitted: (_) => onPressSend(),
          ),
        ),
        const SizedBox(width: 8.0),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: msgController,
          builder: (context, value, child) {
            return InkWell(
              onTap: value.text.isEmpty ? () => {} : onPressSend,
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: value.text.isEmpty ? Colors.grey : Colors.blue,
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
