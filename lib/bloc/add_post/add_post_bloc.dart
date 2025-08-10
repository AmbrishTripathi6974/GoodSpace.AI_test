import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/post_repository.dart';
import 'add_post_event.dart';
import 'add_post_state.dart';

class AddPostBloc extends Bloc<AddPostEvent, AddPostState> {
  final PostRepository postRepository;

  AddPostBloc({required this.postRepository}) : super(AddPostInitial()) {
    on<AddPostSubmitted>(_onAddPostSubmitted);
  }

  Future<void> _onAddPostSubmitted(
    AddPostSubmitted event,
    Emitter<AddPostState> emit,
  ) async {
    emit(AddPostLoading());
    try {
      await postRepository.createPost(
        image: event.image,
        caption: event.caption,
      );
      emit(AddPostSuccess());
    } catch (e) {
      emit(AddPostFailure(e.toString()));
    }
  }
}
