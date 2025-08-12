import 'package:flutter/material.dart';

class ProfileHeaderResponsive {
  final BuildContext context;
  final double screenWidth;
  final double screenHeight;

  ProfileHeaderResponsive(this.context)
      : screenWidth = MediaQuery.of(context).size.width,
        screenHeight = MediaQuery.of(context).size.height;

  double get avatarSize => screenWidth * 0.2;

  double get horizontalPadding => screenWidth * 0.05;

  double get verticalPadding => screenHeight * 0.01;

  double get buttonHeight => screenHeight * 0.045;

  double get fontSizeUsername => screenWidth * 0.05;

  double get fontSizeBio => screenWidth * 0.035;

  double get statCountFontSize => screenWidth * 0.045;

  double get statLabelFontSize => screenWidth * 0.03;
}
