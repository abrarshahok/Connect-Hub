part of 'posts_bloc.dart';

@immutable
abstract class PostsEvent {}

class PostChooseImageButtonClickedEvent extends PostsEvent {}

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
  final List<String> likes;
  PostLikeButtonClickedEvent({required this.postId, required this.likes});
}

class PostSaveButtonClickedEvent extends PostsEvent {
  final String postId;
  PostSaveButtonClickedEvent(this.postId);
}
