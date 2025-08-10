import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ReadMoreText extends StatelessWidget {
  final String username;
  final String caption;
  final int trimLength;
  final bool isExpanded;
  final VoidCallback onTapReadMore;

  const ReadMoreText({
    super.key,
    required this.username,
    required this.caption,
    this.trimLength = 100,
    required this.isExpanded,
    required this.onTapReadMore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bool isLong = caption.length > trimLength;
    final String displayText = isExpanded || !isLong
        ? caption
        : "${caption.substring(0, trimLength)}...";

    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 5),
      child: RichText(
        text: TextSpan(
          children: [
            // Username
            TextSpan(
              text: "$username ",
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            // Caption
            TextSpan(
              text: displayText,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            // Read More / Read Less
            if (isLong)
              TextSpan(
                text: isExpanded ? " Read less" : " Read more",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                recognizer: TapGestureRecognizer()..onTap = onTapReadMore,
              ),
          ],
        ),
      ),
    );
  }
}
