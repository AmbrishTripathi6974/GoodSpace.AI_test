import '../../model/post_model.dart';

abstract class PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<PostModel> posts;

  PostLoaded(this.posts);
}
class PostOperationSuccess extends PostState {
  final String message;
  PostOperationSuccess(this.message);
}

class PostError extends PostState {
  final String message;

  PostError(this.message);
}
