import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

uploadImage({
  required File postImage,
  required String postId,
  required String ref,
}) async {
  String? imageUrl = '';
  final firebaseStorageRef =
      FirebaseStorage.instance.ref().child(ref).child('$postId.jpg');
  await firebaseStorageRef.putFile(postImage).whenComplete(() async {
    imageUrl = await firebaseStorageRef.getDownloadURL();
  });
  return imageUrl!;
}
