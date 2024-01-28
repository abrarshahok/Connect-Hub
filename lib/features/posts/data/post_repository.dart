import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../../auth/data/auth_repository.dart';
import '/features/posts/domain/post_data_model.dart';

class PostRepository {
  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static Future<bool> uploadPost({
    required PostDataModel postInfo,
    required File postImage,
  }) async {
    try {
      firebaseFirestore
          .collection('posts')
          .doc(postInfo.postId)
          .set(postInfo.toJson());
      return true;
    } catch (_) {
      return false;
    }
  }

  //  uploadImage({
  //   required File postImage,
  //   required String postId,
  //   required String ref,
  // }) async {
  //   String? imageUrl = '';
  //   final firebaseStorageRef = firebaseStorage.ref().child(ref).child(postId);
  //   await firebaseStorageRef.putFile(postImage).whenComplete(() async {
  //     imageUrl = await firebaseStorageRef.getDownloadURL();
  //   });
  //   return imageUrl!;
  // }

  static Future<bool> updatePost({required PostDataModel postDataModel}) async {
    try {
      firebaseFirestore
          .collection('posts')
          .doc(postDataModel.postId)
          .set(postDataModel.toJson());
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> deletePost({required String postId}) async {
    try {
      firebaseFirestore.collection('posts').doc(postId).delete();
      firebaseStorage.ref().child('user_posts').child(postId).delete();
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

      if (likes.contains(AuthRepository.currentUser!.uid)) {
        postRef.update({
          'likes': FieldValue.arrayRemove([AuthRepository.currentUser!.uid])
        });
      } else {
        postRef.update({
          'likes': FieldValue.arrayUnion([AuthRepository.currentUser!.uid])
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
          .doc(AuthRepository.currentUser!.uid);
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
        'userId': AuthRepository.currentUser!.uid,
        'username': AuthRepository.currentUser!.username,
        'userImageUrl': AuthRepository.currentUser!.userImage,
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
