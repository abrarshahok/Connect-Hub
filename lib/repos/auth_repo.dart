import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone_flutter/constants/constants.dart';

class AuthRepo {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  static User? user;

  static Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    final UserCredential userCredential =
        await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (userCredential.user != null) {
      user = userCredential.user;
      return true;
    }
    return false;
  }

  static Future<bool> signUp({
    required String username,
    required String email,
    required String password,
    required File? image,
  }) async {
    final UserCredential userCredential =
        await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null) {
      user = userCredential.user;
      firebaseFirestore.collection('users').doc(user!.uid).set({
        'username': username,
        'email': email,
        'userImageUrl': image ?? MyIcons.defaultProfilePicUrl,
      });
      return true;
    }
    return false;
  }
}
