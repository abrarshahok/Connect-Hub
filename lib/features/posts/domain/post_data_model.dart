class PostDataModel {
  final String postId;
  final String userId;
  final String username;
  final String userImage;
  final String caption;
  final String postUrl;
  final DateTime postedOn;
  final List<dynamic> likes;

  PostDataModel({
    required this.postId,
    required this.userId,
    required this.username,
    required this.userImage,
    required this.caption,
    required this.postUrl,
    required this.postedOn,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'username': username,
        'caption': caption,
        'userImage': userImage,
        'postImageUrl': postUrl,
        'postedOn': postedOn.toIso8601String(),
        'likes': likes,
      };

  factory PostDataModel.fromJson(Map<String, dynamic> json, String postId) =>
      PostDataModel(
        postId: postId,
        userId: json['userId'],
        username: json['username'],
        caption: json['caption'],
        postUrl: json['postImageUrl'],
        userImage: json['userImage'],
        postedOn: DateTime.parse(json['postedOn']),
        likes: List<String>.from(json['likes']),
      );
  PostDataModel copyWith({
    String? postId,
    String? userId,
    String? username,
    String? userImage,
    String? caption,
    String? postUrl,
    DateTime? postedOn,
    List<dynamic>? likes,
  }) {
    return PostDataModel(
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userImage: userImage ?? this.userImage,
      caption: caption ?? this.caption,
      postUrl: postUrl ?? this.postUrl,
      postedOn: postedOn ?? this.postedOn,
      likes: likes ?? this.likes,
    );
  }
}
