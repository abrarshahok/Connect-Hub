import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/features/auth/data/auth_repository.dart';
import '/features/profile/presentation/screens/profile_settings_screen.dart';
import 'package:connecthub/service_locator/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import '../bloc/profile_bloc.dart';
import '/components/custom_app_top_bar.dart';
import '/components/custom_icon_button.dart';
import 'user_posts_screen.dart';
import '../widgets/profile_info_card.dart';
import 'user_saved_posts_screen.dart';
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

  final profileBloc = ServiceLocator.instance.get<ProfileBloc>();
  @override
  Widget build(BuildContext context) {
    final postsStream = FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: AuthRepository.currentUser!.uid)
        .snapshots();
    return BlocListener<ProfileBloc, ProfileState>(
      bloc: profileBloc,
      listener: (context, state) {
        if (state is ProfileNavigateToProfileSettingsScreenActionState) {
          Navigator.pushNamed(context, ProfileSettingsScreen.routeName);
        }
      },
      child: Scaffold(
        backgroundColor: MyColors.primaryColor,
        appBar: customAppBar(
          title: 'Profile',
          context: context,
          showLeadingButton: widget.showBackButton,
          showActionButton: true,
          actionButton: CustomIconButton(
            onPressed: () {
              profileBloc.add(
                  ProfileNavigateToProfileSettingScreenButtonClickedEvent());
            },
            icon: IconlyLight.setting,
            color: MyColors.tercharyColor,
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
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          BlocBuilder<ProfileBloc, ProfileState>(
                            bloc: profileBloc,
                            buildWhen: (previous, current) =>
                                current is ProfileActionState,
                            builder: (context, state) {
                              return ProfileInfoCard(
                                userInfo: AuthRepository.currentUser!,
                                totalPosts: postsCount,
                              );
                            },
                          ),
                          TabBar(
                            controller: tabController,
                            dividerColor: Colors.transparent,
                            labelColor: MyColors.buttonColor1,
                            indicatorSize: TabBarIndicatorSize.tab,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            tabs: [
                              Tab(
                                child: Icon(
                                  IconlyBold.image,
                                  color: MyColors.buttonColor1,
                                ),
                              ),
                              Tab(
                                child: Icon(
                                  IconlyBold.bookmark,
                                  color: MyColors.buttonColor1,
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
                ),
              );
            }),
      ),
    );
  }
}
