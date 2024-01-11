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

  factory UserDataModel.fromJson(Map<String, dynamic> json, String userId) =>
      UserDataModel(
        uid: userId,
        username: json['username'],
        email: json['email'],
        userImage: json['userImageUrl'],
        followers: json['followers'],
        following: json['following'],
      );
}
