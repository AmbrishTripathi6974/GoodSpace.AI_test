import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/post_model.dart';
import '../../repository/post_repository.dart';
import 'post_event.dart';
import 'post_state.dart';


class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;
  Stream<List<PostModel>>? _postStream;

  PostBloc({required this.postRepository}) : super(PostLoading()) {
    on<LoadPostsEvent>((event, emit) async {
      emit(PostLoading());
      try {
        _postStream = postRepository.getPostsStream();
        await emit.forEach<List<PostModel>>(
          _postStream!,
          onData: (posts) => PostLoaded(posts),
          onError: (error, _) => PostError(error.toString()),
        );
      } catch (e) {
        emit(PostError(e.toString()));
      }
    });

    on<ToggleLikeEvent>((event, emit) async {
      try {
        await postRepository.toggleLike(
          postId: event.post.postId,
          uid: event.currentUserId,
          currentLikes: event.post.likes,
        );
      } catch (e) {
        // Optional: handle error if needed
      }
    });
  }

  @override
  Future<void> close() {
    // Clean up if needed
    return super.close();
  }
}
