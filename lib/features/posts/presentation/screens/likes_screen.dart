import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub/components/custom_app_top_bar.dart';
import 'package:connecthub/components/loading.dart';
import 'package:connecthub/features/auth/domain/user_data_model.dart';
import 'package:flutter/material.dart';
import '../widgets/post_like_tile.dart';
import '../../../auth/data/auth_repository.dart';
import '../../../../constants/constants.dart';

class LikesScreen extends StatelessWidget {
  static const routeName = '/likes-screen';

  const LikesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> likes = [];
    dynamic routeData = ModalRoute.of(context)?.settings.arguments;
    if (routeData != null) {
      likes = routeData as List<String>;
    }
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      appBar: customAppBar(
        context: context,
        showLeadingButton: true,
        title: 'Likes',
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where(FieldPath.documentId, whereIn: likes)
            .snapshots(),
        builder: (context, userInfoSnapshot) {
          if (userInfoSnapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }
          final usersData = userInfoSnapshot.data!.docs;
          usersData.sort((a, b) {
            if (a.id == AuthRepository.currentUser!.uid) {
              return -1;
            } else if (b.id == AuthRepository.currentUser!.uid) {
              return 1;
            } else {
              return a.id.compareTo(b.id);
            }
          });

          if (likes.isEmpty) {
            return Center(
              child: Text(
                'No Likes!',
                style: MyFonts.bodyFont(
                  fontColor: MyColors.secondaryColor,
                ),
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: usersData.length,
              itemBuilder: (context, index) {
                final userInfo =
                    UserDataModel.fromJson(usersData[index].data());

                return PostLikeTile(
                  userInfo: userInfo,
                  isFollowing: userInfo.followers
                      .contains(AuthRepository.currentUser!.uid),
                  isYou: userInfo.uid == AuthRepository.currentUser!.uid,
                );
              },
            );
          }
        },
      ),
    );
  }
}
