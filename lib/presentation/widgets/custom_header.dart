import 'package:flutter/material.dart';

class CustomFeedSliverAppBar extends StatelessWidget {
  const CustomFeedSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      backgroundColor: theme.appBarTheme.backgroundColor, 
      floating: true,
      snap: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 55,
            child: Image.asset(
              'assets/text_logo.png',
              fit: BoxFit.contain,
            ),
          ),

          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.favorite_border_rounded,
                  color: theme.appBarTheme.foregroundColor ?? Colors.black,
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Image.asset(
                  'assets/images/send.jpg',
                  height: 22,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
