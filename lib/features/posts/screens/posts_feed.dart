import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line_icons/line_icons.dart';
import '/features/posts/widgets/post_card.dart';
import '/constants/constants.dart';
import '/models/post_data_model.dart';
import '../../../components/custom_icon_button.dart';

class PostsFeed extends StatelessWidget {
  const PostsFeed({super.key});

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
            icon: LineIcons.heart,
            color: MyColors.secondaryColor,
            onPressed: () {},
          ),
          CustomIconButton(
            onPressed: () {},
            icon: LineIcons.facebookMessenger,
            color: MyColors.secondaryColor,
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('postedOn')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: MyColors.buttonColor1,
              ),
            );
          }
          final postDocuments = snapshot.data!.docs;
          if (postDocuments.isEmpty) {
            return Center(
              child: Text(
                'No Posts!',
                style: MyFonts.firaSans(
                  fontColor: MyColors.secondaryColor,
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: postDocuments.length,
              itemBuilder: (context, index) {
                final postInfo = PostDataModel.fromJson(
                  postDocuments[index].data(),
                  postDocuments[index].id,
                );
                return PostCard(postDataModel: postInfo);
              },
            );
          }
        },
      ),
    );
  }
}
