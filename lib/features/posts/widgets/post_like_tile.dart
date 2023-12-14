import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '/constants/constants.dart';

class PostLikeTile extends StatelessWidget {
  const PostLikeTile({
    super.key,
    required this.userImageUrl,
    required this.userName,
    required this.isYou,
  });

  final String userImageUrl;
  final String userName;
  final bool isYou;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(
          userImageUrl,
        ),
      ),
      title: Text(
        userName,
        style: MyFonts.firaSans(
          fontColor: MyColors.secondaryColor,
        ),
      ),
      trailing: isYou
          ? null
          : ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.buttonColor1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(100, 30),
                fixedSize: const Size(100, 30),
              ),
              child: Text(
                'Follow',
                style: MyFonts.firaSans(
                  fontColor: MyColors.secondaryColor,
                ),
              ),
            ),
    );
  }
}
