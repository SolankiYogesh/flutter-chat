import 'dart:math';
import 'package:flutter/material.dart';

enum SnackBarType { error, info, success }

Map<SnackBarType, Color> SnackBarTypeValue = {
  SnackBarType.error: Colors.red,
  SnackBarType.info: Colors.blueAccent,
  SnackBarType.success: Colors.green,
};

String getBotResponse() {
  List<String> responses = [
    "Hello!",
    "How can I help you?",
    "Nice to meet you!",
    "What's up?",
    "Flutter is awesome!",
    "Have a great day!",
    "Tell me more!",
    "That's interesting!",
  ];

  // Generate a random index within the range of the responses list.
  Random random = Random();
  int randomIndex = random.nextInt(responses.length);

  // Return the randomly selected response.
  return responses[randomIndex];
}

int getColor(String color) {
  return int.parse("0xFF$color");
}

void showSnack(BuildContext context, String text,
    [SnackBarType type = SnackBarType.error]) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    backgroundColor: SnackBarTypeValue[type],
  ));
}

void showLoader(
  BuildContext context,
  bool isLoading,
) {
  showGeneralDialog(
    context: context,
    barrierColor: Colors.black12.withOpacity(0.6), // Background color
    barrierDismissible: false,
    barrierLabel: 'Dialog',
    transitionDuration: Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      return Column(
        children: <Widget>[
          const Expanded(
            flex: 5,
            child: SizedBox.expand(child: FlutterLogo()),
          ),
          Expanded(
            flex: 1,
            child: SizedBox.expand(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Dismiss'),
              ),
            ),
          ),
        ],
      );
    },
  );
}
