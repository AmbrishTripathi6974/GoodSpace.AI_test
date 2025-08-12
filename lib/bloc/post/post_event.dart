import '../../model/post_model.dart';

abstract class PostEvent {}

class LoadPostsEvent extends PostEvent {}

class ToggleLikeEvent extends PostEvent {
  final PostModel post;
  final String currentUserId;

  ToggleLikeEvent({required this.post, required this.currentUserId});
}

class DeletePostEvent extends PostEvent {
  final String postId;

  DeletePostEvent({required this.postId});
}
