part of 'posts_bloc.dart';

@immutable
abstract class PostsState {}

class PostsActionState extends PostsState {}

class PostsInitial extends PostsState {}

class PostShowAllPostOptionsState extends PostsState {}

class PostHideAllPostOptionsState extends PostsState {}

class PostShowAllCommentOptionsState extends PostsState {}

class PostHideAllCommentOptionsState extends PostsState {}

class PostChoosenSuccessActionState extends PostsActionState {
  final File choosenImage;

  PostChoosenSuccessActionState({required this.choosenImage});
}

class PostUploadSuccessActionState extends PostsActionState {}

class PostUploadFailedActionState extends PostsActionState {}

class PostUploadingActionState extends PostsActionState {}

class PostChooseUploadOptionActionState extends PostsActionState {
  final bool isChangingImage;
  PostChooseUploadOptionActionState({this.isChangingImage = false});
}

class PostLikingFailedActionState extends PostsActionState {}

class PostSavingFailedActionState extends PostsActionState {}

class PostNavigateToLikesScreenActionState extends PostsActionState {}

class PostNavigateToCommentsScreenActionState extends PostsActionState {}

class PostSavedActionState extends PostsActionState {}

class PostUnSavedActionState extends PostsActionState {}

class PostEditPostActionState extends PostsActionState {}

class PostDeleteActionState extends PostsActionState {}

class PostDeleteSuccessActionState extends PostsActionState {}
