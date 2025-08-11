import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../bloc/post/post_bloc.dart';
import '../../bloc/post/post_event.dart';
import '../../core/utils/cached_image.dart';
import '../../model/post_model.dart';
import 'comment_tile.dart';
import 'heat_overlay_animation.dart';
import 'read_more_text.dart';

class PostTile extends StatefulWidget {
  final PostModel post;
  const PostTile({super.key, required this.post});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  late ValueNotifier<bool> isExpandedNotifier;
  late ValueNotifier<bool> showHeartOverlay;
  late String? currentUserId;

  @override
  void initState() {
    super.initState();
    isExpandedNotifier = ValueNotifier(false);
    showHeartOverlay = ValueNotifier(false);
    currentUserId = FirebaseAuth.instance.currentUser?.uid;
  }

  void _triggerLike(BuildContext context, {bool forceLike = false}) {
    if (currentUserId == null) return;
    final alreadyLiked = widget.post.likes.contains(currentUserId);

    if (forceLike && !alreadyLiked) {
      showHeartOverlay.value = true;
      Future.delayed(const Duration(milliseconds: 700), () {
        showHeartOverlay.value = false;
      });
    }

    context.read<PostBloc>().add(
          ToggleLikeEvent(
            post: widget.post,
            currentUserId: currentUserId!,
          ),
        );
  }

  @override
  void dispose() {
    isExpandedNotifier.dispose();
    showHeartOverlay.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Material(
      color: Colors.white, // match your container color
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 1),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            ListTile(
              leading: ClipOval(
                child: CachedImage(
                  imageUrl: widget.post.profileImage,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(100),
                  useLowResForFeed: true,
                  height: 35,
                  width: 35,
                ),
              ),
              title: Text(
                widget.post.username,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(Icons.more_horiz),
            ),

            // Image
            GestureDetector(
              onDoubleTap: () => _triggerLike(context, forceLike: true),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CachedImage(
                    imageUrl: widget.post.postImage,
                    fit: BoxFit.cover,
                    useLowResForFeed: true,
                    height: screenHeight * 0.4,
                    width: double.infinity,
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: showHeartOverlay,
                    builder: (_, isVisible, __) =>
                        HeartOverlayAnimation(isVisible: isVisible),
                  ),
                ],
              ),
            ),

            // Actions
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 20),
              child: Row(
                children: [
                  BlocBuilder<PostBloc, dynamic>(
                    builder: (context, state) {
                      final liked = widget.post.likes.contains(currentUserId);
                      return IconButton(
                        icon: Icon(
                          liked
                              ? Icons.favorite
                              : Icons.favorite_outline_rounded,
                          color: liked ? Colors.red : null,
                          size: 25,
                        ),
                        onPressed: () => _triggerLike(context),
                      );
                    },
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => CommentScreen(
                          type: 'posts',
                          postId: widget.post.postId,
                        ),
                      );
                    },
                    child: Image.asset('assets/images/comment.png', height: 28),
                  ),
                  const SizedBox(width: 15),
                  Image.asset('assets/images/send.jpg', height: 28),
                  const Spacer(),
                  Image.asset('assets/images/save.png', height: 28),
                ],
              ),
            ),

            // Likes count
            Padding(
              padding: const EdgeInsets.only(left: 18, bottom: 8),
              child: RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(text: 'Liked by '),
                    TextSpan(
                      text: widget.post.username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: '${widget.post.likes.length} others',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            // Caption
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ValueListenableBuilder<bool>(
                valueListenable: isExpandedNotifier,
                builder: (context, isExpanded, _) {
                  return ReadMoreText(
                    username: widget.post.username,
                    caption: widget.post.caption,
                    trimLength: 100,
                    isExpanded: isExpanded,
                    onTapReadMore: () {
                      isExpandedNotifier.value = !isExpandedNotifier.value;
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
