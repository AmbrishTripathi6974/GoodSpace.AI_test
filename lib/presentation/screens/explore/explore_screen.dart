import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../bloc/explore/explore_bloc.dart';
import '../../../bloc/explore/explore_event.dart';
import '../../../bloc/explore/explore_state.dart';
import '../../../core/utils/cached_image.dart';
import '../../../repository/storage_repository.dart';
import '../profile/profile_screen.dart';

class ExploreScreen extends StatelessWidget {
  ExploreScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExploreBloc(ExploreRepository())..add(LoadExplorePosts()),
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              _searchBox(),
              BlocBuilder<ExploreBloc, ExploreState>(
                builder: (context, state) {
                  if (state is ExploreLoading) {
                    return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is ExplorePostsLoaded) {
                    return _postsGrid(state.posts);
                  } else if (state is ExploreUsersLoaded) {
                    return _userList(state.users);
                  } else if (state is ExploreError) {
                    return SliverToBoxAdapter(
                      child: Center(child: Text(state.message)),
                    );
                  }
                  return const SliverToBoxAdapter();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _searchBox() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Builder(
          builder: (context) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle:
                      TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (value) {
                  if (value.isEmpty) {
                    context.read<ExploreBloc>().add(LoadExplorePosts());
                  } else {
                    context.read<ExploreBloc>().add(SearchUsers(value));
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _postsGrid(List posts) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final snap = posts[index];
          final imageUrl = snap['postImage'] ?? "";

          return GestureDetector(
            onTap: () {},
            child: CachedImage(
              imageUrl: imageUrl,
              useLowResForFeed: true,
            ),
          );
        },
        childCount: posts.length,
      ),
      gridDelegate: SliverQuiltedGridDelegate(
        crossAxisCount: 3,
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
        pattern: const [
          QuiltedGridTile(2, 1),
          QuiltedGridTile(2, 2),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
        ],
      ),
    );
  }

  Widget _userList(List users) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final snap = users[index];
          final profileUrl = snap['profile'] ?? "";

          return ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  profileUrl.isNotEmpty ? NetworkImage(profileUrl) : null,
              child: profileUrl.isEmpty ? const Icon(Icons.person) : null,
            ),
            title: Text(snap['username'] ?? ""),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(fromExplore: true),
                ),
              );
            },
          );
        },
        childCount: users.length,
      ),
    );
  }
}
