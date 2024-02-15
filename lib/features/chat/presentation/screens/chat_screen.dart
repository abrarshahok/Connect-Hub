import 'package:connecthub/features/auth/domain/user_data_model.dart';
import 'package:connecthub/features/chat/presentation/widgets/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/components/custom_app_top_bar.dart';
import '/components/loading.dart';
import '/features/auth/data/auth_repository.dart';

import '../../../../constants/constants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<String> allUsers = [];
  @override
  void initState() {
    allUsers = [
      ...AuthRepository.currentUser!.followers,
      ...AuthRepository.currentUser!.following
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      appBar: customAppBar(title: 'Messages'),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('uid', whereIn: allUsers)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(
              child: Text(
                'No messages!',
                style: MyFonts.bodyFont(
                  fontColor: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            itemBuilder: (context, index) {
              final userInfo = UserDataModel.fromJson(docs[index].data());
              return UserTile(userInfo: userInfo);
            },
          );
        },
      ),
    );
  }
}
