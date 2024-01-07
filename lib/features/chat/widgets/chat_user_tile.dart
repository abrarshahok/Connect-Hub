import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/models/user_data_model.dart';
import '/repos/auth_repo.dart';
import '/constants/constants.dart';

class ChatUserTile extends StatelessWidget {
  const ChatUserTile({
    super.key,
    required this.userInfo,
    required this.isYou,
    required this.isFollowing,
  });
  final bool isYou;
  final bool isFollowing;
  final UserDataModel userInfo;

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
      subtitle: Text(
        'online',
        style: MyFonts.bodyFont(
          fontColor: MyColors.onlineColor,
        ),
      ),
    );
  }
}
