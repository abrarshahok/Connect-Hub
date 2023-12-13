import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone_flutter/constants/constants.dart';

import '../models/user_data_model.dart';

class AuthRepo {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static UserDataModel? currentUser;

  static bool get isYou => currentUser!.uid == firebaseAuth.currentUser!.uid;

  static Future<bool> fetchCurrentUserInfo() async {
    try {
      if (firebaseAuth.currentUser == null) {
        return false;
      }
      final userInfo = await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .get();
      if (userInfo.exists) {
        currentUser = UserDataModel.fromJson(userInfo.data()!, userInfo.id);
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
      await fetchCurrentUserInfo();
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
      firebaseFirestore.collection('users').doc(userCredential.user!.uid).set({
        'username': username,
        'email': email,
        'userImageUrl': image ?? MyIcons.defaultProfilePicUrl,
      });
      await fetchCurrentUserInfo();
      return true;
    } catch (e) {
      return false;
    }
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
