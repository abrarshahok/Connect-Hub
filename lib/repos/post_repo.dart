import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PostRepo {
  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static Future<bool> uploadPost({
    required String postId,
    required String userId,
    required String username,
    required String caption,
    required File postImage,
    required DateTime postedOn,
    required List<String> likes,
    required List<String> comments,
  }) async {
    try {
      String? postImageUrl = '';
      final firebaseStorageRef =
          firebaseStorage.ref().child('user_posts').child(postId);
      await firebaseStorageRef.putFile(postImage).whenComplete(() async {
        postImageUrl = await firebaseStorageRef.getDownloadURL();
      });
      final newPost = {
        'userId': userId,
        'username': username,
        'caption': caption,
        'postImageUrl': postImageUrl,
        'postedOn':postedOn.toIso8601String(),
        'likes': likes,
        'comments': comments,
      };
      firebaseFirestore.collection('posts').doc(postId).set(newPost);

      return true;
    } catch (_) {
      return false;
    }
  }
}
