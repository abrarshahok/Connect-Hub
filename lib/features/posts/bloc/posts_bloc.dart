import 'dart:async';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '/repos/auth_repo.dart';
import '/repos/post_repo.dart';
part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc() : super(PostsInitial()) {
    on<PostChooseImageButtonClickedEvent>(postChooseImageButtonClickedEvent);
    on<PostImageChoosenSuccessEvent>(postImageChoosenSuccessEvent);
    on<PostUploadButtonClickedEvent>(postUploadButtonClickedEvent);
    on<PostLikeButtonClickedEvent>(postLikeButtonClickedEvent);
    on<PostSaveButtonClickedEvent>(postSaveButtonClickedEvent);
    on<PostNavigateToLikeScreenButtonClickedEvent>(
        postNavigateToLikeScreenButtonClickedEvent);
    on<PostNavigateToCommentScreenButtonClickedEvent>(
        postNavigateToCommentScreenButtonClickedEvent);
    on<PostAddCommentButtonClickedEvent>(postAddCommentButtonClickedEvent);
  }

  FutureOr<void> postChooseImageButtonClickedEvent(
    PostChooseImageButtonClickedEvent event,
    Emitter<PostsState> emit,
  ) {
    emit(PostChooseUploadOptionActionState(
      isChangingImage: event.isChagingImage,
    ));
  }

  FutureOr<void> postImageChoosenSuccessEvent(
    PostImageChoosenSuccessEvent event,
    Emitter<PostsState> emit,
  ) {
    emit(PostChoosenSuccessActionState(choosenImage: event.pickedImage));
  }

  FutureOr<void> postUploadButtonClickedEvent(
    PostUploadButtonClickedEvent event,
    Emitter<PostsState> emit,
  ) async {
    emit(PostUploadingActionState());
    bool isUploadingSuccess = await PostRepo.uploadPost(
      postId: const Uuid().v1(),
      userId: AuthRepo.currentUser!.uid,
      username: AuthRepo.currentUser!.username,
      caption: event.caption,
      postImage: event.image,
      postedOn: DateTime.now(),
      userImage: AuthRepo.currentUser!.userImage,
      likes: [],
    );
    if (isUploadingSuccess) {
      emit(PostUploadSuccessActionState());
    } else {
      emit(PostUploadFailedActionState());
    }
  }

  FutureOr<void> postLikeButtonClickedEvent(
    PostLikeButtonClickedEvent event,
    Emitter<PostsState> emit,
  ) async {
    final isLikedOrDisliked = await PostRepo.likeOrDislikePost(
      likes: event.likes,
      postId: event.postId,
    );
    if (!isLikedOrDisliked) {
      emit(PostLikingFailedActionState());
    }
  }

  FutureOr<void> postSaveButtonClickedEvent(
    PostSaveButtonClickedEvent event,
    Emitter<PostsState> emit,
  ) async {
    final checkIsSaved = await PostRepo.saveOrUnsavePost(event.postId);
    if (checkIsSaved == 'saved') {
      emit(PostSavedActionState());
    } else if (checkIsSaved == 'unsaved') {
      emit(PostUnSavedActionState());
    } else {
      emit(PostSavingFailedActionState());
    }
  }

  FutureOr<void> postNavigateToLikeScreenButtonClickedEvent(
    PostNavigateToLikeScreenButtonClickedEvent event,
    Emitter<PostsState> emit,
  ) {
    emit(PostNavigateToLikesScreenActionState());
  }

  FutureOr<void> postNavigateToCommentScreenButtonClickedEvent(
    PostNavigateToCommentScreenButtonClickedEvent event,
    Emitter<PostsState> emit,
  ) {
    emit(PostNavigateToCommentsScreenActionState());
  }

  FutureOr<void> postAddCommentButtonClickedEvent(
    PostAddCommentButtonClickedEvent event,
    Emitter<PostsState> emit,
  ) async {
    bool isCommentSent = await PostRepo.addComment(
      postId: event.postId,
      comment: event.comment,
    );
    if (isCommentSent) {
      print('Comment Sent');
    } else {
      print('Comment Sending failed');
    }
  }
}
