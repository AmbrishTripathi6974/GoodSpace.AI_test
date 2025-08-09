import 'package:flutter/material.dart';

import '../../core/utils/helper_function.dart';

class PostTile extends StatelessWidget {
  const PostTile({super.key});

  @override
  Widget build(BuildContext context) {
    final size = THelperFunctions.screenSize(context);
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          width: size.width,
          height: 54,
          color: Colors.white,
          child: Center(
            child: ListTile(
              leading: ClipOval(
                child: SizedBox(
                  width: 35,
                  height: 35,
                  child: Image.asset(
                    'assets/images/person.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Username
              title: Text(
                'Username',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(Icons.more_horiz),
            ),
          ),
        ),
        
        // Post Image
        SizedBox(
          width: size.width,
          height:
              size.height * 0.4, 
          child: Image.asset(
            'assets/images/post.jpg',
            fit: BoxFit.cover, 
            filterQuality: FilterQuality.high,
          ),
        ),

        Container(
          width: size.width,
          color: theme.scaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20,top: 10, right: 20, bottom: 5),
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite_outline_rounded,
                      size: 25,
                    ),
                    SizedBox(width: 15),
                    Image.asset(
                      'assets/images/comment.png',
                      height: 28,
                    ),
                    SizedBox(width: 15),
                    Image.asset(
                      'assets/images/send.jpg',
                      height: 28,
                      filterQuality: FilterQuality.high,
                    ),
                    Spacer(),
                    Image.asset(
                      'assets/images/save.png',
                      height: 28,
                      filterQuality: FilterQuality.high,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 12, bottom: 5, right: 20),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          color:
                              Colors.black, // Adjust for dark theme if needed
                        ),
                    children: const [
                      TextSpan(text: 'Liked by '),
                      TextSpan(
                        text: 'username',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: '74 others',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
