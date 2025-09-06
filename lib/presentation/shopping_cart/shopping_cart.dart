import 'package:flutter/material.dart';

import './widgets/cart_item_widget.dart';
import './widgets/cart_summary_widget.dart';
import './widgets/empty_cart_widget.dart';
import './widgets/promo_code_widget.dart';
import './widgets/suggested_products_widget.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({Key? key}) : super(key: key);

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  bool isEditMode = false;
  bool isLoading = false;
  List<CartItem> cartItems = [];
  List<CartItem> selectedItems = [];
  double subtotal = 0.0;
  double estimatedTax = 0.0;
  String? promoCode;
  double discount = 0.0;
  bool isProcessingPromo = false;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  void _loadCartItems() {
    setState(() {
      isLoading = true;
    });

    // Simulated cart data - in real app, load from backend/local storage
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        cartItems = [
          CartItem(
            id: '1',
            name: 'iPhone 15 Pro Max',
            price: 1199.99,
            quantity: 1,
            imageUrl:
                'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=500',
            variant: 'Natural Titanium, 256GB',
            inStock: true,
            maxQuantity: 5,
          ),
          CartItem(
            id: '2',
            name: 'Samsung Galaxy Watch 6',
            price: 329.99,
            quantity: 2,
            imageUrl:
                'https://images.unsplash.com/photo-1579586337278-3f436f25d4d4?w=500',
            variant: 'Black, 44mm',
            inStock: true,
            maxQuantity: 3,
          ),
          CartItem(
            id: '3',
            name: 'Sony WH-1000XM5 Headphones',
            price: 399.99,
            quantity: 1,
            imageUrl:
                'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
            variant: 'Midnight Black',
            inStock: false,
            maxQuantity: 10,
          ),
        ];
        isLoading = false;
        _calculateTotals();
      });
    });
  }

  void _calculateTotals() {
    subtotal =
        cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    estimatedTax = subtotal * 0.08; // 8% tax rate
    setState(() {});
  }

  void _toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;
      if (!isEditMode) {
        selectedItems.clear();
      }
    });
  }

  void _onItemSelected(CartItem item, bool selected) {
    setState(() {
      if (selected) {
        selectedItems.add(item);
      } else {
        selectedItems.remove(item);
      }
    });
  }

  void _removeSelectedItems() {
    if (selectedItems.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Items'),
        content: Text('Remove ${selectedItems.length} item(s) from cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                for (var item in selectedItems) {
                  cartItems.remove(item);
                }
                selectedItems.clear();
                isEditMode = false;
                _calculateTotals();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Items removed from cart')),
              );
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _updateQuantity(CartItem item, int newQuantity) {
    if (newQuantity <= 0) {
      _removeItem(item);
      return;
    }

    if (newQuantity > item.maxQuantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Maximum quantity available: ${item.maxQuantity}')),
      );
      return;
    }

    setState(() {
      item.quantity = newQuantity;
      _calculateTotals();
    });
  }

  void _removeItem(CartItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Item'),
        content: Text('Remove ${item.name} from cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                cartItems.remove(item);
                _calculateTotals();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.name} removed'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      setState(() {
                        cartItems.add(item);
                        _calculateTotals();
                      });
                    },
                  ),
                ),
              );
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _moveToWishlist(CartItem item) {
    setState(() {
      cartItems.remove(item);
      _calculateTotals();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} moved to wishlist'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              cartItems.add(item);
              _calculateTotals();
            });
          },
        ),
      ),
    );
  }

  void _applyPromoCode(String code) {
    setState(() {
      isProcessingPromo = true;
    });

    // Simulate API call
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        isProcessingPromo = false;
        if (code.toUpperCase() == 'SAVE10') {
          promoCode = code;
          discount = subtotal * 0.10; // 10% discount
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Promo code applied successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid promo code')),
          );
        }
      });
    });
  }

  void _removePromoCode() {
    setState(() {
      promoCode = null;
      discount = 0.0;
    });
  }

  void _proceedToCheckout() {
    if (cartItems.isEmpty) return;

    // Check stock availability
    final outOfStockItems = cartItems.where((item) => !item.inStock).toList();
    if (outOfStockItems.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Items Unavailable'),
          content: Text(
            'The following items are out of stock:\n${outOfStockItems.map((e) => e.name).join('\n')}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    Navigator.pushNamed(context, '/checkout', arguments: {
      'cartItems': cartItems,
      'subtotal': subtotal,
      'tax': estimatedTax,
      'discount': discount,
      'promoCode': promoCode,
    });
  }

  Future<void> _refreshCart() async {
    await Future.delayed(const Duration(seconds: 1));
    _loadCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          if (cartItems.isNotEmpty)
            TextButton(
              onPressed: _toggleEditMode,
              child: Text(isEditMode ? 'Done' : 'Edit'),
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? const EmptyCartWidget()
              : RefreshIndicator(
                  onRefresh: _refreshCart,
                  child: Column(
                    children: [
                      if (isEditMode && selectedItems.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: Row(
                            children: [
                              Text(
                                '${selectedItems.length} selected',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const Spacer(),
                              TextButton.icon(
                                onPressed: _removeSelectedItems,
                                icon: const Icon(Icons.delete_outline),
                                label: const Text('Remove'),
                              ),
                              const SizedBox(width: 8),
                              TextButton.icon(
                                onPressed: () {
                                  for (var item in selectedItems) {
                                    _moveToWishlist(item);
                                  }
                                  selectedItems.clear();
                                  setState(() => isEditMode = false);
                                },
                                icon: const Icon(Icons.favorite_outline),
                                label: const Text('Wishlist'),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: cartItems.length +
                              2, // +2 for promo code and suggested products
                          itemBuilder: (context, index) {
                            if (index < cartItems.length) {
                              final item = cartItems[index];
                              return CartItemWidget(
                                item: item,
                                isEditMode: isEditMode,
                                isSelected: selectedItems.contains(item),
                                onSelectionChanged: (selected) =>
                                    _onItemSelected(item, selected),
                                onQuantityChanged: (quantity) =>
                                    _updateQuantity(item, quantity),
                                onRemove: () => _removeItem(item),
                                onMoveToWishlist: () => _moveToWishlist(item),
                              );
                            } else if (index == cartItems.length) {
                              return PromoCodeWidget(
                                currentPromoCode: promoCode,
                                isProcessing: isProcessingPromo,
                                onApplyPromoCode: _applyPromoCode,
                                onRemovePromoCode: _removePromoCode,
                              );
                            } else {
                              return const SuggestedProductsWidget();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
      bottomSheet: cartItems.isNotEmpty
          ? CartSummaryWidget(
              subtotal: subtotal,
              estimatedTax: estimatedTax,
              discount: discount,
              promoCode: promoCode,
              isEnabled: cartItems.isNotEmpty && !isEditMode,
              onProceedToCheckout: _proceedToCheckout,
            )
          : null,
    );
  }
}

class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;
  final String imageUrl;
  final String variant;
  final bool inStock;
  final int maxQuantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.variant,
    required this.inStock,
    required this.maxQuantity,
  });
}
