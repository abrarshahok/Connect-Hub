import 'package:cached_network_image/cached_network_image.dart';
import 'package:connecthub/models/user_data_model.dart';
import 'package:flutter/material.dart';
import '../../../constants/constants.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard(
      {super.key, required this.userInfo, required this.totalPosts});

  final UserDataModel userInfo;
  final int totalPosts;
  @override
  Widget build(BuildContext context) {
    return Padding(
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
        ],
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
