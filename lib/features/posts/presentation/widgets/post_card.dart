import 'package:connecthub/components/confirmation_dialogue.dart';
import 'package:connecthub/components/network_image_widget.dart';
import 'package:connecthub/features/posts/screens/upload_post_screen.dart';
import 'package:connecthub/features/posts/screens/comments_screen.dart';
import 'package:connecthub/service_locator/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconly/iconly.dart';
import '../../auth/repository/auth_repository.dart';
import '/features/posts/screens/likes_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '/components/show_snackbar.dart';
import '../bloc/posts_bloc.dart';
import '/constants/constants.dart';
import '/components/custom_icon_button.dart';
import '/models/post_data_model.dart';

class PostCard extends StatelessWidget {
  final PostDataModel postDataModel;
  final bool isSaved;
  final VoidCallback onTapProfile;

  PostCard({
    super.key,
    required this.postDataModel,
    required this.isSaved,
    required this.onTapProfile,
  });
  final PostsBloc postsBloc = ServiceLocator.instance.get<PostsBloc>();

  @override
  Widget build(BuildContext context) {
    String formatedDateTime =
        DateFormat().add_MMMMd().format(postDataModel.postedOn);
    return BlocConsumer<PostsBloc, PostsState>(
      bloc: postsBloc,
      listenWhen: (previous, current) => current is PostsActionState,
      buildWhen: (previous, current) => current is! PostsActionState,
      listener: (context, state) async {
        if (state is PostLikingFailedActionState ||
            state is PostSavingFailedActionState) {
          ShowSnackBar(
            context: context,
            label: 'Something went wrong!',
            color: Colors.red,
          ).show();
        } else if (state is PostNavigateToLikesScreenActionState) {
          Navigator.pushNamed(context, LikesScreen.routeName,
              arguments: postDataModel.likes);
        } else if (state is PostNavigateToCommentsScreenActionState) {
          Navigator.pushNamed(context, CommentsScreen.routeName,
              arguments: postDataModel.postId);
        } else if (state is PostEditPostActionState) {
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, UploadPostScreen.routeName, arguments: {
            'postBloc': postsBloc,
            'postDataModel': postDataModel,
            'isEditing': true,
          });
        } else if (state is PostDeleteActionState) {
          ConfirmationDialogue(
            context: context,
            message: 'Do you want to delete post',
            onTapYes: () {
              postsBloc.add(PostDeleteConfirmationEvent(
                postId: postDataModel.postId,
              ));
              Navigator.pop(context);
            },
          ).show();
        } else if (state is PostDeleteSuccessActionState) {
          ShowSnackBar(
            context: context,
            label: 'Post deleted successfully',
            color: MyColors.buttonColor1,
          ).show();
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onTapProfile,
                        child: Row(
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
                              style: MyFonts.bodyFont(
                                fontColor: MyColors.secondaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      if (postDataModel.userId ==
                          AuthRepository.currentUser!.uid)
                        IconButton(
                          onPressed: () {
                            if (state is! PostShowAllPostOptionsState) {
                              postsBloc.add(
                                  PostShowAllPostOptionsButtonClickedEvent());
                            } else {
                              postsBloc.add(
                                  PostHideAllPostOptionsButtonClickedEvent());
                            }
                          },
                          icon: Icon(
                            Icons.more_vert,
                            color: MyColors.secondaryColor,
                          ),
                        )
                    ],
                  ),
                  const SizedBox(height: 10),
                  NetworkImageWidget(
                    height: 300,
                    width: double.infinity,
                    imageUrl: postDataModel.postUrl,
                  ),
                  Row(
                    children: [
                      CustomIconButton(
                        icon: postDataModel.likes
                                .contains(AuthRepository.currentUser!.uid)
                            ? IconlyBold.heart
                            : IconlyLight.heart,
                        color: postDataModel.likes
                                .contains(AuthRepository.currentUser!.uid)
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
                        icon: IconlyLight.document,
                        color: MyColors.secondaryColor,
                        onPressed: () {
                          postsBloc.add(
                            PostNavigateToCommentScreenButtonClickedEvent(
                                postDataModel.postId),
                          );
                        },
                      ),
                      CustomIconButton(
                        icon: IconlyLight.send,
                        color: MyColors.secondaryColor,
                        onPressed: () {},
                      ),
                      const Spacer(),
                      BlocBuilder<PostsBloc, PostsState>(
                        bloc: postsBloc,
                        buildWhen: (previous, current) =>
                            current is PostsActionState,
                        builder: (context, state) {
                          bool newSavedValue = false;
                          if (state is PostSavedActionState) {
                            newSavedValue = true;
                          } else if (state is PostUnSavedActionState) {
                            newSavedValue = false;
                          } else {
                            newSavedValue = isSaved;
                          }
                          return CustomIconButton(
                            icon: newSavedValue
                                ? IconlyBold.bookmark
                                : IconlyLight.bookmark,
                            color: newSavedValue
                                ? Colors.blueGrey
                                : MyColors.secondaryColor,
                            onPressed: () {
                              postsBloc.add(
                                PostSaveButtonClickedEvent(
                                    postDataModel.postId),
                              );
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
                            postsBloc.add(
                                PostNavigateToLikeScreenButtonClickedEvent());
                          },
                          child: Text(
                            postDataModel.likes.isEmpty
                                ? 'No Likes'
                                : '${postDataModel.likes.length} ${postDataModel.likes.length == 1 ? 'Like' : 'Likes'}',
                            style: MyFonts.bodyFont(
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
                                text:
                                    '${postDataModel.username.toLowerCase()} ',
                              ),
                              TextSpan(
                                text: postDataModel.caption,
                                style: MyFonts.bodyFont(
                                  fontWeight: FontWeight.w300,
                                ),
                              )
                            ],
                          ),
                        ),
                        Text(
                          formatedDateTime,
                          style: MyFonts.bodyFont(
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
            ),
            Positioned(
              right: 0,
              top: 40,
              child: BlocBuilder<PostsBloc, PostsState>(
                bloc: postsBloc,
                builder: (context, state) {
                  return AnimatedContainer(
                    height: state is PostShowAllPostOptionsState ? 120 : 0,
                    curve: Curves.easeIn,
                    duration: const Duration(milliseconds: 400),
                    width: 100,
                    color: MyColors.primaryColor,
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              postsBloc.add(PostEditPostButtonClickedEvent());
                            },
                            child: Text(
                              'Edit',
                              style: MyFonts.bodyFont(
                                fontColor: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              postsBloc.add(PostDeletePostButtonClickedEvent());
                            },
                            child: Text(
                              'Delete',
                              style: MyFonts.bodyFont(
                                fontColor: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Text(
                              'Share',
                              style: MyFonts.bodyFont(
                                fontColor: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
