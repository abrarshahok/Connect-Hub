import 'package:connecthub/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../repos/auth_repo.dart';
import '/features/posts/widgets/post_card.dart';
import '/constants/constants.dart';
import '/models/post_data_model.dart';

class UserSavedPostsScreen extends StatelessWidget {
  static const routeName = '/saved-posts';
  const UserSavedPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('savedPosts')
          .doc(AuthRepo.currentUser!.uid)
          .snapshots(),
      builder: (context, savedPostSnapshots) {
        if (savedPostSnapshots.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: MyColors.buttonColor1,
            ),
          );
        }
        if (savedPostSnapshots.data!.data()!.isEmpty) {
          return Center(
            child: Text(
              'No Saved Posts!',
              style: MyFonts.bodyFont(
                fontColor: MyColors.secondaryColor,
              ),
            ),
          );
        } else {
          final postIdList = savedPostSnapshots.data!.data()!.keys.toList();
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .where(FieldPath.documentId, whereIn: postIdList)
                .snapshots(),
            builder: (context, postsSnapshot) {
              if (postsSnapshot.connectionState == ConnectionState.waiting) {
                return const Loading();
              }
              final postDocuments = postsSnapshot.data!.docs;
              return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: postDocuments.length,
                  itemBuilder: (context, index) {
                    final postInfo = PostDataModel.fromJson(
                      postDocuments[index].data(),
                      postDocuments[index].id,
                    );
                    return PostCard(
                      postDataModel: postInfo,
                      isSaved: true,
                    );
                  });
            },
          );
        }
      },
    );
  }
}
