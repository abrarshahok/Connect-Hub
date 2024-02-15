import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub/components/custom_app_top_bar.dart';
import 'package:connecthub/constants/constants.dart';
import 'package:connecthub/features/chat/domain/message.dart';
import 'package:flutter/material.dart';

import '../widgets/message_bubble.dart';
import '../widgets/new_message.dart';

class MessagesScreen extends StatelessWidget {
  static const routeName = '/Message-Screen';

  const MessagesScreen({super.key});

  String getChatRoomId(String currentUserId, String friendUserId) {
    if (currentUserId.compareTo(friendUserId) > 0) {
      return '$currentUserId-$friendUserId';
    }
    return '$friendUserId-$currentUserId';
  }

  @override
  Widget build(BuildContext context) {
    final modalData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final String currentUserId = modalData['currentUserId'];
    final String friendUserId = modalData['friendUserId'];
    final String userName = modalData['userName'];
    final chatRoomId = getChatRoomId(currentUserId, friendUserId);
    final collectionReference = FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection('messages');

    return Scaffold(
      appBar: customAppBar(title: userName, showLeadingButton: true),
      backgroundColor: MyColors.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          StreamBuilder(
            stream: collectionReference.snapshots(),
            builder: (ctx, streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              var chatDocs = streamSnapshot.data!.docs;
              chatDocs.sort(((a, b) => b['time'].compareTo(a['time'])));
              return Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: chatDocs.length,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  itemBuilder: (ctx, index) {
                    final message =
                        Message.fromJson(json: chatDocs[index].data());
                    return MessageBubble(
                      text: message.text,
                      userImage: message.imageUrl,
                      userName:
                          message.senderId == currentUserId ? 'You' : userName,
                      isMe: message.senderId == currentUserId,
                    );
                  },
                ),
              );
            },
          ),
          NewMessage(
            currentUserId: currentUserId,
            friendUserId: friendUserId,
          ),
        ],
      ),
    );
  }
}
