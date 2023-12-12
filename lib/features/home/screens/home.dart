import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/features/posts/screens/add_post_screen.dart';
import 'package:line_icons/line_icons.dart';
import '../../posts/screens/posts_feed.dart';
import '../bloc/home_bloc.dart';
import '/components/custom_icon_button.dart';
import '/constants/constants.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final HomeBloc homeBloc = HomeBloc();
  @override
  Widget build(BuildContext context) {
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
          body: const PostsFeed(),
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
                  onPressed: () {},
                ),
                CustomIconButton(
                  onPressed: () {},
                  icon: LineIcons.search,
                  color: MyColors.secondaryColor,
                ),
                CustomIconButton(
                  icon: LineIcons.plusCircle,
                  color: MyColors.secondaryColor,
                  onPressed: () {
                    homeBloc.add(HomeAddPostButtonClickedEvent());
                  },
                ),
                CustomIconButton(
                  onPressed: () {},
                  icon: LineIcons.user,
                  color: MyColors.secondaryColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
