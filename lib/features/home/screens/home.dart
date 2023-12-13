import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_flutter/features/auth/bloc/auth_bloc.dart';
import 'package:instagram_clone_flutter/features/profile/screens/profile.dart';
import '/features/posts/screens/add_post_screen.dart';
import 'package:line_icons/line_icons.dart';
import '../../posts/screens/posts_feed.dart';
import '../bloc/home_bloc.dart';
import '/components/custom_icon_button.dart';
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
      Profile(authBloc: widget.authBloc),
    ];
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeNavigateToAddPostPageActionState) {
          Navigator.pushNamed(context, AddPostScreen.routeName);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: MyColors.primaryColor,
          body: widgetList[currentIndex],
          bottomNavigationBar: BottomAppBar(
            color: MyColors.primaryColor,
            height: 60,
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomIconButton(
                  icon: LineIcons.home,
                  color: MyColors.secondaryColor,
                  onPressed: () {
                    setState(() {
                      currentIndex = 0;
                    });
                  },
                ),
                CustomIconButton(
                  icon: LineIcons.search,
                  color: MyColors.secondaryColor,
                  onPressed: () {
                    setState(() {
                      currentIndex = 1;
                    });
                  },
                ),
                CustomIconButton(
                  icon: LineIcons.plusCircle,
                  color: MyColors.secondaryColor,
                  onPressed: () {
                    homeBloc.add(HomeAddPostButtonClickedEvent());
                  },
                ),
                CustomIconButton(
                  icon: LineIcons.user,
                  color: MyColors.secondaryColor,
                  onPressed: () {
                    setState(() {
                      currentIndex = 2;
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
