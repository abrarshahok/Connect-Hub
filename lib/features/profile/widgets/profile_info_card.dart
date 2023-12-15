import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../../../repos/auth_repo.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({super.key});

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
                      AuthRepo.currentUser!.userImage,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    AuthRepo.currentUser!.username,
                    style: MyFonts.bodyFont(
                      fontColor: MyColors.secondaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              customColumn(count: 13, title: 'Posts'),
              customColumn(count: 262, title: 'Followers'),
              customColumn(count: 200, title: 'Following'),
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
