import 'package:connecthub/constants/constants.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final String userImage;
  final String userName;
  final bool isMe;
  const MessageBubble({
    super.key,
    required this.text,
    required this.userName,
    required this.userImage,
    required this.isMe,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        !isMe
            ? CircleAvatar(
                backgroundImage: NetworkImage(userImage),
              )
            : Container(),
        Container(
          decoration: BoxDecoration(
            color: isMe
                ? MyColors.tercharyColor.withOpacity(0.2)
                : MyColors.buttonColor1.withOpacity(0.3),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft:
                  !isMe ? const Radius.circular(0) : const Radius.circular(12),
              bottomRight:
                  isMe ? const Radius.circular(0) : const Radius.circular(12),
            ),
          ),
          width: MediaQuery.of(context).size.width * 0.45,
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          margin: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 8,
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: MyFonts.bodyFont(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                text,
                style: MyFonts.bodyFont(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
