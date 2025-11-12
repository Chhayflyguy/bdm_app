import 'package:get/get.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartController extends GetxController {
  final RxList<CartItem> cartItems = <CartItem>[].obs;

  // Get total number of items in cart
  int get totalItems {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Get total price of all items in cart
  num get totalPrice {
    return cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // Check if cart is empty
  bool get isEmpty => cartItems.isEmpty;

  // Add product to cart
  void addToCart(Product product, {int quantity = 1}) {
    final existingItemIndex = cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex >= 0) {
      // Product already in cart, update quantity
      final existingItem = cartItems[existingItemIndex];
      final newQuantity = existingItem.quantity + quantity;
      
      // Check if quantity exceeds available stock
      if (newQuantity <= product.quantity) {
        cartItems[existingItemIndex] = existingItem.copyWith(quantity: newQuantity);
      } else {
        // Set to max available quantity
        cartItems[existingItemIndex] = existingItem.copyWith(quantity: product.quantity);
      }
    } else {
      // New product, add to cart
      cartItems.add(CartItem(
        product: product,
        quantity: quantity > product.quantity ? product.quantity : quantity,
      ));
    }
  }

  // Remove product from cart
  void removeFromCart(int productId) {
    cartItems.removeWhere((item) => item.product.id == productId);
  }

  // Update quantity of a cart item
  void updateQuantity(int productId, int quantity) {
    final itemIndex = cartItems.indexWhere((item) => item.product.id == productId);
    
    if (itemIndex >= 0) {
      if (quantity <= 0) {
        // Remove item if quantity is 0 or less
        removeFromCart(productId);
      } else {
        final item = cartItems[itemIndex];
        // Check if quantity exceeds available stock
        final maxQuantity = item.product.quantity;
        final newQuantity = quantity > maxQuantity ? maxQuantity : quantity;
        
        cartItems[itemIndex] = item.copyWith(quantity: newQuantity);
      }
    }
  }

  // Clear entire cart
  void clearCart() {
    cartItems.clear();
  }

  // Get cart item by product ID
  CartItem? getCartItem(int productId) {
    try {
      return cartItems.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }

  // Check if product is in cart
  bool isInCart(int productId) {
    return cartItems.any((item) => item.product.id == productId);
  }
}

