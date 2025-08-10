import '../../model/post_model.dart';

abstract class PostEvent {}

class LoadPostsEvent extends PostEvent {}

class ToggleLikeEvent extends PostEvent {
  final PostModel post;
  final String currentUserId;

  ToggleLikeEvent({required this.post, required this.currentUserId});
}