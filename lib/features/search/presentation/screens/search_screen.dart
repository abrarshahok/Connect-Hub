import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/search_text_field.dart';
import '../widgets/searched_user_tile.dart';
import '../../../auth/repository/auth_repository.dart';
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
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const SizedBox(height: 10),
          SearchTextField(
            searchController: _searchTextController,
            onChanged: (_) {
              setState(() {});
            },
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
                        searchedUserDocs[index].id);
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
    );
  }
}
