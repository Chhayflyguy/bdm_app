import 'package:flutter/material.dart';

class ResponsiveHelper {
  // Screen size breakpoints
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 900;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }

  static bool isIPad(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 900 && width < 1200;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  // Get responsive width
  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // Get responsive height
  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Get responsive padding
  static EdgeInsets getPadding(BuildContext context) {
    final width = getWidth(context);
    if (width >= 900) {
      return const EdgeInsets.all(24.0);
    } else if (width >= 600) {
      return const EdgeInsets.all(20.0);
    } else {
      return const EdgeInsets.all(16.0);
    }
  }

  // Get responsive horizontal padding
  static EdgeInsets getHorizontalPadding(BuildContext context) {
    final width = getWidth(context);
    if (width >= 900) {
      return const EdgeInsets.symmetric(horizontal: 32.0);
    } else if (width >= 600) {
      return const EdgeInsets.symmetric(horizontal: 24.0);
    } else {
      return const EdgeInsets.symmetric(horizontal: 16.0);
    }
  }

  // Get responsive font size
  static double getFontSize(BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop(context) && desktop != null) return desktop;
    if (isTablet(context) && tablet != null) return tablet;
    return mobile ?? 14;
  }

  // Get responsive spacing
  static double getSpacing(BuildContext context) {
    final width = getWidth(context);
    if (width >= 900) {
      return 20.0;
    } else if (width >= 600) {
      return 18.0;
    } else {
      return 16.0;
    }
  }

  // Get responsive grid columns
  static int getGridColumns(BuildContext context) {
    final width = getWidth(context);
    if (width > 1200) {
      return 5;
    } else if (width > 900) {
      return 4;
    } else if (width > 600) {
      return 3;
    } else {
      return 2;
    }
  }

  // Get responsive aspect ratio for cards
  static double getCardAspectRatio(BuildContext context) {
    final width = getWidth(context);
    if (width > 1200) {
      return 0.7;
    } else if (width > 900) {
      return 0.72;
    } else if (width > 600) {
      return 0.75;
    } else {
      return 0.75;
    }
  }

  // Get responsive icon size
  static double getIconSize(BuildContext context) {
    if (isDesktop(context)) return 28;
    if (isTablet(context)) return 24;
    return 20;
  }

  // Get constrained width for content (max width for readability on large screens)
  static double getConstrainedWidth(BuildContext context) {
    final width = getWidth(context);
    if (width > 1200) {
      return 1200;
    } else if (width > 900) {
      return 900;
    }
    return width;
  }
}

