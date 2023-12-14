import 'package:cached_network_image/cached_network_image.dart';
import 'package:connecthub/components/custom_app_top_bar.dart';
import 'package:connecthub/components/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import '/features/posts/screens/saved_posts_screen.dart';
import '../../auth/bloc/auth_bloc.dart';
import '/repos/auth_repo.dart';
import '../../../constants/constants.dart';

class Profile extends StatelessWidget {
  const Profile({super.key, required this.authBloc});
  final AuthBloc authBloc;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: Stack(
        children: [
          BlocConsumer<AuthBloc, AuthState>(
            bloc: authBloc,
            listenWhen: (previous, current) => current is AuthActionState,
            buildWhen: (previous, current) => current is! AuthActionState,
            listener: (context, state) {
              if (state is AuthNavigateToSavedPostScreenActionState) {
                Navigator.pushNamed(context, SavedPostsScreen.routeName);
              }
            },
            builder: (context, state) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: CachedNetworkImageProvider(
                                AuthRepo.currentUser!.userImage,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              AuthRepo.currentUser!.username,
                              style: MyFonts.firaSans(
                                fontColor: MyColors.secondaryColor,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        customColumn(count: 13, title: 'Posts'),
                        customColumn(count: 262, title: 'Followers'),
                        customColumn(count: 200, title: 'Following'),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            left: 7,
            right: 7,
            top: 20,
            child: CustomAppTopBar(
              title: 'Welcome ${AuthRepo.currentUser!.username}',
              showActionButton: true,
              actionButton: CustomIconButton(
                icon: IconlyLight.logout,
                color: Colors.white,
                onPressed: () {
                  authBloc.add(AuthLogoutButtonClickedEvent());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column customColumn({
    required String title,
    required int count,
  }) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: MyFonts.firaSans(
            fontColor: MyColors.secondaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: MyFonts.firaSans(
            fontColor: MyColors.secondaryColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
