import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screen/main_navigation_screen.dart';
import 'widget/color.dart';
import 'widget/responsive.dart';

class FlashScreen extends StatefulWidget {
  const FlashScreen({Key? key}) : super(key: key);

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showFinalText = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showFinalText = true;
        });
        // Wait a bit before navigating away
        Future.delayed(const Duration(milliseconds: 800), () {
          Get.off(() => const MainNavigationScreen());
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildFlashingText(BuildContext context) {
    final fontSize = ResponsiveHelper.getFontSize(
      context,
      mobile: 28,
      tablet: 36,
      desktop: 42,
    );
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // The shimmer "light" runs from left to right, but the text is always visible in dark blue
        final double shimmerWidth = 80;
        final double progress = _controller.value;
        return Stack(
          children: [
            // Always-visible base text in primary color
            Text(
              'Welcome! BDM',
              style: TextStyle(
                color: AppColors.primaryDark,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Shimmer effect moving left to right
            Positioned.fill(
              child: IgnorePointer(
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    final double x = progress * (bounds.width + shimmerWidth) - shimmerWidth;
                    return LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.8),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                      // The transform below moves the gradient
                      transform: GradientTranslation(Offset(x, 0)),
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.srcATop,
                  child: Text(
                    'Welcome! BDM',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final logoSize = isTablet ? 160.0 : 120.0;
    final fontSize = ResponsiveHelper.getFontSize(
      context,
      mobile: 28,
      tablet: 36,
      desktop: 42,
    );
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: ResponsiveHelper.getPadding(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: logoSize,
                width: logoSize,
                child: const Image(
                  image: AssetImage('asset/logo.jpg'),
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: isTablet ? 32 : 24),
              if (!_showFinalText)
                _buildFlashingText(context)
              else
                Text(
                  'Welcome! BDM',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper for moving the gradient
class GradientTranslation extends GradientTransform {
  final Offset offset;
  const GradientTranslation(this.offset);

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(offset.dx, offset.dy, 0.0);
  }
}