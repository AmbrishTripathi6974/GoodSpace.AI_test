import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_space_test/core/utils/cached_image.dart';

import '../../../bloc/profile/profile_bloc.dart';
import '../../../bloc/profile/profile_event.dart';
import '../../../bloc/profile/profile_state.dart';
import '../../../services/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  final bool fromExplore;
  final String? userId; // Optional userId for other profiles

  const ProfileScreen({super.key, this.fromExplore = false, this.userId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => ProfileBloc(authService: AuthenticationService())
        ..add(LoadProfileEvent(userId: userId)),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is ProfileError) {
            return Scaffold(
              body: Center(child: Text(state.message)),
            );
          } else if (state is ProfileLoaded) {
            final user = state.user;
            final currentUserId =
                AuthenticationService().getCurrentUser();

            return DefaultTabController(
              length: 3,
              child: Scaffold(
                backgroundColor: Colors.grey.shade100,
                body: SafeArea(
                  child: Stack(
                    children: [
                      CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Container(
                              padding: const EdgeInsets.only(bottom: 5),
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Profile header
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 13, top: 10, bottom: 10, right: 6),
                                        child: ClipOval(
                                          child: SizedBox(
                                            width: 80,
                                            height: 80,
                                            child: CachedImage(
                                              imageUrl: user.profile,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Live post count
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('posts')
                                            .where('uid', isEqualTo: user.uid)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          final postCount = snapshot.hasData
                                              ? snapshot.data!.docs.length
                                              : 0;

                                          return Column(
                                            children: [
                                              Row(
                                                children: [
                                                  const SizedBox(width: 15),
                                                  _buildCountWidget(postCount, theme),
                                                  const SizedBox(width: 70),
                                                  _buildCountWidget(user.followers.length, theme),
                                                  const SizedBox(width: 80),
                                                  _buildCountWidget(user.following.length, theme),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const SizedBox(width: 40),
                                                  _buildLabel('Posts', theme),
                                                  const SizedBox(width: 35),
                                                  _buildLabel('Followers', theme),
                                                  const SizedBox(width: 35),
                                                  _buildLabel('Following', theme),
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),

                                  // Name & Bio
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.username,
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          user.bio,
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Show Edit Profile button only if viewing own profile
                                  if (user.uid == currentUserId)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(color: Colors.grey.shade400),
                                        ),
                                        child: Text(
                                          'Edit your profile',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 12),

                                  // Tab bar
                                  const SizedBox(
                                    width: double.infinity,
                                    height: 30,
                                    child: TabBar(
                                      unselectedLabelColor: Colors.grey,
                                      labelColor: Colors.black,
                                      indicator: UnderlineTabIndicator(
                                        borderSide: BorderSide(width: 3.0, color: Colors.black),
                                        insets: EdgeInsets.symmetric(horizontal: 60.0),
                                      ),
                                      tabs: [
                                        Icon(Icons.grid_on),
                                        Icon(Icons.video_collection),
                                        Icon(Icons.person),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Tab views
                          SliverFillRemaining(
                            child: TabBarView(
                              children: [
                                _buildPostsGrid(user.uid),
                                const Center(child: Text("Reels Placeholder")),
                                const Center(child: Text("Tagged Placeholder")),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Close button (only from explore)
                      if (fromExplore)
                        Positioned(
                          top: 10,
                          right: 10,
                          child: IconButton(
                            icon: const Icon(Icons.clear, size: 28),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCountWidget(dynamic count, ThemeData theme) {
    return Text(
      '$count',
      style: theme.textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget _buildLabel(String text, ThemeData theme) {
    return Text(
      text,
      style: theme.textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  Widget _buildPostsGrid(String uid) {
    List<QueryDocumentSnapshot>? _cachedPosts;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            _cachedPosts == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;
          if (docs.isNotEmpty) {
            _cachedPosts = docs;
          }
        }

        if ((_cachedPosts == null || _cachedPosts!.isEmpty) &&
            (!snapshot.hasData || snapshot.data!.docs.isEmpty)) {
          return const Center(child: Text("No posts yet"));
        }

        final posts = _cachedPosts ?? [];

        return GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index].data() as Map<String, dynamic>;
            return CachedImage(
              imageUrl: post['postImage'] ?? '',
            );
          },
        );
      },
    );
  }
}
