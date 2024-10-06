import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/Helpers/Color.dart';
import 'package:chat_app/Models/user_model/ChatModel.dart';
import 'package:chat_app/components/toop_tip.dart';

import 'package:intl/intl.dart';
import 'package:super_tooltip/super_tooltip.dart';

class ChatItem extends StatefulWidget {
  const ChatItem({super.key, required this.chat});
  final ChatModel chat;

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  void onPressEmoji(String emoji, SuperTooltipController? controller) {
    setState(() {
      widget.chat.react = emoji;
    });

    if (controller != null) {
      controller.hideTooltip();
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bool isMe = currentUser!.uid == widget.chat.uid;

    String format = DateFormat('hh:mm a').format(widget.chat.createdAt);
    double screenWidth = MediaQuery.of(context).size.width;
    final controller = SuperTooltipController();

    return GestureDetector(
      onTap: () async {
        await controller.showTooltip();
      },
      child: SuperTooltip(
        arrowLength: 0,
        arrowTipDistance: 10,
        barrierColor: Colors.transparent,
        borderWidth: 0,
        backgroundColor: Colors.grey,
        borderRadius: 20,
        borderColor: Colors.grey,
        controller: controller,
        hasShadow: false,
        content: Padding(
          padding: EdgeInsets.zero,
          child: ToopTipEmoji(onPress: (e) => onPressEmoji(e, controller)),
        ),
        child: GestureDetector(
          onLongPress: () {
            controller.showTooltip();
          },
          child: Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      constraints: BoxConstraints(
                        maxWidth: screenWidth * 0.8,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft:
                                isMe ? const Radius.circular(20) : Radius.zero,
                            bottomRight:
                                isMe ? Radius.zero : const Radius.circular(20),
                            topLeft: const Radius.circular(20),
                            topRight: const Radius.circular(20)),
                        color: isMe
                            ? const Color(0xFF1C2E46)
                            : const Color(0xFF090E15),
                      ),
                      margin: EdgeInsets.only(
                          left: isMe ? 0 : 10,
                          right: isMe ? 10 : 0,
                          top: 10,
                          bottom: 10),
                      child: Text(
                        widget.chat.text,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: Colors.white),
                        textAlign: isMe ? TextAlign.right : TextAlign.left,
                      ),
                    ),
                    Text(
                      format,
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: const Color(ColorProvider.BorderColor)),
                      textAlign: isMe ? TextAlign.right : TextAlign.left,
                    )
                  ],
                ),
                if (widget.chat.react != "" && widget.chat.react != null)
                  Positioned(
                    right: isMe ? null : 0,
                    bottom: 10,
                    child: InkWell(
                      onTap: () => onPressEmoji("", null),
                      child: Image.asset(
                        widget.chat.react ?? "",
                        height: 25,
                        width: 25,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
