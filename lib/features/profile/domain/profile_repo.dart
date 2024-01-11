import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub/features/auth/repository/auth_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileRepo {
  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  static Future<bool> followOrUnfollow({
    required List<dynamic> followers,
    required String userId,
  }) async {
    try {
      final currentUserRef = firebaseFirestore
          .collection('users')
          .doc(AuthRepository.currentUser!.uid);
      final otherUserRef = firebaseFirestore.collection('users').doc(userId);

      if (followers.contains(AuthRepository.currentUser!.uid)) {
        otherUserRef.update({
          'followers': FieldValue.arrayRemove([AuthRepository.currentUser!.uid])
        });
        currentUserRef.update({
          'following': FieldValue.arrayRemove([userId])
        });
      } else {
        otherUserRef.update({
          'followers': FieldValue.arrayUnion([AuthRepository.currentUser!.uid])
        });
        currentUserRef.update({
          'following': FieldValue.arrayUnion([userId])
        });
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
