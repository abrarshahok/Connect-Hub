part of 'posts_bloc.dart';

@immutable
abstract class PostsState {}

class PostsActionState extends PostsState {}

class PostsInitial extends PostsState {}

class PostChoosenSuccessState extends PostsState {
  final File choosenImage;

  PostChoosenSuccessState({required this.choosenImage});
}

class PostUploadSuccessActionState extends PostsActionState {}

class PostUploadFailedActionState extends PostsActionState {}

class PostUploadingActionState extends PostsActionState {}

class PostChooseUploadOptionActionState extends PostsActionState {}

class PostLikingFailedActionState extends PostsActionState {}

class PostSavingFailedActionState extends PostsActionState {}
