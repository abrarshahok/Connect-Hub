import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub/constants/constants.dart';
import 'package:connecthub/features/chat/data/message_repository.dart';
import 'package:connecthub/features/chat/domain/message.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '/features/auth/data/auth_repository.dart';

class NewMessage extends StatefulWidget {
  final String currentUserId;
  final String friendUserId;

  const NewMessage({
    super.key,
    required this.currentUserId,
    required this.friendUserId,
  });
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final messageController = TextEditingController();
  String enteredMessage = '';

  String get chatRoomId {
    if (widget.currentUserId.compareTo(widget.friendUserId) > 0) {
      return '${widget.currentUserId}-${widget.friendUserId}';
    }
    return '${widget.friendUserId}-${widget.currentUserId}';
  }

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final message = Message(
      text: enteredMessage,
      imageUrl: AuthRepository.currentUser!.userImage,
      senderId: widget.currentUserId,
      time: Timestamp.now(),
    );
    MessageRepository.sendMessage(chatRoomId: chatRoomId, message: message);

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: MyColors.tercharyColor,
                  width: 0.5,
                ),
              ),
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Send a message...',
                  hintStyle: MyFonts.bodyFont(
                    fontColor: MyColors.tercharyColor,
                    fontWeight: FontWeight.w400,
                  ),
                  suffixIcon: IconButton(
                    onPressed: enteredMessage.trim().isEmpty ||
                            messageController.text.trim().isEmpty
                        ? null
                        : _sendMessage,
                    icon: Icon(
                      IconlyLight.send,
                      color: enteredMessage.trim().isEmpty
                          ? MyColors.tercharyColor.withOpacity(0.5)
                          : MyColors.buttonColor1,
                    ),
                  ),
                ),
                onChanged: (typedMessage) {
                  setState(() {
                    enteredMessage = typedMessage;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
