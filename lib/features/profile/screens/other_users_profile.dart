import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../../../service_locator/service_locator.dart';
import '/features/auth/bloc/auth_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_posts_screen.dart';
import '../widgets/profile_info_card.dart';
import '../../../components/custom_app_top_bar.dart';
import '../../../components/custom_icon_button.dart';
import '../../../constants/constants.dart';
import '/models/user_data_model.dart';
import '/repos/auth_repo.dart';

class OtherUsersProfile extends StatelessWidget {
  OtherUsersProfile({
    super.key,
    required this.userId,
    this.showBackButton = false,
  });
  final String userId;
  final bool showBackButton;
  final AuthBloc authBloc = ServiceLocator.instance.get<AuthBloc>();
  @override
  Widget build(BuildContext context) {
    final userStream =
        FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
    final postsStream = FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .snapshots();
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      appBar: customAppBar(
        title: 'Howdy :)',
        centerTitle: true,
        showActionButton: userId == AuthRepo.currentUser!.uid,
        showLeadingButton: showBackButton,
        leadingButton: CustomIconButton(
          icon: IconlyLight.arrow_left,
          color: MyColors.secondaryColor,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actionButton: CustomIconButton(
          onPressed: () {
            authBloc.add(AuthLogoutButtonClickedEvent());
          },
          icon: IconlyLight.logout,
          color: MyColors.secondaryColor,
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, isScrolling) {
          return [
            StreamBuilder(
              stream: userStream,
              builder: (context, userSnapshots) {
                return StreamBuilder(
                  stream: postsStream,
                  builder: (context, postSnapshots) {
                    if (userSnapshots.connectionState ==
                            ConnectionState.waiting ||
                        postSnapshots.connectionState ==
                            ConnectionState.waiting) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: MyColors.buttonColor1,
                          ),
                        ),
                      );
                    }
                    final postsCount = postSnapshots.data!.docs.length;
                    final userInfoModel = UserDataModel.fromJson(
                      userSnapshots.data!.data()!,
                      userSnapshots.data!.id,
                    );
                    return SliverToBoxAdapter(
                      child: Column(
                        children: [
                          ProfileInfoCard(
                            userInfo: userInfoModel,
                            totalPosts: postsCount,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  },
                );
              },
            )
          ];
        },
        body: UserPostsScreen(userId: userId),
      ),
    );
  }
}
