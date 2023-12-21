import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/features/auth/bloc/auth_bloc.dart';
import '/features/profile/screens/current_user_profile.dart';
import '/features/profile/screens/other_users_profile.dart';
import '/components/custom_app_top_bar.dart';
import '/components/loading.dart';
import '../../../repos/auth_repo.dart';
import '/features/posts/widgets/post_card.dart';
import '/constants/constants.dart';
import '/models/post_data_model.dart';
import '../../../components/custom_icon_button.dart';

class PostsFeed extends StatefulWidget {
  const PostsFeed({super.key, required this.authBloc});
  final AuthBloc authBloc;

  @override
  State<PostsFeed> createState() => _PostsFeedState();
}

class _PostsFeedState extends State<PostsFeed> {
  List<String> savedPosts = [];
  bool isLoading = false;
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
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final postStream = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('postedOn', descending: true)
        .snapshots();

    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      appBar: customAppBar(
        title: 'Connect Hub',
        showActionButton: true,
        actionButton: CustomIconButton(
          icon: IconlyLight.chat,
          color: MyColors.secondaryColor,
          onPressed: () {},
        ),
      ),
      body: isLoading
          ? Loading()
          : StreamBuilder(
              stream: postStream,
              builder: (context, postSnapshots) {
                if (postSnapshots.connectionState == ConnectionState.waiting) {
                  return const Loading();
                }
                final postDocuments = postSnapshots.data!.docs;
                if (postDocuments.isEmpty) {
                  return Center(
                    child: Text(
                      'No Posts!',
                      style: MyFonts.bodyFont(
                        fontColor: MyColors.secondaryColor,
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: postDocuments.length,
                    padding: const EdgeInsets.only(top: 10, bottom: 80),
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
                        onTapProfile: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AuthRepo.currentUser!.uid == postInfo.userId
                                      ? CurrentUserProfile(
                                          authBloc: widget.authBloc,
                                          showBackButton: true,
                                        )
                                      : OtherUsersProfile(
                                          userId: postInfo.userId,
                                          authBloc: widget.authBloc,
                                          showBackButton: true,
                                        ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
    );
  }
}
