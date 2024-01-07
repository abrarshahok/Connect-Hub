import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/components/custom_elevated_button.dart';
import '../../profile/bloc/profile_bloc.dart';
import '/models/user_data_model.dart';
import '/repos/auth_repo.dart';
import '/constants/constants.dart';

class PostLikeTile extends StatelessWidget {
  PostLikeTile({
    super.key,
    required this.userInfo,
    required this.isYou,
    required this.isFollowing,
  });
  final bool isYou;
  final bool isFollowing;
  final UserDataModel userInfo;

  final _profileBloc = ProfileBloc();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(
          userInfo.userImage,
        ),
      ),
      title: Text(
        userInfo.username == AuthRepo.currentUser!.username
            ? 'You'
            : userInfo.username,
        style: MyFonts.bodyFont(
          fontColor: MyColors.secondaryColor,
        ),
      ),
      trailing: isYou
          ? null
          : CustomElevatedButton(
              onPressed: () {
                _profileBloc.add(ProfileFollowOrUnfollowButtonClickedEvent(
                  userId: userInfo.uid,
                  followers: userInfo.followers,
                ));
              },
              title: isFollowing ? 'Unfollow' : 'Follow',
              width: 150,
              height: 30,
              color: isFollowing
                  ? MyColors.secondaryColor.withOpacity(0.01)
                  : MyColors.buttonColor1,
            ),
    );
  }
}
