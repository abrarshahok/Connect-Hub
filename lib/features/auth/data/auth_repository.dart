import 'dart:io';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '/constants/constants.dart';
import '../domain/user_data_model.dart';

class AuthRepository {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static UserDataModel? currentUser;
  static List<UserDataModel> allUsers = [];
  static bool get isYou => currentUser!.uid == firebaseAuth.currentUser!.uid;

  static Future<void> fetchAllUsers() async {
    try {
      final userDocs =
          await FirebaseFirestore.instance.collection('users').get();
      if (userDocs.docs.isEmpty) {
        return;
      }
      for (var user in userDocs.docs) {
        final userModel = UserDataModel.fromJson(user.data());
        if (!allUsers.contains(userModel)) {
          allUsers.add(userModel);
        }
      }
    } catch (err) {
      log(err.toString());
    }
  }

  static bool fetchCurrentUserInfo() {
    try {
      if (firebaseAuth.currentUser == null) {
        return false;
      }

      if (allUsers.isNotEmpty) {
        currentUser = allUsers
            .firstWhere((user) => user.uid == firebaseAuth.currentUser!.uid);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      fetchCurrentUserInfo();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> signUp({
    required String username,
    required String email,
    required String password,
    required File? image,
  }) async {
    try {
      final UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = UserDataModel(
        uid: userCredential.user!.uid,
        username: username,
        email: email,
        userImage: MyImages.defaultProfilePicUrl,
        online: true,
        followers: [],
        following: [],
      );
      currentUser = user;
      await firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(user.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  static void toggleUserStatus(bool status) async {
    await firebaseFirestore
        .collection('users')
        .doc(currentUser!.uid)
        .set(currentUser!.copyWith(online: status).toJson());
  }

  static Future<bool> signOut() async {
    try {
      firebaseAuth.signOut();
      return true;
    } catch (_) {
      return false;
    }
  }
}
