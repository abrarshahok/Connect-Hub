import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '/components/custom_app_top_bar.dart';
import '/components/custom_icon_button.dart';
import '/features/profile/screens/user_posts_screen.dart';
import '../widgets/profile_info_card.dart';
import 'user_saved_posts_screen.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../../constants/constants.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key, required this.authBloc});
  final AuthBloc authBloc;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.primaryColor,
        title: CustomAppTopBar(
          title: 'Howdy :)',
          centerTitle: true,
          showActionButton: true,
          actionButton: CustomIconButton(
            onPressed: () {
              widget.authBloc.add(AuthLogoutButtonClickedEvent());
            },
            icon: IconlyLight.logout,
            color: MyColors.secondaryColor,
          ),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const ProfileInfoCard(),
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
          children: const [
            UserPostsScreen(),
            UserSavedPostsScreen(),
          ],
        ),
      ),
    );
  }
}
