import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub/constants/constants.dart';
import 'package:connecthub/features/posts/widgets/post_card.dart';
import 'package:connecthub/models/post_data_model.dart';
import 'package:connecthub/repos/auth_repo.dart';
import 'package:flutter/material.dart';

class UserPostsScreen extends StatelessWidget {
  const UserPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postStream = FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: AuthRepo.currentUser!.uid)
        .orderBy('postedOn', descending: true)
        .snapshots();
    final savedPostStream = FirebaseFirestore.instance
        .collection('savedPosts')
        .doc(AuthRepo.currentUser!.uid)
        .snapshots();
    return StreamBuilder(
      stream: postStream,
      builder: (context, userPostSnapshots) => StreamBuilder(
        stream: savedPostStream,
        builder: (context, savedPostSnapshots) {
          if (userPostSnapshots.connectionState == ConnectionState.waiting ||
              savedPostSnapshots.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: MyColors.buttonColor1,
              ),
            );
          }
          final postDocuments = userPostSnapshots.data!.docs;

          return postDocuments.isEmpty
              ? Center(
                  child: Text(
                  'No Posts!',
                  style: MyFonts.bodyFont(fontColor: MyColors.secondaryColor),
                ))
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: postDocuments.length,
                  itemBuilder: (context, index) {
                    bool isSaved = false;
                    if (savedPostSnapshots.data!.exists) {
                      isSaved = savedPostSnapshots.data!
                          .data()!
                          .containsKey(postDocuments[index].id);
                    }
                    final postInfo = PostDataModel.fromJson(
                      postDocuments[index].data(),
                      postDocuments[index].id,
                    );
                    return PostCard(
                      postDataModel: postInfo,
                      isSaved: isSaved,
                    );
                  },
                );
        },
      ),
    );
  }
}
