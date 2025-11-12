import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widget/color.dart';
import '../../widget/responsive.dart';
import '../../controllers/cart_controller.dart';
import '../../models/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.secondary,
        elevation: 0,
      ),
      body: Obx(() {
        if (cartController.isEmpty) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withOpacity(0.05),
                  AppColors.background,
                ],
              ),
            ),
            child: Center(
              child: Padding(
                padding: ResponsiveHelper.getPadding(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: isTablet ? 120 : 80,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: isTablet ? 24 : 20),
                    Text(
                      'Your cart is empty',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getFontSize(
                          context,
                          mobile: 20,
                          tablet: 24,
                          desktop: 28,
                        ),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: isTablet ? 12 : 10),
                    Text(
                      'Add some products to get started',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getFontSize(
                          context,
                          mobile: 14,
                          tablet: 16,
                          desktop: 18,
                        ),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary.withOpacity(0.05),
                AppColors.background,
              ],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: isTablet ? 24 : 16,
                    left: ResponsiveHelper.getPadding(context).left,
                    right: ResponsiveHelper.getPadding(context).right,
                    bottom: ResponsiveHelper.getPadding(context).bottom,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: ResponsiveHelper.getConstrainedWidth(context),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.shopping_cart,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Shopping Cart',
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.getFontSize(
                                        context,
                                        mobile: 22,
                                        tablet: 26,
                                        desktop: 28,
                                      ),
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${cartController.totalItems} ${cartController.totalItems == 1 ? 'item' : 'items'}',
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.getFontSize(
                                        context,
                                        mobile: 14,
                                        tablet: 16,
                                        desktop: 16,
                                      ),
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (cartController.cartItems.isNotEmpty)
                              TextButton.icon(
                                onPressed: () => _showClearCartDialog(context, cartController),
                                icon: const Icon(Icons.delete_outline, size: 18),
                                label: const Text('Clear'),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.error,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: isTablet ? 24 : 20),
                        // Cart Items
                        ...cartController.cartItems.map((cartItem) => _buildCartItem(
                          context,
                          cartItem: cartItem,
                          cartController: cartController,
                          isTablet: isTablet,
                        )),
                      ],
                    ),
                  ),
                ),
              ),
              // Bottom Summary
              Container(
                padding: EdgeInsets.all(isTablet ? 24 : 20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: ResponsiveHelper.getConstrainedWidth(context),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getFontSize(
                                  context,
                                  mobile: 18,
                                  tablet: 20,
                                  desktop: 22,
                                ),
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '\$${cartController.totalPrice.toStringAsFixed(2)}',
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
                            ),
                          ],
                        ),
                        SizedBox(height: isTablet ? 16 : 12),
                        SizedBox(
                          width: double.infinity,
                          height: isTablet ? 56 : 50,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Implement checkout functionality
                              Get.snackbar(
                                'Checkout',
                                'Checkout functionality coming soon!',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppColors.info,
                                colorText: AppColors.secondary,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Proceed to Checkout',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getFontSize(
                                  context,
                                  mobile: 16,
                                  tablet: 18,
                                  desktop: 18,
                                ),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCartItem(
    BuildContext context, {
    required CartItem cartItem,
    required CartController cartController,
    required bool isTablet,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            width: isTablet ? 100 : 80,
            height: isTablet ? 100 : 80,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: cartItem.product.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      cartItem.product.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.shopping_bag,
                            size: isTablet ? 40 : 32,
                            color: AppColors.textSecondary,
                          ),
                        );
                      },
                    ),
                  )
                : Center(
                    child: Icon(
                      Icons.shopping_bag,
                      size: isTablet ? 40 : 32,
                      color: AppColors.textSecondary,
                    ),
                  ),
          ),
          SizedBox(width: isTablet ? 16 : 12),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.product.name,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getFontSize(
                      context,
                      mobile: 16,
                      tablet: 18,
                      desktop: 20,
                    ),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isTablet ? 8 : 6),
                Text(
                  '\$${cartItem.product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getFontSize(
                      context,
                      mobile: 18,
                      tablet: 20,
                      desktop: 22,
                    ),
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: isTablet ? 12 : 10),
                // Quantity Controls
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: cartItem.quantity > 1
                                ? () {
                                    cartController.updateQuantity(
                                      cartItem.product.id,
                                      cartItem.quantity - 1,
                                    );
                                  }
                                : null,
                            icon: const Icon(Icons.remove, size: 18),
                            padding: EdgeInsets.all(isTablet ? 8 : 6),
                            constraints: const BoxConstraints(),
                            color: AppColors.textPrimary,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 16 : 12,
                            ),
                            child: Text(
                              '${cartItem.quantity}',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getFontSize(
                                  context,
                                  mobile: 16,
                                  tablet: 18,
                                  desktop: 18,
                                ),
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: cartItem.quantity < cartItem.product.quantity
                                ? () {
                                    cartController.updateQuantity(
                                      cartItem.product.id,
                                      cartItem.quantity + 1,
                                    );
                                  }
                                : null,
                            icon: const Icon(Icons.add, size: 18),
                            padding: EdgeInsets.all(isTablet ? 8 : 6),
                            constraints: const BoxConstraints(),
                            color: AppColors.textPrimary,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '\$${cartItem.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getFontSize(
                          context,
                          mobile: 18,
                          tablet: 20,
                          desktop: 22,
                        ),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: isTablet ? 12 : 8),
          // Remove Button
          IconButton(
            onPressed: () {
              cartController.removeFromCart(cartItem.product.id);
              Get.snackbar(
                'Removed',
                '${cartItem.product.name} removed from cart',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.success,
                colorText: AppColors.secondary,
                duration: const Duration(seconds: 1),
              );
            },
            icon: const Icon(Icons.delete_outline),
            color: AppColors.error,
            tooltip: 'Remove',
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartController cartController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.error),
              const SizedBox(width: 8),
              const Text('Clear Cart'),
            ],
          ),
          content: const Text(
            'Are you sure you want to remove all items from your cart?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                cartController.clearCart();
                Navigator.of(context).pop();
                Get.snackbar(
                  'Cart Cleared',
                  'All items have been removed from your cart',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.success,
                  colorText: AppColors.secondary,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }
}

