import 'package:connecthub/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../auth/repository/auth_repository.dart';
import '../../../posts/presentation/widgets/post_card.dart';
import '/constants/constants.dart';
import '../../../posts/domain/post_data_model.dart';

class UserSavedPostsScreen extends StatelessWidget {
  const UserSavedPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('savedPosts')
          .doc(AuthRepository.currentUser!.uid)
          .snapshots(),
      builder: (context, savedPostSnapshots) {
        if (savedPostSnapshots.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: MyColors.buttonColor1,
            ),
          );
        }
        if (!savedPostSnapshots.data!.exists ||
            savedPostSnapshots.data!.data()!.keys.toList().isEmpty) {
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
                      onTapProfile: () {},
                    );
                  });
            },
          );
        }
      },
    );
  }
}
