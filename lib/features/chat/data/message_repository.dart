import 'package:cloud_firestore/cloud_firestore.dart';

import '/features/chat/domain/message.dart';

class MessageRepository {
  static void sendMessage({
    required String chatRoomId,
    required Message message,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(chatRoomId)
          .collection('messages')
          .add(message.toJson());
    } catch (e) {
      print(e);
    }
  }
}
