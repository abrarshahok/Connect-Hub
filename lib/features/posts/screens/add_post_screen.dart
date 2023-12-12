import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_flutter/components/show_snackbar.dart';
import 'package:line_icons/line_icons.dart';
import '/constants/constants.dart';

import '../bloc/posts_bloc.dart';

class AddPostScreen extends StatelessWidget {
  static const routeName = '/add-post-screen';

  final TextEditingController _captionTextController = TextEditingController();
  final PostsBloc postsBloc = PostsBloc();
  void _pickImage(ImageSource imageSource, BuildContext context) {
    ImagePicker().pickImage(source: imageSource).then((image) {
      if (image == null) {
        return;
      }
      Navigator.pop(context);
      final pickedImage = File(image.path);
      postsBloc.add(PostImageChoosenSuccessEvent(pickedImage: pickedImage));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostsBloc, PostsState>(
      bloc: postsBloc,
      listenWhen: (previous, current) => current is PostsActionState,
      buildWhen: (previous, current) => current is! PostsActionState,
      listener: (context, state) {
        if (state is PostChooseUploadOptionActionState) {
          showOptionsDialog(context);
        } else if (state is PostUploadSuccessActionState) {
          Navigator.pop(context);
          ShowSnackBar(
            context: context,
            label: 'Post successfully uploaded.',
            color: MyColors.buttonColor1,
          ).show();
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case const (PostChoosenSuccessState):
            final successState = state as PostChoosenSuccessState;
            return Scaffold(
              backgroundColor: MyColors.primaryColor,
              appBar: AppBar(
                backgroundColor: MyColors.primaryColor,
                iconTheme: IconThemeData(color: MyColors.secondaryColor),
                actions: [
                  TextButton(
                    onPressed: () {
                      postsBloc.add(
                        PostUploadButtonClickedEvent(
                          caption: _captionTextController.text,
                          image: successState.choosenImage,
                        ),
                      );
                    },
                    child: BlocBuilder<PostsBloc, PostsState>(
                      bloc: postsBloc,
                      buildWhen: (previous, current) =>
                          current is PostsActionState,
                      builder: (context, state) {
                        return state is PostUploadingActionState
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: MyColors.buttonColor1,
                                ),
                              )
                            : Text(
                                'Post',
                                style: MyFonts.firaSans(
                                  fontColor: MyColors.secondaryColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              );
                      },
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextField(
                      maxLines: 5,
                      style: MyFonts.firaSans(
                        fontColor: MyColors.secondaryColor,
                        fontWeight: FontWeight.w300,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Write a caption',
                        hintStyle: MyFonts.firaSans(
                          fontColor: MyColors.secondaryColor,
                          fontWeight: FontWeight.w300,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                      controller: _captionTextController,
                      onTapOutside: (_) =>
                          FocusManager.instance.primaryFocus!.unfocus(),
                    ),
                    Container(
                      height: 300,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Image.file(
                        successState.choosenImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: () {
                        postsBloc.add(PostChooseImageButtonClickedEvent());
                      },
                      icon: Icon(
                        LineIcons.camera,
                        color: MyColors.secondaryColor,
                      ),
                      label: Text(
                        'Change Image',
                        style: MyFonts.firaSans(
                          fontColor: MyColors.secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          default:
            return Scaffold(
              backgroundColor: MyColors.primaryColor,
              appBar: AppBar(
                backgroundColor: MyColors.primaryColor,
                iconTheme: IconThemeData(color: MyColors.secondaryColor),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        postsBloc.add(PostChooseImageButtonClickedEvent());
                      },
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: MyColors.secondaryColor,
                      ),
                      label: Text(
                        'Choose Image',
                        style: MyFonts.firaSans(
                          fontColor: MyColors.secondaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
        }
      },
    );
  }

  Future<dynamic> showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog.adaptive(
            backgroundColor: MyColors.secondaryColor,
            title: const Text(
              'Choose Option',
              textAlign: TextAlign.center,
            ),
            titleTextStyle: MyFonts.firaSans(
              fontColor: MyColors.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  icon: Icon(
                    Icons.image,
                    color: MyColors.primaryColor,
                  ),
                  onPressed: () => _pickImage(ImageSource.gallery, context),
                  label: Text(
                    'Choose from gallery',
                    style: MyFonts.firaSans(
                      fontColor: MyColors.primaryColor,
                    ),
                  ),
                ),
                TextButton.icon(
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    color: MyColors.primaryColor,
                  ),
                  onPressed: () => _pickImage(ImageSource.camera, context),
                  label: Text(
                    'Capture new image',
                    style: MyFonts.firaSans(
                      fontColor: MyColors.primaryColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: MyFonts.firaSans(
                      fontColor: MyColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
