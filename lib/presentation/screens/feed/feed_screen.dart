import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/post/post_bloc.dart';
import '../../../bloc/post/post_state.dart';
import '../../../core/utils/post_shimmer.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/post_tile.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom Header
          const CustomFeedSliverAppBar(),

          // Feed List
          BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              if (state is PostLoading) {
                // Show shimmer placeholders while loading
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => const PostTileShimmer(),
                    childCount: 5,
                  ),
                );
              } else if (state is PostLoaded) {
                final posts = state.posts;
                if (posts.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text('No posts yet'),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = posts[index];
                      return PostTile(post: post);
                    },
                    childCount: posts.length,
                  ),
                );
              } else if (state is PostError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text('Error: ${state.message}'),
                  ),
                );
              }

              // Default fallback UI
              return const SliverFillRemaining(
                child: Center(
                  child: Text('Something went wrong'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
