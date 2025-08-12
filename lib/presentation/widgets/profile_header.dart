import 'package:flutter/material.dart';
import '../../../../model/user_model.dart';
import '../../../../core/utils/cached_image.dart';
import 'responsive_profile_header.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;
  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final responsive = ProfileHeaderResponsive(context);

    return Container(
      padding: EdgeInsets.only(bottom: responsive.verticalPadding),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(responsive.horizontalPadding),
                child: ClipOval(
                  child: CachedImage(
                    imageUrl: user.profile,
                    height: responsive.avatarSize,
                    width: responsive.avatarSize,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStat(
                      user.followers.length,
                      "Followers",
                      theme,
                      responsive.statCountFontSize,
                      responsive.statLabelFontSize,
                    ),
                    _buildStat(
                      user.following.length,
                      "Following",
                      theme,
                      responsive.statCountFontSize,
                      responsive.statLabelFontSize,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: responsive.horizontalPadding * 2),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.username,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.fontSizeUsername,
                    ),
                  ),
                  SizedBox(height: responsive.verticalPadding * 2),
                  Text(
                    user.bio,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: responsive.fontSizeBio,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: responsive.verticalPadding * 5),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: responsive.horizontalPadding * 1.5),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: Size.fromHeight(responsive.buttonHeight),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(responsive.buttonHeight / 2),
                ),
              ),
              child: Text(
                "Edit Profile",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: responsive.fontSizeBio,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(
    int count,
    String label,
    ThemeData theme,
    double countFontSize,
    double labelFontSize,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          count.toString(),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: countFontSize,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: labelFontSize,
          ),
        ),
      ],
    );
  }
}
