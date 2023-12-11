import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/constants/constants.dart';
import '/models/post_data_model.dart';
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('postedOn')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(
              color: MyColors.secondaryColor,
            );
          }
          final postDocuments = snapshot.data!.docs;
          return postDocuments.isEmpty
              ? Center(
                  child: Text(
                    'No Posts!',
                    style: MyFonts.firaSans(
                      fontColor: MyColors.secondaryColor,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: postDocuments.length,
                  itemBuilder: (context, index) {
                    final postInfo = PostDataModel.fromJson(
                      postDocuments[index].data(),
                      postDocuments[index].id,
                    );
                    return Text(postInfo.username);
                  },
                );
        },
      ),
    );
  }
}
