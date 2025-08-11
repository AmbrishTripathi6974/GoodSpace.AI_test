import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_space_test/services/like_storage_service.dart';
import '../../model/post_model.dart';
import '../../repository/post_repository.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;

  PostBloc({required this.postRepository}) : super(PostLoading()) {
    // Load posts with likes (repo returns likes populated)
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

      // optimistic UI update (toggle userId in likes list)
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
        // local persistence for fast restart UX
        await LikePersistenceService.toggleLike(event.post.postId);

        // sync to Firestore subcollection using explicit userId from event
        await postRepository.toggleLikeInSubcollection(
          postId: event.post.postId,
          userId: event.currentUserId,
        );
      } catch (e) {
        // rollback on failure
        emit(currentState);
      }
    });
  }
}
