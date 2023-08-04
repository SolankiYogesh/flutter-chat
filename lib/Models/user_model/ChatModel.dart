import 'dart:convert';

class ChatModel {
  String text;
  DateTime createdAt;
  String uid;
  String username;
  String uImage;
  String? react;

  ChatModel({
    required this.text,
    required this.createdAt,
    required this.uid,
    required this.username,
    required this.uImage,
    this.react,
  });

  // Convert ChatModel to a Map<String, dynamic> (JSON)
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'createdAt': createdAt,
      'uid': uid,
      'username': username,
      'uImage': uImage,
      'react': react,
    };
  }

  // Create ChatModel from a JSON string
  factory ChatModel.fromJson(String jsonString) {
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return ChatModel(
      text: jsonMap['text'],
      createdAt: jsonMap['createdAt'],
      uid: jsonMap['uid'],
      username: jsonMap['username'],
      uImage: jsonMap['uImage'],
      react: jsonMap['react'],
    );
  }
}
