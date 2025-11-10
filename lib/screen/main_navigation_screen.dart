import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widget/color.dart';
import '../widget/responsive.dart';
import 'home.dart';
import 'services/services_screen.dart';
import 'product/product_screen.dart';
import 'booking/my_booking.dart';
import 'settings_screen.dart';

class MainNavigationController extends GetxController {
  final RxInt currentIndex = 0.obs;
  
  void changeIndex(int index) {
    currentIndex.value = index;
  }
}

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainNavigationController());
    
    final List<Widget> screens = [
      const HomePage(),
      const ServicesScreen(),
      const ProductScreen(),
      const MyBookingPage(),
      const SettingsScreen(),
    ];

    return Obx(() {
      final isTablet = ResponsiveHelper.isTablet(context);
      final isDesktop = ResponsiveHelper.isDesktop(context);
      
      return Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: screens,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.secondary,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Container(
              height: isTablet ? 90 : 80,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 32 : (isTablet ? 24 : 16),
                vertical: isTablet ? 12 : 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context,
                    controller: controller,
                    index: 0,
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: 'Home',
                  ),
                  _buildNavItem(
                    context,
                    controller: controller,
                    index: 1,
                    icon: Icons.spa_outlined,
                    activeIcon: Icons.spa,
                    label: 'Services',
                  ),
                  _buildNavItem(
                    context,
                    controller: controller,
                    index: 2,
                    icon: Icons.shopping_bag_outlined,
                    activeIcon: Icons.shopping_bag,
                    label: 'Products',
                  ),
                  _buildNavItem(
                    context,
                    controller: controller,
                    index: 3,
                    icon: Icons.calendar_today_outlined,
                    activeIcon: Icons.calendar_today,
                    label: 'Booking',
                  ),
                  _buildNavItem(
                    context,
                    controller: controller,
                    index: 4,
                    icon: Icons.settings_outlined,
                    activeIcon: Icons.settings,
                    label: 'Settings',
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNavItem(
    BuildContext context, {
    required MainNavigationController controller,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    return Obx(() {
      final isActive = controller.currentIndex.value == index;
      final isTablet = ResponsiveHelper.isTablet(context);
      final isDesktop = ResponsiveHelper.isDesktop(context);
      
      return GestureDetector(
        onTap: () => controller.changeIndex(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 16 : (isTablet ? 14 : 12),
            vertical: isTablet ? 10 : 8,
          ),
          decoration: BoxDecoration(
            color: isActive 
                ? AppColors.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Icon(
                  isActive ? activeIcon : icon,
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                  size: isActive 
                      ? (isTablet ? 28 : 26)
                      : (isTablet ? 26 : 24),
                ),
              ),
              SizedBox(height: isTablet ? 6 : 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: isActive
                      ? (isTablet ? 13 : 12)
                      : (isTablet ? 12 : 11),
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      );
    });
  }
}
