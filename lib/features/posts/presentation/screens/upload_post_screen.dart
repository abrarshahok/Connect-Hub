import 'package:connecthub/components/custom_elevated_button.dart';
import 'package:connecthub/constants/constants.dart';
import 'package:connecthub/features/posts/presentation/bloc/posts_bloc.dart';
import 'package:connecthub/features/posts/domain/post_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import '../../../../components/network_image_widget.dart';
import '../../../../components/show_snackbar.dart';
import '../../../../service_locator/service_locator.dart';
import 'add_post_screen.dart';

class UploadPostScreen extends StatelessWidget {
  static const routeName = '/upload-post-screen';
  final TextEditingController _captionTextController = TextEditingController();
  final postsBloc = ServiceLocator.instance.get<PostsBloc>();
  UploadPostScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final routeData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    final isEditing = routeData['isEditing'];
    dynamic image;
    PostDataModel? postDataModel;
    if (!isEditing) {
      image = routeData['image'];
    }
    if (isEditing) {
      postDataModel = routeData['postDataModel'];
      _captionTextController.text = postDataModel!.caption;
    }

    return BlocListener<PostsBloc, PostsState>(
      bloc: postsBloc,
      listenWhen: (previous, current) => current is PostsActionState,
      listener: (context, state) {
        if (state is PostChooseUploadOptionActionState) {
          showModalBottomSheet(
            context: context,
            showDragHandle: true,
            backgroundColor: MyColors.primaryColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            builder: (context) => SizedBox(
              height: 300,
              width: double.infinity,
              child: AddPostScreen(isChangingImage: state.isChangingImage),
            ),
          );
        } else if (state is PostUploadSuccessActionState) {
          Navigator.pop(context);
          ShowSnackBar(
            context: context,
            label: isEditing
                ? 'Post successfully updated.'
                : 'Post successfully uploaded.',
            color: MyColors.buttonColor1,
          ).show();
        }
      },
      child: Scaffold(
        backgroundColor: MyColors.primaryColor,
        appBar: AppBar(
          backgroundColor: MyColors.primaryColor,
          iconTheme: IconThemeData(color: MyColors.secondaryColor),
          actions: [
            BlocBuilder<PostsBloc, PostsState>(
              bloc: postsBloc,
              buildWhen: (previous, current) => current is PostsActionState,
              builder: (context, state) {
                return state is PostUploadingActionState
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: MyColors.buttonColor1,
                        ),
                      )
                    : CustomElevatedButton(
                        onPressed: () {
                          if (isEditing) {
                            postsBloc.add(PostUpdateButtonClickedEvent(
                              postDataModel: postDataModel!.copyWith(
                                caption: _captionTextController.text,
                                postedOn: DateTime.now(),
                              ),
                            ));
                          } else {
                            postsBloc.add(
                              PostUploadButtonClickedEvent(
                                caption: _captionTextController.text,
                                image: image,
                              ),
                            );
                          }
                        },
                        title: isEditing ? 'Save' : 'Post',
                        width: 100,
                        height: 40,
                        color: MyColors.buttonColor1,
                      );
              },
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                maxLines: 3,
                style: MyFonts.bodyFont(
                  fontColor: MyColors.secondaryColor,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hintText: 'Write a caption',
                  hintStyle: MyFonts.bodyFont(
                    fontColor: MyColors.secondaryColor,
                    fontWeight: FontWeight.w300,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
                controller: _captionTextController,
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus!.unfocus(),
              ),
              const SizedBox(height: 10),
              Container(
                height: 300,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: isEditing
                    ? NetworkImageWidget(
                        height: 300,
                        width: double.infinity,
                        imageUrl: postDataModel!.postUrl,
                      )
                    : Image.file(
                        image,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 10),
              if (!isEditing)
                TextButton.icon(
                  onPressed: () {
                    postsBloc.add(PostChooseImageButtonClickedEvent(
                        isChagingImage: true));
                  },
                  icon: Icon(
                    IconlyLight.camera,
                    color: MyColors.secondaryColor,
                  ),
                  label: Text(
                    'Change Image',
                    style: MyFonts.bodyFont(
                      fontColor: MyColors.secondaryColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
