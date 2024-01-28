import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import '/service_locator/service_locator.dart';
import 'upload_post_screen.dart';
import '/constants/constants.dart';
import '../bloc/posts_bloc.dart';

class AddPostScreen extends StatelessWidget {
  AddPostScreen({super.key, this.isChangingImage = false});
  final bool isChangingImage;
  static const routeName = '/add-post-screen';

  void _pickImage(
    ImageSource imageSource,
    BuildContext context,
  ) {
    ImagePicker().pickImage(source: imageSource).then((image) {
      if (image == null) {
        return;
      }
      Navigator.pop(context);
      final pickedImage = File(image.path);
      postsBloc.add(PostImageChoosenSuccessEvent(pickedImage: pickedImage));
    });
  }

  final postsBloc = ServiceLocator.instance.get<PostsBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostsBloc, PostsState>(
      bloc: postsBloc,
      listenWhen: (previous, current) => current is PostsActionState,
      buildWhen: (previous, current) => current is! PostsActionState,
      listener: (context, state) {
        if (state is PostChoosenSuccessActionState) {
          final image = state.choosenImage;
          if (isChangingImage) {
            Navigator.pushReplacementNamed(context, UploadPostScreen.routeName,
                arguments: {
                  'postBloc': postsBloc,
                  'image': image,
                  'isEditing': false,
                });
          } else {
            Navigator.pushNamed(context, UploadPostScreen.routeName,
                arguments: {
                  'postBloc': postsBloc,
                  'image': image,
                  'isEditing': false,
                });
          }
        }
      },
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            TextButton.icon(
              icon: Icon(
                IconlyLight.camera,
                color: MyColors.secondaryColor,
                size: 25,
              ),
              onPressed: () => _pickImage(ImageSource.camera, context),
              label: Text(
                'Capture new image',
                style: MyFonts.bodyFont(
                  fontColor: MyColors.secondaryColor,
                  fontSize: 20,
                ),
              ),
            ),
            TextButton.icon(
              icon: Icon(
                IconlyLight.image,
                color: MyColors.secondaryColor,
                size: 25,
              ),
              onPressed: () => _pickImage(ImageSource.gallery, context),
              label: Text(
                'Choose from gallery',
                style: MyFonts.bodyFont(
                  fontColor: MyColors.secondaryColor,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
