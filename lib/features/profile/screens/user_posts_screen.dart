import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub/components/loading.dart';
import 'package:connecthub/constants/constants.dart';
import 'package:connecthub/features/posts/widgets/post_card.dart';
import 'package:connecthub/models/post_data_model.dart';
import 'package:connecthub/repos/auth_repo.dart';
import 'package:flutter/material.dart';

class UserPostsScreen extends StatefulWidget {
  const UserPostsScreen({super.key, required this.userId});
  final String userId;

  @override
  State<UserPostsScreen> createState() => _UserPostsScreenState();
}

class _UserPostsScreenState extends State<UserPostsScreen> {
  bool isLoading = false;
  List<String> savedPosts = [];
  @override
  void initState() {
    getSavedPosts();
    super.initState();
  }

  void getSavedPosts() async {
    setState(() {
      isLoading = true;
    });
    final docData = await FirebaseFirestore.instance
        .collection('savedPosts')
        .doc(AuthRepo.currentUser!.uid)
        .get();
    savedPosts = docData.exists ? docData.data()!.keys.toList() : List.empty();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final postStream = FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: widget.userId)
        .orderBy('postedOn', descending: true)
        .snapshots();
    return isLoading
        ? const Loading()
        : StreamBuilder(
            stream: postStream,
            builder: (context, userPostSnapshots) {
              if (userPostSnapshots.connectionState ==
                  ConnectionState.waiting) {
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
                      style: MyFonts.bodyFont(
                        fontColor: MyColors.secondaryColor,
                      ),
                    ))
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: postDocuments.length,
                      itemBuilder: (context, index) {
                        bool isSaved =
                            savedPosts.contains(postDocuments[index].id);
                        final postInfo = PostDataModel.fromJson(
                          postDocuments[index].data(),
                          postDocuments[index].id,
                        );
                        return PostCard(
                          postDataModel: postInfo,
                          isSaved: isSaved,
                          onTapProfile: () {},
                        );
                      },
                    );
            },
          );
  }
}
