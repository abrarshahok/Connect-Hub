import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub/repos/auth_repo.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileRepo {
  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

static  Future<bool> followOrUnfollow({
    required List<dynamic> followers,
    required String userId,
  }) async {
    try {
      final currentUserRef =
          firebaseFirestore.collection('users').doc(AuthRepo.currentUser!.uid);
      final otherUserRef = firebaseFirestore.collection('users').doc(userId);

      if (followers.contains(AuthRepo.currentUser!.uid)) {
        otherUserRef.update({
          'followers': FieldValue.arrayRemove([AuthRepo.currentUser!.uid])
        });
        currentUserRef.update({
          'following': FieldValue.arrayRemove([userId])
        });
        print('Unfollowed');
      } else {
        otherUserRef.update({
          'followers': FieldValue.arrayUnion([AuthRepo.currentUser!.uid])
        });
        currentUserRef.update({
          'following': FieldValue.arrayUnion([userId])
        });
        print('Followed');
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
