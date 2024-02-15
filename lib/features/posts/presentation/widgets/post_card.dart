import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconly/iconly.dart';
import '../../../auth/domain/user_data_model.dart';
import '/features/posts/presentation/widgets/like_animation.dart';
import '/components/confirmation_dialogue.dart';
import '/components/network_image_widget.dart';
import '/features/posts/presentation/screens/upload_post_screen.dart';
import '/features/posts/presentation/screens/comments_screen.dart';
import '../../../auth/data/auth_repository.dart';
import '../screens/likes_screen.dart';
import '/components/show_snackbar.dart';
import '../bloc/posts_bloc.dart';
import '/constants/constants.dart';
import '/components/custom_icon_button.dart';
import '../../domain/post_data_model.dart';

// ignore: must_be_immutable
class PostCard extends StatelessWidget {
  final PostDataModel postInfo;
  final VoidCallback onTapProfile;
  final UserDataModel userInfo;
  final bool isSaved;

  PostCard({
    super.key,
    required this.postInfo,
    required this.isSaved,
    required this.onTapProfile,
    required this.userInfo,
  });
  final _postsBloc = PostsBloc();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostsBloc, PostsState>(
      bloc: _postsBloc,
      listenWhen: (previous, current) => current is PostsActionState,
      buildWhen: (previous, current) => current is! PostsActionState,
      listener: (context, state) {
        _handleStates(state, context);
      },
      builder: (context, state) {
        return GestureDetector(
          onDoubleTap: () {
            _postsBloc.add(
              PostLikeButtonClickedEvent(
                postId: postInfo.postId,
                likes: postInfo.likes,
              ),
            );
          },
          child: Stack(
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
                          child: _buildUserInfoTile(),
                        ),
                        const Spacer(),
                        if (postInfo.userId == AuthRepository.currentUser!.uid)
                          IconButton(
                            onPressed: () {
                              if (state is! PostShowAllPostOptionsState) {
                                _postsBloc.add(
                                    PostShowAllPostOptionsButtonClickedEvent());
                              } else {
                                _postsBloc.add(
                                    PostHideAllPostOptionsButtonClickedEvent());
                              }
                            },
                            icon: Icon(
                              Icons.more_vert,
                              color: MyColors.tercharyColor,
                            ),
                          )
                      ],
                    ),
                    const SizedBox(height: 10),
                    NetworkImageWidget(
                      height: 300,
                      width: double.infinity,
                      imageUrl: postInfo.postUrl,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      postInfo.caption,
                      style: MyFonts.bodyFont(),
                    ),
                    _buildPostButtonsTile(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _postsBloc.add(
                                  PostNavigateToLikeScreenButtonClickedEvent());
                            },
                            child: Text(
                              postInfo.likes.isEmpty
                                  ? 'No Likes'
                                  : '${postInfo.likes.length} ${postInfo.likes.length == 1 ? 'Like' : 'Likes'}',
                              style: MyFonts.bodyFont(
                                fontColor: MyColors.secondaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${postInfo.username.toLowerCase()} ',
                                ),
                                TextSpan(
                                  text: postInfo.caption,
                                  style: MyFonts.bodyFont(
                                    fontWeight: FontWeight.w300,
                                  ),
                                )
                              ],
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
                  bloc: _postsBloc,
                  builder: (context, state) {
                    return DropDownOptionsWidget(
                      enable: state is PostShowAllPostOptionsState,
                      onEditClicked: () {
                        _postsBloc.add(PostEditPostButtonClickedEvent());
                      },
                      onDeleteClicked: () {
                        _postsBloc.add(PostDeletePostButtonClickedEvent());
                      },
                      onShareCliked: () {},
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Row _buildPostButtonsTile() {
    return Row(
      children: [
        LikeAnimation(
          isAnimating: postInfo.likes.contains(AuthRepository.currentUser!.uid),
          smallLike: true,
          child: CustomIconButton(
            icon: postInfo.likes.contains(AuthRepository.currentUser!.uid)
                ? IconlyBold.heart
                : IconlyLight.heart,
            color: postInfo.likes.contains(AuthRepository.currentUser!.uid)
                ? Colors.red
                : MyColors.tercharyColor,
            onPressed: () {
              _postsBloc.add(
                PostLikeButtonClickedEvent(
                  postId: postInfo.postId,
                  likes: postInfo.likes,
                ),
              );
            },
          ),
        ),
        CustomIconButton(
          icon: IconlyLight.document,
          color: MyColors.tercharyColor,
          onPressed: () {
            _postsBloc.add(
              PostNavigateToCommentScreenButtonClickedEvent(
                postInfo.postId,
              ),
            );
          },
        ),
        CustomIconButton(
          icon: IconlyLight.send,
          color: MyColors.tercharyColor,
          onPressed: () {},
        ),
        const Spacer(),
        SavePostButtonWidget(
          isSaved: isSaved,
          postId: postInfo.postId,
        ),
      ],
    );
  }

  Row _buildUserInfoTile() {
    String formatedDateTime = _getTimeAgo(postInfo.postedOn);
    return Row(
      children: [
        const SizedBox(width: 10),
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white,
          backgroundImage: CachedNetworkImageProvider(
            userInfo.userImage,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userInfo.username,
              style: MyFonts.bodyFont(
                fontColor: MyColors.secondaryColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              formatedDateTime,
              style: MyFonts.bodyFont(
                fontColor: MyColors.secondaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleStates(PostsState state, BuildContext context) {
    if (state is PostLikingFailedActionState ||
        state is PostSavingFailedActionState) {
      ShowSnackBar(
        context: context,
        label: 'Something went wrong!',
        color: Colors.red,
      ).show();
    } else if (state is PostNavigateToLikesScreenActionState) {
      Navigator.pushNamed(context, LikesScreen.routeName,
          arguments: postInfo.likes);
    } else if (state is PostNavigateToCommentsScreenActionState) {
      Navigator.pushNamed(context, CommentsScreen.routeName,
          arguments: postInfo.postId);
    } else if (state is PostEditPostActionState) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(
        context,
        UploadPostScreen.routeName,
        arguments: {
          'postBloc': _postsBloc,
          'postDataModel': postInfo,
          'isEditing': true,
        },
      );
    } else if (state is PostDeleteActionState) {
      ConfirmationDialogue(
        context: context,
        message: 'Do you want to delete post',
        onTapYes: () {
          _postsBloc.add(PostDeleteConfirmationEvent(
            postId: postInfo.postId,
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
  }

  String _getTimeAgo(DateTime postDateTime) {
    final now = DateTime.now();
    final difference = now.difference(postDateTime);
    if (difference.inDays > 365) {
      return DateFormat('MMMM d, y').format(postDateTime);
    } else if (difference.inDays > 7) {
      return DateFormat('MMMM d').format(postDateTime);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day(s) ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour(s) ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute(s) ago';
    } else {
      return 'Just now';
    }
  }
}

class SavePostButtonWidget extends StatelessWidget {
  SavePostButtonWidget({
    super.key,
    required this.isSaved,
    required this.postId,
  });

  final bool isSaved;
  final String postId;
  final postsBloc = PostsBloc();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsBloc, PostsState>(
      bloc: postsBloc,
      buildWhen: (previous, current) => current is PostsActionState,
      builder: (context, state) {
        bool newSavedValue = switch (state) {
          PostSavedActionState _ => true,
          PostUnSavedActionState _ => false,
          _ => isSaved,
        };
        if (state is PostSavedActionState) {
          newSavedValue = true;
        } else if (state is PostUnSavedActionState) {
          newSavedValue = false;
        } else {
          newSavedValue = isSaved;
        }
        return CustomIconButton(
          icon: newSavedValue ? IconlyBold.bookmark : IconlyLight.bookmark,
          color: MyColors.buttonColor1,
          onPressed: () {
            postsBloc.add(
              PostSaveButtonClickedEvent(postId),
            );
          },
        );
      },
    );
  }
}

class DropDownOptionsWidget extends StatelessWidget {
  const DropDownOptionsWidget({
    super.key,
    required this.onEditClicked,
    required this.onDeleteClicked,
    required this.enable,
    this.onShareCliked,
  });
  final Function()? onEditClicked;
  final Function()? onDeleteClicked;
  final Function()? onShareCliked;
  final bool enable;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: enable ? 120 : 0,
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 400),
      width: 100,
      color: MyColors.tercharyColor,
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              onTap: onEditClicked,
              child: Text(
                'Edit',
                style: MyFonts.bodyFont(
                  fontColor: MyColors.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: onDeleteClicked,
              child: Text(
                'Delete',
                style: MyFonts.bodyFont(
                  fontColor: MyColors.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          if (onShareCliked != null)
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
  }
}
