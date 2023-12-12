import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone_flutter/repos/auth_repo.dart';

class PostRepo {
  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static Future<bool> uploadPost({
    required String postId,
    required String userId,
    required String username,
    required String userImage,
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
        'userImage': userImage,
        'caption': caption,
        'postImageUrl': postImageUrl,
        'postedOn': postedOn.toIso8601String(),
        'likes': likes,
        'comments': comments,
      };
      firebaseFirestore.collection('posts').doc(postId).set(newPost);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> likeOrDislikePost({
    required List<String> likes,
    required String postId,
  }) async {
    try {
      final postRef = firebaseFirestore.collection('posts').doc(postId);
      if (likes.contains(AuthRepo.user!.uid)) {
        postRef.update({
          'likes': FieldValue.arrayRemove([AuthRepo.user!.uid])
        });
      } else {
        postRef.update({
          'likes': FieldValue.arrayUnion([AuthRepo.user!.uid])
        });
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> saveOrUnsavePost(String postId) async {
    try {
      final savedPostRef =
          firebaseFirestore.collection('savedPosts').doc(AuthRepo.user!.uid);

      final savedPostData = await savedPostRef.get();
      if (savedPostData.exists) {
        final isPostSaved = savedPostData.data()!.containsKey(postId);
        if (isPostSaved) {
          await savedPostRef.update({postId: FieldValue.delete()});
        } else {
          await savedPostRef.update({postId: true});
        }
      } else {
        await savedPostRef.set({postId: true});
      }
      return true;
    } catch (_) {
      return false;
    }
  }
}
