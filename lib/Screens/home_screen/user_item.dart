import 'package:flutter/material.dart';
import 'package:folder_stucture/Models/user_model/UserModel.dart';
import 'package:folder_stucture/Screens/user_detail_screen/user_detail_screen.dart';

class UserItem extends StatelessWidget {
  const UserItem({super.key, required this.user});
  final UserModel user;

  void onPress(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => UserDetailScreen(
              user: user,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPress(context),
      child: ListTile(
        leading: Hero(
          tag: user.uid.toString(),
          child: CircleAvatar(
            backgroundImage: NetworkImage(user.image!),
            // Replace with your image URL
          ),
        ),
        title: Text(user.username ?? ''),
        subtitle: Text(user.email ?? ''),
        // Add more UI elements as needed for each user
      ),
    );
  }
}
