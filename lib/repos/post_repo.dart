import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '/repos/auth_repo.dart';

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
      };
      firebaseFirestore.collection('posts').doc(postId).set(newPost);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> likeOrDislikePost({
    required List<dynamic> likes,
    required String postId,
  }) async {
    try {
      final postRef = firebaseFirestore.collection('posts').doc(postId);

      if (likes.contains(AuthRepo.currentUser!.uid)) {
        postRef.update({
          'likes': FieldValue.arrayRemove([AuthRepo.currentUser!.uid])
        });
      } else {
        postRef.update({
          'likes': FieldValue.arrayUnion([AuthRepo.currentUser!.uid])
        });
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<dynamic> saveOrUnsavePost(String postId) async {
    try {
      final savedPostRef = firebaseFirestore
          .collection('savedPosts')
          .doc(AuthRepo.currentUser!.uid);
      final savedPostData = await savedPostRef.get();
      if (savedPostData.exists) {
        final isPostSaved = savedPostData.data()!.containsKey(postId);
        if (isPostSaved) {
          savedPostRef.update({postId: FieldValue.delete()});
          return 'unsaved';
        } else {
          savedPostRef.update({postId: true});
          return 'saved';
        }
      } else {
        savedPostRef.set({postId: true});
        return 'saved';
      }
    } catch (_) {
      return false;
    }
  }

  static Future<bool> addComment({
    required String postId,
    required String comment,
  }) async {
    try {
      final commentId = const Uuid().v1();
      final postCommentDocReference = firebaseFirestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId);
      final commentJson = {
        'userId': AuthRepo.currentUser!.uid,
        'username': AuthRepo.currentUser!.username,
        'userImageUrl': AuthRepo.currentUser!.userImage,
        'comment': comment,
        'commentId': commentId,
        'commentedOn': DateTime.now().toIso8601String(),
      };
      postCommentDocReference.set(commentJson);
      return true;
    } catch (_) {
      return false;
    }
  }
}
