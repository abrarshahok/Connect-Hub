import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String text;
  final String imageUrl;
  final String senderId;
  final Timestamp time;

  Message({
    required this.text,
    required this.imageUrl,
    required this.senderId,
    required this.time,
  });

  factory Message.fromJson({required Map<String, dynamic> json}) {
    return Message(
      text: json['text'],
      imageUrl: json['image_url'],
      senderId: json['senderId'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'image_url': imageUrl,
      'senderId': senderId,
      'time': time,
    };
  }
}
