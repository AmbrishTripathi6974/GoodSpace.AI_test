import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/comment/comment_cubit.dart';
import '../../bloc/comment/comment_state.dart';
import '../../core/utils/cached_image.dart';
import 'read_more_text.dart';

class CommentScreen extends StatefulWidget {
  final String type;
  final String postId;

  const CommentScreen({super.key, required this.type, required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _controller = TextEditingController();

  /// Track expanded state per comment by comment ID or index
  final Set<int> _expandedIndexes = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => CommentCubit(
        firestore: FirebaseFirestore.instance,
        auth: FirebaseAuth.instance,
      )..loadComments(widget.type, widget.postId),
      child: SafeArea(
        child: AnimatedPadding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            child: Container(
              color: theme.scaffoldBackgroundColor,
              height: 450,
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
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is CommentLoaded ||
                            state is CommentSending) {
                          final comments = state is CommentLoaded
                              ? state.comments
                              : (state as CommentSending).comments;
                          return ListView.builder(
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final data = comments[index].data();

                              // Check if this comment is expanded
                              final isExpanded =
                                  _expandedIndexes.contains(index);

                              return _commentItem(
                                  data, theme, index, isExpanded);
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
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
                                        if (_controller.text
                                            .trim()
                                            .isNotEmpty) {
                                          context
                                              .read<CommentCubit>()
                                              .sendComment(
                                                type: widget.type,
                                                postId: widget.postId,
                                                comment:
                                                    _controller.text.trim(),
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
        ),
      ),
    );
  }

  Widget _commentItem(
      Map<String, dynamic> data, ThemeData theme, int index, bool isExpanded) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: SizedBox(
                  height: 32,
                  width: 32,
                  child: CachedImage(imageUrl: data['profileImage']),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                data['username'],
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(
                left:
                    45), // align comment start with username text, leaving profile space
            child: ReadMoreText(
              username: '', // keep empty because username is shown above
              caption: data['comment'] ?? '',
              isExpanded: isExpanded,
              onTapReadMore: () {
                setState(() {
                  if (_expandedIndexes.contains(index)) {
                    _expandedIndexes.remove(index);
                  } else {
                    _expandedIndexes.add(index);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
