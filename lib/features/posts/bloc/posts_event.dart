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
  PostLikeButtonClickedEvent({required this.postId, required this.likes});
}

class PostSaveButtonClickedEvent extends PostsEvent {
  final PostDataModel clickedPost;
  PostSaveButtonClickedEvent(this.clickedPost);
}

class PostNavigateToLikeScreenButtonClicked extends PostsEvent {}
