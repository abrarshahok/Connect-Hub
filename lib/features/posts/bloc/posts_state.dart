part of 'posts_bloc.dart';

@immutable
abstract class PostsState {}

class PostsActionState extends PostsState {}

class PostsInitial extends PostsState {}

class PostChoosenSuccessState extends PostsState {
  final File choosenImage;

  PostChoosenSuccessState({required this.choosenImage});
}

class PostUploadingState extends PostsState {}

class PostUploadSuccessState extends PostsState {}

class PostUploadErrorState extends PostsState {}

class PostChooseUploadOptionActionState extends PostsActionState {}
