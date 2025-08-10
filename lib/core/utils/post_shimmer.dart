import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PostTileShimmer extends StatelessWidget {
  const PostTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final baseColor = Colors.grey.shade300;
    final highlightColor = Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        children: [
          // Header (profile pic + username + more icon)
          Container(
            width: size.width,
            height: 54,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Profile pic circle
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: baseColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),

                // Username bar
                Container(
                  width: size.width * 0.3,
                  height: 16,
                  color: baseColor,
                ),
                const Spacer(),

                // More icon circle
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: baseColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),

          // Post image placeholder
          Container(
            width: size.width,
            height: size.height * 0.4,
            color: baseColor,
          ),

          // Bottom action icons
          Container(
            width: size.width,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: List.generate(4, (index) {
                return Padding(
                  padding: EdgeInsets.only(right: index == 3 ? 0 : 15),
                  child: Container(
                    width: 28,
                    height: 28,
                    color: baseColor,
                  ),
                );
              }),
            ),
          ),

          // Liked by text bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 5),
            child: Container(
              width: size.width * 0.5,
              height: 14,
              color: baseColor,
            ),
          ),
        ],
      ),
    );
  }
}
