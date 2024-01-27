import 'package:connecthub/features/search/presentation/screens/search_screen.dart';
import 'package:connecthub/service_locator/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:iconly/iconly.dart';
import '../../../profile/presentation/screens/current_user_profile.dart';
import '../../../posts/presentation/screens/add_post_screen.dart';
import '../../../posts/presentation/screens/posts_feed.dart';
import '../bloc/home_bloc.dart';
import '/constants/constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    bool isKeyBoardEnabled = MediaQuery.of(context).viewInsets.bottom != 0;
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeShowAddPostOptionsModalSheetActionState) {
          showPostOptions();
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: currentIndex == 0,
          onPopInvoked: (didPop) {
            if (didPop) {
              return;
            }
            setState(() {
              currentIndex = 0;
            });
          },
          child: Scaffold(
            backgroundColor: MyColors.primaryColor,
            body: Stack(
              children: [
                IndexedStack(
                  index: currentIndex,
                  children: const [
                    // Screen for Posts
                    PostsFeed(),

                    // Screen to Search Profiles
                    SearchScreen(),

                    // Skip it
                    SizedBox(),

                    // Screen for Disply Current User Profile
                    CurrentUserProfile(),
                  ],
                ),
                if (!isKeyBoardEnabled)
                  Positioned(
                    bottom: 0,
                    left: 5,
                    right: 5,
                    child: _buildNavigationBar(),
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> showPostOptions() {
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: MyColors.primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => const SizedBox(
        height: 300,
        width: double.infinity,
        child: AddPostScreen(),
      ),
    );
  }

  CrystalNavigationBar _buildNavigationBar() {
    return CrystalNavigationBar(
      height: 0,
      borderRadius: 16,
      marginR: const EdgeInsets.all(20),
      paddingR: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      currentIndex: currentIndex,
      indicatorColor: Colors.white,
      unselectedItemColor: Colors.white70,
      backgroundColor: Colors.black.withOpacity(0.1),
      onTap: (index) {
        if (index == 2) {
          homeBloc.add(HomeAddPostButtonClickedEvent());
        } else {
          setState(() {
            currentIndex = index;
          });
        }
      },
      items: [
        CrystalNavigationBarItem(
          icon: IconlyBold.home,
          unselectedIcon: IconlyLight.home,
          selectedColor: Colors.white,
        ),
        CrystalNavigationBarItem(
          icon: IconlyBold.search,
          unselectedIcon: IconlyLight.search,
          selectedColor: Colors.white,
        ),
        CrystalNavigationBarItem(
          icon: IconlyBold.plus,
          unselectedIcon: IconlyLight.plus,
          selectedColor: Colors.white,
        ),
        CrystalNavigationBarItem(
          icon: IconlyBold.user_2,
          unselectedIcon: IconlyLight.user,
          selectedColor: Colors.white,
        ),
      ],
    );
  }
}
