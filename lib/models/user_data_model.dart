class UserDataModel {
  final String uid;
  final String username;
  final String email;
  final String userImage;

  UserDataModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.userImage,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'email': email,
        'userImage': userImage,
      };

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
        uid: json['uid'],
        username: json['username'],
        email: json['email'],
        userImage: json['userImage'],
      );
}
