import 'package:connecthub/components/custom_app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/searched_user_tile.dart';
import '../../../auth/data/auth_repository.dart';
import '/components/loading.dart';
import '/constants/constants.dart';
import '../../../auth/domain/user_data_model.dart';
import '../../../profile/presentation/screens/other_users_profile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      appBar: customAppBar(title: 'Search'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            CustomTextField(
              hintText: 'Search by name',
              textController: _searchTextController,
              onChanged: (_) {
                setState(() {});
              },
            ),
            const SizedBox(height: 40),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return const Loading();
                }

                final userDocs = snapshots.data!.docs;
                if (userDocs.isEmpty) {
                  return Center(
                    child: Text(
                      'No users found',
                      style: MyFonts.bodyFont(
                        fontColor: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }
                final searchedUserDocs = _searchTextController.text.isEmpty
                    ? List.empty()
                    : userDocs
                        .where(
                          (user) => user['username']
                              .toString()
                              .toLowerCase()
                              .contains(
                                _searchTextController.text.trim().toLowerCase(),
                              ),
                        )
                        .toList();
                return Expanded(
                  child: ListView.builder(
                    itemCount: searchedUserDocs.length,
                    itemBuilder: (context, index) {
                      final userData = UserDataModel.fromJson(
                        searchedUserDocs[index].data(),
                      );
                      return SearchedUserTile(
                        userInfo: userData,
                        isFollowing: userData.followers.contains(
                          AuthRepository.currentUser!.uid,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtherUsersProfile(
                                userId: userData.uid,
                                showBackButton: true,
                              ),
                            ),
                          );
                          FocusManager.instance.primaryFocus!.unfocus();
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
