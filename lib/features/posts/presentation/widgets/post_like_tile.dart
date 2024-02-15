import 'package:connecthub/service_locator/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../profile/presentation/screens/current_user_profile.dart';
import '../../../profile/presentation/screens/other_users_profile.dart';
import '/components/custom_elevated_button.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../auth/domain/user_data_model.dart';
import '../../../auth/data/auth_repository.dart';
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

  final profileBloc = ServiceLocator.instance.get<ProfileBloc>();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AuthRepository.currentUser!.uid == userInfo.uid
                    ? const CurrentUserProfile(
                        showBackButton: true,
                      )
                    : OtherUsersProfile(
                        userId: userInfo.uid,
                        showBackButton: true,
                      ),
          ),
        );
      },
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(
          userInfo.userImage,
        ),
      ),
      title: Text(
        userInfo.uid == AuthRepository.currentUser!.uid
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
                profileBloc.add(ProfileFollowOrUnfollowButtonClickedEvent(
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
