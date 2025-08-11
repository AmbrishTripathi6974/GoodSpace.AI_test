import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/post/post_bloc.dart';
import '../../../bloc/post/post_state.dart';
import '../../../core/utils/post_shimmer.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/naviagtion_visivbility_cubit.dart';
import '../../widgets/post_tile.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.axisDirection != AxisDirection.down &&
            notification.metrics.axisDirection != AxisDirection.up) {
          return false;
        }

        final navBarCubit = context.read<NavBarVisibilityCubit>();

        if (notification.direction == ScrollDirection.reverse) {
          navBarCubit.hide();
        } else if (notification.direction == ScrollDirection.forward) {
          navBarCubit.show();
        }
        return true;
      },
      child: CustomScrollView(
        slivers: [
          // Header
          const CustomFeedSliverAppBar(),

          // Feed content
          BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              if (state is PostLoading) {
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
                    child: Center(child: Text('No posts yet')),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => PostTile(post: posts[index]),
                    childCount: posts.length,
                  ),
                );
              } else if (state is PostError) {
                return SliverFillRemaining(
                  child: Center(child: Text('Error: ${state.message}')),
                );
              }
              return const SliverFillRemaining(
                child: Center(child: Text('Something went wrong')),
              );
            },
          ),
        ],
      ),
    );
  }
}
