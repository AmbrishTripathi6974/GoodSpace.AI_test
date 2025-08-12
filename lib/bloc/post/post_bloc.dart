import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_space_test/services/like_storage_service.dart';
import '../../model/post_model.dart';
import '../../repository/post_repository.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;

  PostBloc({required this.postRepository}) : super(PostLoading()) {
    // Load posts with likes
    on<LoadPostsEvent>((event, emit) async {
      emit(PostLoading());
      try {
        final postStream = postRepository.getPostsStreamWithLikes();
        await emit.forEach<List<PostModel>>(
          postStream,
          onData: (posts) => PostLoaded(posts),
          onError: (error, _) => PostError(error.toString()),
        );
      } catch (e) {
        emit(PostError(e.toString()));
      }
    });

    // Toggle like
    on<ToggleLikeEvent>((event, emit) async {
      if (state is! PostLoaded) return;
      final currentState = state as PostLoaded;

      // optimistic UI update
      final updatedPosts = currentState.posts.map((post) {
        if (post.postId == event.post.postId) {
          final updatedLikes = List<String>.from(post.likes);
          if (updatedLikes.contains(event.currentUserId)) {
            updatedLikes.remove(event.currentUserId);
          } else {
            updatedLikes.add(event.currentUserId);
          }
          return post.copyWith(likes: updatedLikes);
        }
        return post;
      }).toList();

      emit(PostLoaded(updatedPosts));

      try {
        await LikePersistenceService.toggleLike(event.post.postId);

        await postRepository.toggleLikeInSubcollection(
          postId: event.post.postId,
          userId: event.currentUserId,
        );
      } catch (e) {
        emit(currentState);
      }
    });

    // Delete post event handling
    // inside PostBloc constructor, DeletePostEvent handler
    on<DeletePostEvent>((event, emit) async {
      if (state is! PostLoaded) return;
      final currentState = state as PostLoaded;

      try {
        emit(PostLoading());

        await postRepository.deletePost(event.postId);

        final updatedPosts =
            currentState.posts.where((p) => p.postId != event.postId).toList();

        emit(PostLoaded(updatedPosts));

        // Emit a short-lived operation-success state
        emit(PostOperationSuccess('Post deleted'));
        // Optionally, re-emit PostLoaded(updatedPosts) if you want subscriber lists to remain consistent
        emit(PostLoaded(updatedPosts));
      } catch (e) {
        emit(PostError('Failed to delete post: ${e.toString()}'));
        // revert
        emit(currentState);
      }
    });
  }
}
