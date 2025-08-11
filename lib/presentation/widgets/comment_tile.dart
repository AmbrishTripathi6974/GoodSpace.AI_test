import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/comment/comment_cubit.dart';
import '../../bloc/comment/comment_state.dart';
import '../../core/utils/cached_image.dart';

class CommentScreen extends StatelessWidget {
  final String type;
  final String postId;
  final TextEditingController _controller = TextEditingController();

  CommentScreen({super.key, required this.type, required this.postId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => CommentCubit(
        firestore: FirebaseFirestore.instance,
        auth: FirebaseAuth.instance,
      )..loadComments(type, postId),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: Container(
          color: theme.scaffoldBackgroundColor,
          height: 400, // increased height
          child: Stack(
            children: [
              Positioned(
                top: 8,
                left: 140,
                child: Container(
                  width: 100,
                  height: 3,
                  color: theme.colorScheme.onBackground.withOpacity(0.4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 80),
                child: BlocBuilder<CommentCubit, CommentState>(
                  builder: (context, state) {
                    if (state is CommentLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is CommentLoaded ||
                        state is CommentSending) {
                      final comments = state is CommentLoaded
                          ? state.comments
                          : (state as CommentSending).comments;
                      return ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final data = comments[index].data();
                          return _commentItem(data, theme);
                        },
                      );
                    } else if (state is CommentError) {
                      return Center(
                        child: Text(state.message,
                            style: theme.textTheme.bodyLarge),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              Positioned(
                bottom: 40,
                right: 5,
                left: 5,
                child: Container(
                  height: 42,
                  color: theme.scaffoldBackgroundColor,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black87,
                              width: 0.2,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: TextField(
                            controller: _controller,
                            maxLines: 4,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Add a comment...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      BlocBuilder<CommentCubit, CommentState>(
                        builder: (context, state) {
                          final isSending = state is CommentSending;
                          return GestureDetector(
                            onTap: isSending
                                ? null
                                : () {
                                    if (_controller.text.trim().isNotEmpty) {
                                      context.read<CommentCubit>().sendComment(
                                            type: type,
                                            postId: postId,
                                            comment: _controller.text.trim(),
                                          );
                                      _controller.clear();
                                    }
                                  },
                            child: isSending
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : Icon(Icons.send,
                                    color: theme.colorScheme.primary),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _commentItem(Map<String, dynamic> data, ThemeData theme) {
    return ListTile(
      leading: ClipOval(
        child: SizedBox(
          height: 35,
          width: 35,
          child: CachedImage(imageUrl: data['profileImage']),
        ),
      ),
      title: Text(
        data['username'],
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        data['comment'],
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 14,
        ),
      ),
    );
  }
}
