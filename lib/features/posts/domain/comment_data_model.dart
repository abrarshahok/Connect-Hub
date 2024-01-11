class CommentDataModel {
  final String userId;
  final String username;
  final String userImageUrl;
  final String comment;
  final String commentId;
  final DateTime commentedOn;

  CommentDataModel({
    required this.userId,
    required this.username,
    required this.userImageUrl,
    required this.comment,
    required this.commentId,
    required this.commentedOn,
  });

  factory CommentDataModel.fromJson(Map<String, dynamic> json) {
    return CommentDataModel(
      userId: json['userId'],
      username: json['username'],
      userImageUrl: json['userImageUrl'],
      comment: json['comment'],
      commentId: json['commentId'],
      commentedOn: DateTime.parse(json['commentedOn']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'userImageUrl': userImageUrl,
      'comment': comment,
      'commentId': commentId,
      'commentedOn': commentedOn,
    };
  }
}
