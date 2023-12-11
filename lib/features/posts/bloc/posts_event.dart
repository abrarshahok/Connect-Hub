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
