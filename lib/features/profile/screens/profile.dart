import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/bloc/auth_bloc.dart';
import '/components/custom_elevated_button.dart';
import '/repos/auth_repo.dart';
import '../../../constants/constants.dart';

class Profile extends StatelessWidget {
  Profile({super.key, required this.authBloc});
  final AuthBloc authBloc;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        title: Text(
          AuthRepo.currentUser!.username.toLowerCase().replaceAll(' ', '_'),
          style: MyFonts.firaSans(
            fontColor: MyColors.secondaryColor,
          ),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: authBloc,
        listenWhen: (previous, current) => current is AuthActionState,
        buildWhen: (previous, current) => current is! AuthActionState,
        listener: (context, state) {},
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomElevatedButton(
                      title: 'Logout',
                      onPressed: () {
                        authBloc.add(AuthLogoutButtonClickedEvent());
                      },
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 30,
                        width: 120,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: MyColors.secondaryColor,
                          ),
                        ),
                        child: Text(
                          'Saved',
                          style: MyFonts.firaSans(
                            fontColor: MyColors.secondaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: MyColors.secondaryColor,
                  thickness: 0.1,
                  height: 0.05,
                ),
              ],
            ),
          );
        },
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
