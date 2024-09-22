import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 375;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 812;
  }
}

const double defaultPadding = 16;

const verticalSpaceDefault = SizedBox(height: 16);
const verticalSpaceLarge = SizedBox(height: 40);
const verticalSpaceHuge = SizedBox(height: 60);
const verticalSpaceSmall = SizedBox(height: 10);
const verticalSpaceTiny = SizedBox(height: 5);
const horizontalSpaceDefault = SizedBox(width: 16);
const horizontalSpaceSmall = SizedBox(width: 10);
const horizontalSpaceTiny = SizedBox(width: 5);
const horizontalSpaceLarge = SizedBox(width: 40);
