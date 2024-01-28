import 'package:cached_network_image/cached_network_image.dart';
import 'package:connecthub/components/custom_elevated_button.dart';
import 'package:connecthub/components/social_login_button.dart';
import 'package:connecthub/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:connecthub/features/auth/data/auth_repository.dart';
import 'package:connecthub/service_locator/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import '../../../auth/domain/user_data_model.dart';
import '../../../../constants/constants.dart';

class ProfileInfoCard extends StatelessWidget {
  ProfileInfoCard({
    super.key,
    required this.userInfo,
    required this.totalPosts,
  });

  final UserDataModel userInfo;
  final int totalPosts;
  final profileBloc = ServiceLocator.instance.get<ProfileBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      bloc: profileBloc,
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
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: MyColors.tercharyColor,
                    backgroundImage: CachedNetworkImageProvider(
                      userInfo.userImage,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    userInfo.username,
                    style: MyFonts.bodyFont(
                      fontColor: MyColors.secondaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
            const SizedBox(height: 20),
            if (userInfo.uid != AuthRepository.currentUser!.uid)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialLoginButton(
                    icon: IconlyLight.message,
                    title: 'Message',
                    onTap: () {},
                  ),
                  const SizedBox(width: 10),
                  CustomElevatedButton(
                    onPressed: () {
                      profileBloc.add(ProfileFollowOrUnfollowButtonClickedEvent(
                        userId: userInfo.uid,
                        followers: userInfo.followers,
                      ));
                    },
                    title: userInfo.followers
                            .contains(AuthRepository.currentUser!.uid)
                        ? 'Unfollow'
                        : 'Follow',
                    width: 150,
                    height: 40,
                    color: userInfo.followers
                            .contains(AuthRepository.currentUser!.uid)
                        ? MyColors.tercharyColor
                        : MyColors.buttonColor1,
                  ),
                ],
              ),
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
          style: MyFonts.buttonFont(
            fontColor: MyColors.secondaryColor,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          title,
          style: MyFonts.bodyFont(
            fontColor: MyColors.secondaryColor.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
