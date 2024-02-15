import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/features/chat/presentation/screens/messages_screen.dart';
import '/service_locator/service_locator.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../auth/domain/user_data_model.dart';
import '../../../auth/data/auth_repository.dart';
import '/constants/constants.dart';

class UserTile extends StatelessWidget {
  UserTile({super.key, required this.userInfo});
  final UserDataModel userInfo;
  final profileBloc = ServiceLocator.instance.get<ProfileBloc>();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          MessagesScreen.routeName,
          arguments: {
            'currentUserId': AuthRepository.currentUser!.uid,
            'friendUserId': userInfo.uid,
            'userName': userInfo.username,
          },
        );
      },
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(
          userInfo.userImage,
        ),
      ),
      title: Text(
        userInfo.uid == AuthRepository.currentUser!.uid
            ? 'You'
            : userInfo.username,
        style: MyFonts.bodyFont(
          fontColor: MyColors.secondaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        userInfo.online ? 'online' : 'offline',
        style: MyFonts.bodyFont(
          fontColor:
              userInfo.online ? MyColors.onlineColor : MyColors.secondaryColor,
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
      ),
    );
  }
}
