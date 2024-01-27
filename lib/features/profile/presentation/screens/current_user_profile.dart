import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub/features/auth/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../../../../service_locator/service_locator.dart';
import '/components/custom_app_top_bar.dart';
import '/components/custom_icon_button.dart';
import 'user_posts_screen.dart';
import '../widgets/profile_info_card.dart';
import 'user_saved_posts_screen.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../constants/constants.dart';

class CurrentUserProfile extends StatefulWidget {
  const CurrentUserProfile({
    super.key,
    this.showBackButton = false,
  });
  final bool showBackButton;

  @override
  State<CurrentUserProfile> createState() => _CurrentUserProfileState();
}

class _CurrentUserProfileState extends State<CurrentUserProfile>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postsStream = FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: AuthRepository.currentUser!.uid)
        .snapshots();
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      appBar: customAppBar(
        title: 'Howdy :)',
        showActionButton: true,
        showLeadingButton: widget.showBackButton,
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
      body: StreamBuilder(
          stream: postsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: MyColors.buttonColor1,
              ));
            }
            final postsCount = snapshot.data!.docs.length;
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      ProfileInfoCard(
                        userInfo: AuthRepository.currentUser!,
                        totalPosts: postsCount,
                      ),
                      TabBar(
                        controller: tabController,
                        dividerColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.tab,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        tabs: [
                          Tab(
                            child: Icon(
                              IconlyBold.image,
                              color: MyColors.secondaryColor,
                            ),
                          ),
                          Tab(
                            child: Icon(
                              IconlyBold.bookmark,
                              color: MyColors.secondaryColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
              body: TabBarView(
                controller: tabController,
                children: [
                  UserPostsScreen(userId: AuthRepository.currentUser!.uid),
                  const UserSavedPostsScreen(),
                ],
              ),
            );
          }),
    );
  }
}
