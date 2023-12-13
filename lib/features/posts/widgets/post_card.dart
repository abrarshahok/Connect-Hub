import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instagram_clone_flutter/features/posts/screens/likes_screen.dart';
import '/repos/auth_repo.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import '/components/show_snackbar.dart';
import '../bloc/posts_bloc.dart';
import '/constants/constants.dart';
import '/components/custom_icon_button.dart';
import '/models/post_data_model.dart';

class PostCard extends StatelessWidget {
  final PostDataModel postDataModel;
  PostCard({super.key, required this.postDataModel});
  final PostsBloc postsBloc = PostsBloc();
  @override
  Widget build(BuildContext context) {
    String formatedDateTime =
        DateFormat().add_MMMMd().format(postDataModel.postedOn);
    return BlocConsumer<PostsBloc, PostsState>(
      bloc: postsBloc,
      listenWhen: (previous, current) => current is PostsActionState,
      buildWhen: (previous, current) => current is! PostsActionState,
      listener: (context, state) {
        if (state is PostLikingFailedActionState ||
            state is PostSavingFailedActionState) {
          ShowSnackBar(
            context: context,
            label: 'Something went wrong!',
            color: Colors.red,
          );
        } else if (state is PostNavigateToLikesScreenActionState) {
          Navigator.pushNamed(context, LikesScreen.routeName,
              arguments: postDataModel.likes);
        }
      },
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    backgroundImage: CachedNetworkImageProvider(
                      postDataModel.userImage,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    postDataModel.username,
                    style: MyFonts.firaSans(
                      fontColor: MyColors.secondaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              showNetworkImage(
                height: 300,
                width: double.infinity,
                imageUrl: postDataModel.postUrl,
              ),
              Row(
                children: [
                  CustomIconButton(
                    icon:
                        postDataModel.likes.contains(AuthRepo.currentUser!.uid)
                            ? Icons.favorite
                            : Icons.favorite_border,
                    color:
                        postDataModel.likes.contains(AuthRepo.currentUser!.uid)
                            ? Colors.red
                            : MyColors.secondaryColor,
                    onPressed: () {
                      postsBloc.add(
                        PostLikeButtonClickedEvent(
                          postId: postDataModel.postId,
                          likes: postDataModel.likes,
                        ),
                      );
                    },
                  ),
                  CustomIconButton(
                    icon: LineIcons.comment,
                    color: MyColors.secondaryColor,
                    onPressed: () {},
                  ),
                  Transform.rotate(
                    angle: -0.7,
                    child: CustomIconButton(
                      icon: Icons.send,
                      color: MyColors.secondaryColor,
                      onPressed: () {},
                    ),
                  ),
                  const Spacer(),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('savedPosts')
                        .doc(AuthRepo.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(
                          color: MyColors.buttonColor1,
                        );
                      }
                      bool isSaved = false;
                      final savedPostDocs = snapshot.data;
                      if (savedPostDocs!.exists) {
                        isSaved = savedPostDocs
                            .data()!
                            .containsKey(postDataModel.postId);
                      }

                      return CustomIconButton(
                        icon: isSaved ? Icons.bookmark : Icons.bookmark_outline,
                        color: MyColors.secondaryColor,
                        onPressed: () {
                          postsBloc.add(
                              PostSaveButtonClickedEvent(postDataModel.postId));
                        },
                      );
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        postsBloc.add(PostNavigateToLikeScreenButtonClicked());
                      },
                      child: Text(
                        postDataModel.likes.isEmpty
                            ? 'No Likes'
                            : '${postDataModel.likes.length} Likes',
                        style: MyFonts.firaSans(
                          fontColor: MyColors.secondaryColor,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${postDataModel.username.toLowerCase()} ',
                          ),
                          TextSpan(
                            text: postDataModel.caption,
                            style: MyFonts.firaSans(
                              fontWeight: FontWeight.w300,
                            ),
                          )
                        ],
                      ),
                    ),
                    Text(
                      formatedDateTime,
                      style: MyFonts.firaSans(
                        fontColor: MyColors.secondaryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

  Widget showNetworkImage({
    required double height,
    required double width,
    required String imageUrl,
  }) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        padding: const EdgeInsets.all(5),
        height: 50,
        width: 50,
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          color: MyColors.buttonColor1,
        ),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
