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
          //Custom Header
          const CustomFeedSliverAppBar(),

          // Feed List

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
