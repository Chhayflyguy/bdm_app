import 'package:flutter/material.dart';
import '../../widget/color.dart';
import '../../widget/responsive.dart';
import '../../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: isTablet ? 400 : 300,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.secondary,
            flexibleSpace: FlexibleSpaceBar(
              background: product.imageUrl != null
                  ? Image.network(
                      product.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.primary.withOpacity(0.1),
                          child: Center(
                            child: Icon(
                              Icons.shopping_bag,
                              size: ResponsiveHelper.getIconSize(context) * 3,
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      color: AppColors.primary.withOpacity(0.1),
                      child: Center(
                        child: Icon(
                          Icons.shopping_bag,
                          size: ResponsiveHelper.getIconSize(context) * 3,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: ResponsiveHelper.getPadding(context),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveHelper.getConstrainedWidth(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stock Status Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 12 : 10,
                        vertical: isTablet ? 6 : 5,
                      ),
                      decoration: BoxDecoration(
                        color: product.inStock
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        product.inStock ? 'In Stock' : 'Out of Stock',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getFontSize(
                            context,
                            mobile: 12,
                            tablet: 14,
                            desktop: 14,
                          ),
                          fontWeight: FontWeight.w600,
                          color: product.inStock
                              ? Colors.green[700]
                              : Colors.red[700],
                        ),
                      ),
                    ),
                    SizedBox(height: isTablet ? 24 : 20),
                    // Product Name
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getFontSize(
                          context,
                          mobile: 24,
                          tablet: 28,
                          desktop: 32,
                        ),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: isTablet ? 16 : 12),
                    // Price
                    Row(
                      children: [
                        Text(
                          '\$${product.price}',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getFontSize(
                              context,
                              mobile: 32,
                              tablet: 40,
                              desktop: 44,
                            ),
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isTablet ? 20 : 16),
                    // Description Section
                    if (product.description != null && product.description!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
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
                          SizedBox(height: isTablet ? 12 : 10),
                          Text(
                            product.description!,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getFontSize(
                                context,
                                mobile: 16,
                                tablet: 18,
                                desktop: 18,
                              ),
                              color: AppColors.textSecondary,
                              height: 1.6,
                            ),
                          ),
                          SizedBox(height: isTablet ? 24 : 20),
                        ],
                      ),
                    // Product Info Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(isTablet ? 20 : 16),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              context,
                              icon: Icons.inventory_2,
                              label: 'Available Quantity',
                              value: '${product.quantity}',
                            ),
                            if (isTablet) const SizedBox(height: 16),
                            if (isTablet) const Divider(),
                            if (isTablet) const SizedBox(height: 16),
                            _buildInfoRow(
                              context,
                              icon: Icons.check_circle,
                              label: 'Product ID',
                              value: '#${product.id}',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: isTablet ? 30 : 24),
                    // Action Buttons
                    Row(
                      children: [
                        // Add to Cart Button
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: product.inStock
                                ? () {
                                    _handleAddToCart(context);
                                  }
                                : null,
                            icon: Icon(
                              Icons.shopping_cart,
                              size: ResponsiveHelper.getIconSize(context),
                            ),
                            label: Text(
                              'Add to Cart',
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
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: BorderSide(color: AppColors.primary),
                              padding: EdgeInsets.symmetric(
                                vertical: isTablet ? 16 : 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: isTablet ? 16 : 12),
                        // Order Now Button
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: product.inStock
                                ? () {
                                    _handleOrder(context);
                                  }
                                : null,
                            icon: Icon(
                              Icons.shopping_bag,
                              size: ResponsiveHelper.getIconSize(context),
                            ),
                            label: Text(
                              'Order Now',
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.secondary,
                              padding: EdgeInsets.symmetric(
                                vertical: isTablet ? 16 : 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isTablet ? 30 : 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final isTablet = ResponsiveHelper.isTablet(context);
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: ResponsiveHelper.getIconSize(context),
        ),
        SizedBox(width: isTablet ? 16 : 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getFontSize(
                    context,
                    mobile: 12,
                    tablet: 14,
                    desktop: 14,
                  ),
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
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
            ],
          ),
        ),
      ],
    );
  }

  void _handleAddToCart(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.secondary),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                '${product.name} added to cart',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getFontSize(
                    context,
                    mobile: 14,
                    tablet: 16,
                    desktop: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
    // TODO: Implement actual add to cart functionality
  }

  void _handleOrder(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final isTablet = ResponsiveHelper.isTablet(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Confirm Order',
            style: TextStyle(
              fontSize: ResponsiveHelper.getFontSize(
                context,
                mobile: 20,
                tablet: 24,
                desktop: 24,
              ),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Product: ${product.name}',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getFontSize(
                    context,
                    mobile: 16,
                    tablet: 18,
                    desktop: 18,
                  ),
                ),
              ),
              SizedBox(height: isTablet ? 12 : 8),
              Text(
                'Price: \$${product.price}',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getFontSize(
                    context,
                    mobile: 16,
                    tablet: 18,
                    desktop: 18,
                  ),
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: isTablet ? 12 : 8),
              Text(
                'Do you want to proceed with this order?',
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
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getFontSize(
                    context,
                    mobile: 16,
                    tablet: 18,
                    desktop: 18,
                  ),
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: AppColors.secondary),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Order placed successfully!',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getFontSize(
                                context,
                                mobile: 14,
                                tablet: 16,
                                desktop: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
                // TODO: Implement actual order functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Confirm',
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
          ],
        );
      },
    );
  }
}

