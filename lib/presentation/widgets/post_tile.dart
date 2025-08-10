import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/post/post_bloc.dart';
import '../../bloc/post/post_event.dart';
import '../../core/utils/cached_image.dart';
import '../../model/post_model.dart';

class PostTile extends StatelessWidget {
  final PostModel post;
  const PostTile({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          // Post Header
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ListTile(
              leading: ClipOval(
                child: SizedBox(
                  width: 35,
                  height: 35,
                  child: CachedImage(
                    imageUrl: post.profileImage,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(100),
                    useLowResForFeed: true,
                    height: 35,
                    width: 35,
                  ),
                ),
              ),
              title: Text(
                post.username,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(Icons.more_horiz),
            ),
          ),

          // Post Image
          SizedBox(
            height: screenHeight * 0.4,
            width: double.infinity,
            child: CachedImage(
              imageUrl: post.postImage,
              fit: BoxFit.cover,
              useLowResForFeed: true,
              height: screenHeight * 0.4,
              width: double.infinity,
            ),
          ),

          // Action Buttons
          Container(
            color: theme.scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 20, top: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      post.likes.contains(post.uid)
                          ? Icons.favorite
                          : Icons.favorite_outline_rounded,
                      color: post.likes.contains(post.uid) ? Colors.red : null,
                      size: 25,
                    ),
                    onPressed: () {
                      final postBloc = context.read<PostBloc>();
                      postBloc.add(
                        ToggleLikeEvent(
                          post: post,
                          currentUserId: post.uid,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 15),
                  Image.asset('assets/images/comment.png', height: 28),
                  const SizedBox(width: 15),
                  Image.asset('assets/images/send.jpg', height: 28),
                  const Spacer(),
                  Image.asset('assets/images/save.png', height: 28),
                ],
              ),
            ),
          ),

          // Likes Text
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(text: 'Liked by '),
                    TextSpan(
                      text: post.username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: '${post.likes.length} others',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
