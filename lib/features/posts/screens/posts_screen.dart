import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/constants/constants.dart';

import '../../../components/custom_icon_button.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        title: Image.asset(
          MyIcons.instagramLogo,
          height: 50,
          color: MyColors.secondaryColor,
        ),
        actions: [
          CustomIconButton(
            icon: Icons.favorite_border,
            color: MyColors.secondaryColor,
            onPressed: () {},
          ),
          CustomIconButton(
            onPressed: () {},
            icon: Icons.chat_bubble_outline,
            color: MyColors.secondaryColor,
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Post Here',
          style: MyFonts.firaSans(
            fontColor: MyColors.secondaryColor,
          ),
        ),
      ),
    );
  }
}
