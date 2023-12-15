import 'dart:async';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '/repos/auth_repo.dart';
import '/repos/post_repo.dart';
import '/models/post_data_model.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc() : super(PostsInitial()) {
    on<PostChooseImageButtonClickedEvent>(postChooseImageButtonClickedEvent);
    on<PostImageChoosenSuccessEvent>(postImageChoosenSuccessEvent);
    on<PostUploadButtonClickedEvent>(postUploadButtonClickedEvent);
    on<PostLikeButtonClickedEvent>(postLikeButtonClickedEvent);
    on<PostSaveButtonClickedEvent>(postSaveButtonClickedEvent);
    on<PostNavigateToLikeScreenButtonClicked>(
        postNavigateToLikeScreenButtonClicked);
  }

  FutureOr<void> postChooseImageButtonClickedEvent(
    PostChooseImageButtonClickedEvent event,
    Emitter<PostsState> emit,
  ) {
    emit(PostChooseUploadOptionActionState());
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
      comments: [],
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
    final isSavedOrUnsaved = await PostRepo.saveOrUnsavePost(event.clickedPost);
    if (!isSavedOrUnsaved) {
      emit(PostSavingFailedActionState());
    }
  }

  FutureOr<void> postNavigateToLikeScreenButtonClicked(
    PostNavigateToLikeScreenButtonClicked event,
    Emitter<PostsState> emit,
  ) {
    emit(PostNavigateToLikesScreenActionState());
  }
}
