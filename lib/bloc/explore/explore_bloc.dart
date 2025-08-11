import 'package:bloc/bloc.dart';
import '../../repository/storage_repository.dart';
import 'explore_event.dart';
import 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final ExploreRepository repository;

  ExploreBloc(this.repository) : super(ExploreInitial()) {
    on<LoadExplorePosts>(_onLoadExplorePosts);
    on<SearchUsers>(_onSearchUsers);
  }

  Future<void> _onLoadExplorePosts(
      LoadExplorePosts event, Emitter<ExploreState> emit) async {
    emit(ExploreLoading());
    try {
      final posts = await repository.getExplorePosts();
      emit(ExplorePostsLoaded(posts));
    } catch (e) {
      emit(ExploreError(e.toString()));
    }
  }

  Future<void> _onSearchUsers(
      SearchUsers event, Emitter<ExploreState> emit) async {
    emit(ExploreLoading());
    try {
      final users = await repository.searchUsers(event.query);
      emit(ExploreUsersLoaded(users));
    } catch (e) {
      emit(ExploreError(e.toString()));
    }
  }
}
