import 'package:flutter/material.dart';

class ResponsiveUtils {
  static double getValue(BuildContext context, {required double mobile, required double tablet, required double desktop}) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return mobile;
    if (width < 1024) return tablet;
    return desktop;
  }

  static EdgeInsets getCardMargin(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return const EdgeInsets.only(bottom: 10);
    if (width < 1024) return const EdgeInsets.only(bottom: 11);
    return const EdgeInsets.only(bottom: 12);
  }

  static EdgeInsets getContentPadding(BuildContext context) {
    return EdgeInsets.all(
      getValue(context, mobile: 14.0, tablet: 16.0, desktop: 18.0),
    );
  }
}
