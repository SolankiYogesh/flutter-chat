import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/Helpers/Color.dart';

import 'package:chat_app/Models/user_model/ChatModel.dart';
import 'package:chat_app/Screens/user_detail_screen/chat_item.dart';
import 'package:chat_app/components/chat_input.dart';

import '../../Models/user_model/UserModel.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({super.key, required this.user});
  final UserModel user;

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final msgController = TextEditingController();

  final ScrollController _controller = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setupNotification();
  }

  void setupNotification() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
  }

  @override
  void dispose() {
    msgController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void onPressSend() async {
    String text = msgController.value.text;
    if (text.isNotEmpty && text != "") {
      msgController.clear();
      await FirebaseFirestore.instance.collection("chat").add({
        "text": text,
        "createdAt": DateTime.now().toString(),
        "uid": currentUser?.uid ?? "",
        "username": currentUser?.displayName ?? "",
        "uImage": currentUser?.photoURL ?? "",
      });

      if (_controller.hasClients) {
        _controller.animateTo(
          _controller.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(ColorProvider.PrimaryColor),
        title: Row(
          children: [
            Hero(
              tag: widget.user.uid.toString(),
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.user.image!),
              ),
            ),
            const SizedBox(width: 8),
            Text(widget.user.username!),
          ],
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chat")
                    .orderBy("createdAt", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("Start Chatting....."),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Something went wrong"),
                    );
                  }
                  final chats = snapshot.data!.docs;
                  return Expanded(
                    flex: 1,
                    child: ListView.builder(
                      addRepaintBoundaries: false,
                      addAutomaticKeepAlives: true,
                      controller: _controller,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      cacheExtent: 10,
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        return ChatItem(
                          chat: ChatModel(
                              text: chats[index].data()["text"],
                              uid: chats[index].data()["uid"],
                              createdAt: DateTime.parse(
                                  chats[index].data()["createdAt"]),
                              username: chats[index].data()["username"],
                              uImage: chats[index].data()["uImage"]),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.grey[200],
              child: ChatInput(
                  msgController: msgController,
                  onPressSend: () => onPressSend()),
            )
          ],
        ),
      ),
    );
  }
}
