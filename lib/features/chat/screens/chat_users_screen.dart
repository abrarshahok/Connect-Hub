import 'package:cloud_firestore/cloud_firestore.dart';
import '/components/loading.dart';
import '/features/chat/widgets/chat_user_tile.dart';
import '/repos/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../../../components/custom_icon_button.dart';
import '../../../constants/constants.dart';
import '../../../models/user_data_model.dart';
import '/components/custom_app_top_bar.dart';

class ChatUsersScreen extends StatelessWidget {
  static const routeName = '/chat-users-screen';
  const ChatUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listOfUsers = [
      ...AuthRepo.currentUser!.followers,
      ...AuthRepo.currentUser!.following
    ];
    final followedOrFollowingUsersStream = FirebaseFirestore.instance
        .collection('users')
        .where(
          FieldPath.documentId,
          whereIn: listOfUsers,
        )
        .snapshots();
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      appBar: customAppBar(
        showLeadingButton: true,
        leadingButton: CustomIconButton(
          color: MyColors.secondaryColor,
          icon: IconlyLight.arrow_left,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: 'Chat',
      ),
      body: StreamBuilder(
        stream: followedOrFollowingUsersStream,
        builder: (context, userSnapshots) {
          if (userSnapshots.connectionState == ConnectionState.waiting) {
            return const Loading();
          }
          final usersData = userSnapshots.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: usersData.length,
            itemBuilder: (context, index) {
              final userInfo = UserDataModel.fromJson(
                usersData[index].data(),
                usersData[index].id,
              );

              return ChatUserTile(
                userInfo: userInfo,
                isFollowing:
                    userInfo.followers.contains(AuthRepo.currentUser!.uid),
                isYou: userInfo.uid == AuthRepo.currentUser!.uid,
              );
            },
          );
        },
      ),
    );
  }
}
