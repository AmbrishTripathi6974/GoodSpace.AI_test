import 'package:flutter/material.dart';
import 'package:good_space_test/presentation/widgets/post_tile.dart';
import '../../widgets/custom_header.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomFeedSliverAppBar(),

          // Example content to scroll
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 5,
              (context, index) {
                return PostTile();
              },
            ),
          ),
        ],
      ),
    );
  }
}
