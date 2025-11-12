import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widget/color.dart';
import '../../widget/responsive.dart';
import '../../models/product.dart';
import '../../controllers/cart_controller.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final cartController = Get.put(CartController());
    final product = widget.product;

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
                    
                    // Quantity Selector
                    if (product.inStock)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quantity',
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
                          SizedBox(height: isTablet ? 12 : 10),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: _quantity > 1
                                          ? () {
                                              setState(() {
                                                _quantity--;
                                              });
                                            }
                                          : null,
                                      icon: const Icon(Icons.remove, size: 20),
                                      padding: EdgeInsets.all(isTablet ? 12 : 10),
                                      constraints: const BoxConstraints(),
                                      color: AppColors.textPrimary,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isTablet ? 24 : 20,
                                      ),
                                      child: Text(
                                        '$_quantity',
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
                                    ),
                                    IconButton(
                                      onPressed: _quantity < product.quantity
                                          ? () {
                                              setState(() {
                                                _quantity++;
                                              });
                                            }
                                          : null,
                                      icon: const Icon(Icons.add, size: 20),
                                      padding: EdgeInsets.all(isTablet ? 12 : 10),
                                      constraints: const BoxConstraints(),
                                      color: AppColors.textPrimary,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'Available: ${product.quantity}',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getFontSize(
                                    context,
                                    mobile: 14,
                                    tablet: 15,
                                    desktop: 15,
                                  ),
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: isTablet ? 24 : 20),
                        ],
                      ),
                    
                    // Action Buttons
                    SizedBox(
                      width: double.infinity,
                      height: isTablet ? 56 : 50,
                      child: ElevatedButton.icon(
                        onPressed: product.inStock
                            ? () {
                                _handleAddToCart(context, cartController);
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
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

  void _handleAddToCart(BuildContext context, CartController cartController) {
    cartController.addToCart(widget.product, quantity: _quantity);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.secondary),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                '${_quantity}x ${widget.product.name} added to cart',
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
    
    // Reset quantity to 1 after adding to cart
    setState(() {
      _quantity = 1;
    });
  }
}

