import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub/components/custom_app_top_bar.dart';
import 'package:connecthub/components/custom_icon_button.dart';
import 'package:connecthub/features/posts/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import '../../../models/post_data_model.dart';
import '/features/posts/screens/saved_posts_screen.dart';
import '../../auth/bloc/auth_bloc.dart';
import '/repos/auth_repo.dart';
import '../../../constants/constants.dart';

class Profile extends StatelessWidget {
  const Profile({super.key, required this.authBloc});
  final AuthBloc authBloc;

  @override
  Widget build(BuildContext context) {
    final postStream = FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: AuthRepo.currentUser!.uid)
        .orderBy('postedOn', descending: true)
        .snapshots();

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
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 80,
                        left: 10,
                        right: 10,
                        bottom: 10,
                      ),
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
                                    style: MyFonts.bodyFont(
                                      fontColor: MyColors.secondaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              customColumn(count: 13, title: 'Posts'),
                              customColumn(count: 262, title: 'Followers'),
                              customColumn(count: 200, title: 'Following'),
                            ],
                          ),
                          Divider(
                              color: MyColors.secondaryColor, thickness: 0.1),
                        ],
                      ),
                    ),
                  ),
                  StreamBuilder(
                    stream: postStream,
                    builder: (context, snapshots) {
                      if (snapshots.connectionState ==
                          ConnectionState.waiting) {
                        return SliverToBoxAdapter(
                          child: Center(
                            child: CircularProgressIndicator(
                                color: MyColors.buttonColor1),
                          ),
                        );
                      }
                      final postDocuments = snapshots.data!.docs;
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount: postDocuments.length,
                          (context, index) {
                            final postInfo = PostDataModel.fromJson(
                              postDocuments[index].data(),
                              postDocuments[index].id,
                            );
                            return PostCard(
                              postDataModel: postInfo,
                              isSaved: true,
                            );
                          },
                        ),
                      );
                    },
                  )
                ],
              );
            },
          ),
          Positioned(
            left: 7,
            right: 7,
            top: 20,
            child: CustomAppTopBar(
              title: 'Howdy :)',
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
          style: MyFonts.logoFont(
            fontColor: MyColors.secondaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: MyFonts.bodyFont(
            fontColor: MyColors.secondaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// SliverToBoxAdapter(
                  //   child: StreamBuilder(
                  //     stream: postStream,
                  //     builder: (context, snapshots) {
                  //       if (snapshots.connectionState ==
                  //           ConnectionState.waiting) {
                  //         return SliverToBoxAdapter(
                  //           child: Center(
                  //             child: CircularProgressIndicator(
                  //               color: MyColors.buttonColor1,
                  //             ),
                  //           ),
                  //         );
                  //       }
                        // final postDocuments = snapshots.data!.docs;
                        // return SliverList(
                        //   delegate: SliverChildBuilderDelegate(
                        //     childCount: postDocuments.length,
                        //     (context, index) {
                        //       final postInfo = PostDataModel.fromJson(
                        //         postDocuments[index].data(),
                        //         postDocuments[index].id,
                        //       );
                        //       return PostCard(
                        //         postDataModel: postInfo,
                        //         isSaved: true,
                        //       );
                        //     },
                        //   ),
                        // );
                  //     },
                  //   ),
                  // ),