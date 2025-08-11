import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/post/post_bloc.dart';
import '../../../bloc/post/post_state.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/naviagtion_visivbility_cubit.dart';
import '../../widgets/post_tile.dart';
import '../../../core/utils/post_shimmer.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        if (!mounted) return false;

        // Get NavBarVisibilityCubit fresh from context every time
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
          const CustomFeedSliverAppBar(),
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
                if (state.posts.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('No posts yet')),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => PostTile(post: state.posts[index]),
                    childCount: state.posts.length,
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
