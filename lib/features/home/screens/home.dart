import 'package:connecthub/features/posts/screens/saved_posts_screen.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import '/features/auth/bloc/auth_bloc.dart';
import '/features/profile/screens/profile.dart';
import '/features/posts/screens/add_post_screen.dart';
import '../../posts/screens/posts_feed.dart';
import '../bloc/home_bloc.dart';
import '/constants/constants.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.authBloc});
  final AuthBloc authBloc;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeBloc homeBloc = HomeBloc();

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetList = [
      const PostsFeed(),
      const Center(child: Text('In Making')),
      AddPostScreen(),
      const SavedPostsScreen(),
      Profile(authBloc: widget.authBloc),
    ];
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeShowAddPostOptionsModalSheetActionState) {
          showModalBottomSheet(
            context: context,
            showDragHandle: true,
            backgroundColor: MyColors.primaryColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            builder: (context) => SizedBox(
              height: 300,
              width: double.infinity,
              child: AddPostScreen(),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: MyColors.primaryColor,
          body: Stack(
            children: [
              widgetList[currentIndex],
              Positioned(
                bottom: 0,
                left: 5,
                right: 5,
                child: CrystalNavigationBar(
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
                      return;
                    }
                    setState(() {
                      currentIndex = index;
                    });
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
                      icon: IconlyBold.bookmark,
                      unselectedIcon: IconlyLight.bookmark,
                      selectedColor: Colors.blueGrey,
                    ),
                    CrystalNavigationBarItem(
                      icon: IconlyBold.user_2,
                      unselectedIcon: IconlyLight.user,
                      selectedColor: Colors.white,
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
