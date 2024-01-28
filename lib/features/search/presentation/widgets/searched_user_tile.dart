import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../auth/domain/user_data_model.dart';
import '/constants/constants.dart';

class SearchedUserTile extends StatelessWidget {
  const SearchedUserTile({
    super.key,
    required this.userInfo,
    required this.isFollowing,
    required this.onTap,
  });

  final bool isFollowing;
  final UserDataModel userInfo;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: CachedNetworkImageProvider(
          userInfo.userImage,
        ),
      ),
      title: Text(
        userInfo.username,
        style: MyFonts.bodyFont(
          fontColor: MyColors.secondaryColor,
          fontSize: 16,
        ),
      ),
    );
  }
}
