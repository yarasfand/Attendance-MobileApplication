import 'package:flutter/widgets.dart';

class ResponsiveLayout {
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1200;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  // Example method to calculate responsive padding based on the screen size
  static EdgeInsets contentPadding(BuildContext context) {
    if (isSmallScreen(context)) {
      return EdgeInsets.all(16.0);
    } else if (isMediumScreen(context)) {
      return EdgeInsets.all(24.0);
    } else if (isLargeScreen(context)) {
      // Adjust padding for specific large screen sizes
      if (MediaQuery.of(context).size.width == 360) {
        return EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0);
      } else if (MediaQuery.of(context).size.width == 390) {
        return EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0);
      } else if (MediaQuery.of(context).size.width == 414) {
        return EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.0);
      } else if (MediaQuery.of(context).size.width == 393) {
        return EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.5);
      } else if (MediaQuery.of(context).size.width == 412) {
        return EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.5);
      } else {
        // Default padding for other large screens
        return EdgeInsets.all(32.0);
      }
    } else {
      return EdgeInsets.all(32.0); // Default padding for other cases
    }
  }
}
