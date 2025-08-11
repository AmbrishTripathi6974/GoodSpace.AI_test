import 'package:flutter/material.dart';
import '../../../../model/post_model.dart';
import '../../../../core/utils/cached_image.dart';

class ProfilePostGrid extends StatelessWidget {
  final List<PostModel> posts;
  const ProfilePostGrid({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return CachedImage(imageUrl: post.postImage);
      },
    );
  }
}
