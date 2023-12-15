import 'package:connecthub/components/custom_app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../repos/auth_repo.dart';
import '/features/posts/widgets/post_card.dart';
import '/constants/constants.dart';
import '/models/post_data_model.dart';

class SavedPostsScreen extends StatelessWidget {
  static const routeName = '/saved-posts';
  const SavedPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final savedPostStream = FirebaseFirestore.instance
        .collection('savedPosts')
        .doc(AuthRepo.currentUser!.uid)
        .snapshots();
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: Stack(
        children: [
          StreamBuilder(
            stream: savedPostStream,
            builder: (context, savedPostSnapshots) {
              if (savedPostSnapshots.connectionState ==
                  ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: MyColors.buttonColor1,
                  ),
                );
              }

              if (!savedPostSnapshots.data!.exists) {
                return Center(
                  child: Text(
                    'No Saved Posts!',
                    style: MyFonts.bodyFont(
                      fontColor: MyColors.secondaryColor,
                    ),
                  ),
                );
              } else {
                final postDocuments =
                    savedPostSnapshots.data!.data()!.values.toList();
                final postIdList =
                    savedPostSnapshots.data!.data()!.keys.toList();
                return ListView.builder(
                  itemCount: postDocuments.length,
                  padding: const EdgeInsets.symmetric(vertical: 80),
                  itemBuilder: (context, index) {
                    bool isSaved = true;
                    final postInfo = PostDataModel.fromJson(
                      postDocuments[index],
                      postIdList[index],
                    );
                    return PostCard(
                      postDataModel: postInfo,
                      isSaved: isSaved,
                      likedFromSavedScreen: true,
                    );
                  },
                );
              }
            },
          ),
          const Positioned(
            top: 20,
            left: 7,
            right: 7,
            child: CustomAppTopBar(
              title: 'Saved Posts',
              centerTitle: true,
            ),
          ),
        ],
      ),
    );
  }
}
