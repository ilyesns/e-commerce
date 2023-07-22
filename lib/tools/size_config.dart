import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  late double screenWidth;
  late double screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) async {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }

  static final SizeConfig _sizeConfig = SizeConfig._internal();
  SizeConfig._internal();

  factory SizeConfig() {
    return _sizeConfig;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(BuildContext context, double inputHeight) {
  SizeConfig sizeConfig = SizeConfig();
  sizeConfig.init(context);

  double screenHeight = sizeConfig.screenHeight;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate width as per screen size
double getProportionateScreenWidth(BuildContext context, double inputWidth) {
  SizeConfig sizeConfig = SizeConfig();
  sizeConfig.init(context);

  double screenWidth = sizeConfig.screenWidth;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}
