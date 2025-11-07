import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widget/color.dart';
import '../widget/responsive.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final isDesktop = ResponsiveHelper.isDesktop(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking BDM'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.secondary,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: ResponsiveHelper.getPadding(context),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.getConstrainedWidth(context),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to Booking BDM!',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getFontSize(
                      context,
                      mobile: 24,
                      tablet: 28,
                      desktop: 32,
                    ),
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isTablet ? 40 : 30),
                Text(
                  'Your booking management system',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getFontSize(
                      context,
                      mobile: 16,
                      tablet: 18,
                      desktop: 20,
                    ),
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isTablet ? 50 : 40),
                SizedBox(
                  width: isDesktop ? 300 : (isTablet ? 250 : double.infinity),
                  height: isTablet ? 56 : 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.snackbar(
                        'Welcome',
                        'Welcome to Booking BDM!',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.primary,
                        colorText: AppColors.secondary,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(
                        fontSize: ResponsiveHelper.getFontSize(
                          context,
                          mobile: 16,
                          tablet: 18,
                          desktop: 18,
                        ),
                      ),
                    ),
                    child: const Text('Get Started'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}