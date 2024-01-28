import 'dart:io';

import 'package:connecthub/components/custom_elevated_button.dart';
import 'package:connecthub/components/custom_icon_button.dart';
import 'package:connecthub/components/network_image_widget.dart';
import 'package:connecthub/components/show_snackbar.dart';
import 'package:connecthub/features/auth/data/auth_repository.dart';
import 'package:connecthub/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:connecthub/service_locator/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import '../../../search/presentation/widgets/custom_text_field.dart';
import '../bloc/profile_bloc.dart';
import '/constants/constants.dart';
import '/components/custom_app_top_bar.dart';

class ProfileSettingsScreen extends StatelessWidget {
  ProfileSettingsScreen({super.key});
  static const routeName = '/profile-settings-screen';
  final TextEditingController _userNameController = TextEditingController();
  final profileBloc = ServiceLocator.instance.get<ProfileBloc>();
  @override
  Widget build(BuildContext context) {
    _userNameController.text = AuthRepository.currentUser!.username;
    return BlocConsumer<ProfileBloc, ProfileState>(
      bloc: profileBloc,
      listenWhen: (previous, current) => current is ProfileActionState,
      buildWhen: (previous, current) => current is! ProfileActionState,
      listener: (context, state) {
        if (state is ProfileSaveProfileChangesSuccesActionState) {
          ShowSnackBar(
            context: context,
            label: 'Changes Saved Successfully.',
            color: MyColors.buttonColor1,
          ).show();
        } else if (state is ProfileSaveProfileChangesFailedActionState) {
          ShowSnackBar(
            context: context,
            label: 'Something went wrong!',
            color: Colors.red,
          ).show();
        }
      },
      builder: (context, state) {
        File? pickedImage;
        if (state is ProfileNewImageChoosenSuccessState) {
          pickedImage = state.pickedImage;
        }

        return Scaffold(
          backgroundColor: MyColors.primaryColor,
          appBar: customAppBar(
            title: 'Settings',
            context: context,
            showLeadingButton: true,
            showActionButton: true,
            actionButton: CustomIconButton(
              icon: IconlyLight.logout,
              color: MyColors.buttonColor1,
              onPressed: () {
                Navigator.pop(context);
                ServiceLocator.instance
                    .get<AuthBloc>()
                    .add(AuthLogoutButtonClickedEvent());
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: pickedImage != null
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: MyColors.tercharyColor),
                            ),
                            child: Image.file(
                              pickedImage,
                              height: 200,
                              width: 200,
                            ),
                          )
                        : NetworkImageWidget(
                            height: 200,
                            width: 200,
                            imageUrl: AuthRepository.currentUser!.userImage,
                          ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: CustomElevatedButton(
                      onPressed: () =>
                          _pickProfileImage(ImageSource.gallery, context),
                      title: 'Change Image',
                      width: 200,
                      height: 50,
                      color: MyColors.buttonColor1,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'Name',
                    style: MyFonts.headingFont(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    hintText: 'Enter name here',
                    textController: _userNameController,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BlocBuilder<ProfileBloc, ProfileState>(
            bloc: profileBloc,
            buildWhen: (previous, current) => current is ProfileActionState,
            builder: (context, state) {
              return BottomAppBar(
                child: state is ProfileSavingProfileChangesActionState
                    ? SizedBox(
                        height: 50,
                        width: 50,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: MyColors.buttonColor1,
                          ),
                        ),
                      )
                    : CustomElevatedButton(
                        onPressed: () {
                          if (pickedImage == null) {
                            profileBloc.add(
                              ProfileSaveProfileChangesButtonClickedEvent(
                                userName: _userNameController.text,
                                profileImage: null,
                              ),
                            );
                          } else {
                            profileBloc.add(
                              ProfileSaveProfileChangesButtonClickedEvent(
                                userName: _userNameController.text,
                                profileImage: pickedImage,
                              ),
                            );
                          }
                        },
                        title: 'Save Changes',
                        width: double.infinity,
                        height: 40,
                        color: MyColors.buttonColor1,
                      ),
              );
            },
          ),
        );
      },
    );
  }

  void _pickProfileImage(
    ImageSource imageSource,
    BuildContext context,
  ) {
    ImagePicker().pickImage(source: imageSource).then((image) {
      if (image == null) {
        return;
      }

      final pickedImage = File(image.path);
      profileBloc
          .add(ProfileNewImageChoosenSuccessEvent(pickedImage: pickedImage));
    });
  }
}
