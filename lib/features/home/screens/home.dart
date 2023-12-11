import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_flutter/features/posts/screens/add_post_screen.dart';
import '../../posts/screens/posts_screen.dart';
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
          body: const PostsScreen(),
          bottomNavigationBar: BottomAppBar(
            color: MyColors.primaryColor,
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomIconButton(
                  icon: Icons.home,
                  color: MyColors.secondaryColor,
                  onPressed: () {},
                ),
                CustomIconButton(
                  onPressed: () {},
                  icon: Icons.search,
                  color: MyColors.secondaryColor,
                ),
                CustomIconButton(
                  icon: Icons.add_box_outlined,
                  color: MyColors.secondaryColor,
                  onPressed: () {
                    homeBloc.add(HomeAddPostButtonClickedEvent());
                  },
                ),
                CustomIconButton(
                  onPressed: () {},
                  icon: Icons.person,
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
