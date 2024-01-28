// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserDataModel {
  final String uid;
  final String username;
  final String email;
  final String userImage;
  final List<dynamic> followers;
  final List<dynamic> following;

  UserDataModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.userImage,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'email': email,
        'userImage': userImage,
        'followers': followers,
        'following': following,
      };

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
        uid: json['uid'],
        username: json['username'],
        email: json['email'],
        userImage: json['userImage'],
        followers: json['followers'],
        following: json['following'],
      );

  UserDataModel copyWith({
    String? uid,
    String? username,
    String? email,
    String? userImage,
    List<dynamic>? followers,
    List<dynamic>? following,
  }) {
    return UserDataModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      userImage: userImage ?? this.userImage,
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }
}
