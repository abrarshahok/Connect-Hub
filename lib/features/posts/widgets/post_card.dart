import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconly/iconly.dart';
import '/repos/auth_repo.dart';
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
  final bool likedFromSavedScreen;
  PostCard({
    super.key,
    required this.postDataModel,
    required this.isSaved,
    this.likedFromSavedScreen = false,
  });
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
                    style: MyFonts.bodyFont(
                      fontColor: MyColors.secondaryColor,
                      fontWeight: FontWeight.w500,
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
                            ? IconlyBold.heart
                            : IconlyLight.heart,
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
                    icon: IconlyLight.document,
                    color: MyColors.secondaryColor,
                    onPressed: () {},
                  ),
                  CustomIconButton(
                    icon: IconlyLight.send,
                    color: MyColors.secondaryColor,
                    onPressed: () {},
                  ),
                  const Spacer(),
                  CustomIconButton(
                    icon: isSaved ? IconlyBold.bookmark : IconlyLight.bookmark,
                    color: isSaved ? Colors.blueGrey : MyColors.secondaryColor,
                    onPressed: () {
                      postsBloc.add(
                        PostSaveButtonClickedEvent(postDataModel),
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
                            text: '${postDataModel.username.toLowerCase()} ',
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
