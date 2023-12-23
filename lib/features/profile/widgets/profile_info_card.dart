import 'package:cached_network_image/cached_network_image.dart';
import 'package:connecthub/components/custom_elevated_button.dart';
import 'package:connecthub/features/profile/bloc/profile_bloc.dart';
import 'package:connecthub/repos/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/models/user_data_model.dart';
import '../../../constants/constants.dart';

class ProfileInfoCard extends StatelessWidget {
  ProfileInfoCard({
    super.key,
    required this.userInfo,
    required this.totalPosts,
  });

  final UserDataModel userInfo;
  final int totalPosts;

  final _profileBloc = ProfileBloc();
  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      bloc: _profileBloc,
      listenWhen: (previous, current) => current is ProfileActionState,
      listener: (context, state) {},
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: CachedNetworkImageProvider(
                        userInfo.userImage,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      userInfo.username,
                      style: MyFonts.bodyFont(
                        fontColor: MyColors.secondaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                customColumn(
                  count: totalPosts,
                  title: 'Posts',
                ),
                customColumn(
                  count: userInfo.followers.length,
                  title: 'Followers',
                ),
                customColumn(
                  count: userInfo.following.length,
                  title: 'Following',
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (userInfo.uid != AuthRepo.currentUser!.uid)
              CustomElevatedButton(
                onPressed: () {
                  _profileBloc.add(ProfileFollowOrUnfollowButtonClickedEvent(
                      userId: userInfo.uid, followers: userInfo.followers));
                },
                title: userInfo.followers.contains(AuthRepo.currentUser!.uid)
                    ? 'Unfollow'
                    : 'Follow',
                width: double.infinity,
                height: 40,
                color: userInfo.followers.contains(AuthRepo.currentUser!.uid)
                    ? MyColors.secondaryColor.withOpacity(0.01)
                    : MyColors.buttonColor1,
              )
          ],
        ),
      ),
    );
  }

  Column customColumn({
    required String title,
    required int count,
  }) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: MyFonts.logoFont(
            fontColor: MyColors.secondaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: MyFonts.bodyFont(
            fontColor: MyColors.secondaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
