part of 'posts_bloc.dart';

@immutable
abstract class PostsEvent {}

class PostChooseImageButtonClickedEvent extends PostsEvent {}

class PostImageChoosenSuccessEvent extends PostsEvent {
  final File pickedImage;

  PostImageChoosenSuccessEvent({required this.pickedImage});
}
