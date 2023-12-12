class PostDataModel {
  final String postId;
  final String userId;
  final String username;
  final String userImage;
  final String caption;
  final String postUrl;
  final DateTime postedOn;
  final List<String> likes;
  final List<String> comments;

  PostDataModel({
    required this.postId,
    required this.userId,
    required this.username,
    required this.userImage,
    required this.caption,
    required this.postUrl,
    required this.postedOn,
    required this.likes,
    required this.comments,
  });

  Map<String, dynamic> toJson() => {
        'postId': postId,
        'userId': userId,
        'username': username,
        'caption': caption,
        'userImage': userImage,
        'postUrl': postUrl,
        'postedOn': postedOn.toIso8601String(),
        'likes': likes,
        'comments': comments,
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
        comments: List<String>.from(json['comments']),
      );
}
