part of 'posts_bloc.dart';

@immutable
abstract class PostsEvent {}

class PostChooseImageButtonClickedEvent extends PostsEvent {
  final bool isChagingImage;
  PostChooseImageButtonClickedEvent({this.isChagingImage = false});
}

class PostImageChoosenSuccessEvent extends PostsEvent {
  final File pickedImage;
  PostImageChoosenSuccessEvent({required this.pickedImage});
}

class PostUploadButtonClickedEvent extends PostsEvent {
  final String caption;
  final File image;
  PostUploadButtonClickedEvent({required this.caption, required this.image});
}

class PostLikeButtonClickedEvent extends PostsEvent {
  final String postId;

  final List<dynamic> likes;
  PostLikeButtonClickedEvent({
    required this.postId,
    required this.likes,
  });
}

class PostAddCommentButtonClickedEvent extends PostsEvent {
  final String postId;
  final String comment;
  PostAddCommentButtonClickedEvent({
    required this.postId,
    required this.comment,
  });
}

class PostSaveButtonClickedEvent extends PostsEvent {
  final String postId;
  PostSaveButtonClickedEvent(this.postId);
}

class PostNavigateToCommentScreenButtonClickedEvent extends PostsEvent {
  final String postId;
  PostNavigateToCommentScreenButtonClickedEvent(this.postId);
}

class PostNavigateToLikeScreenButtonClickedEvent extends PostsEvent {}
