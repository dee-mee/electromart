import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../core/utils/currency_formatter.dart';

class ProductCardWidget extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback? onTap;
  final VoidCallback? onWishlistTap;
  final VoidCallback? onCompareTap;
  final VoidCallback? onShareTap;

  const ProductCardWidget({
    Key? key,
    required this.product,
    this.onTap,
    this.onWishlistTap,
    this.onCompareTap,
    this.onShareTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isInStock = (product["stock"] as int? ?? 0) > 0;
    final double originalPrice =
        (product["originalPrice"] as num?)?.toDouble() ?? 0.0;
    final double discountedPrice =
        (product["price"] as num?)?.toDouble() ?? 0.0;
    final bool hasDiscount = originalPrice > discountedPrice;
    final double rating = (product["rating"] as num?)?.toDouble() ?? 0.0;
    final int reviewCount = (product["reviewCount"] as int?) ?? 0;

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showQuickActions(context),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Wishlist Button
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: CustomImageWidget(
                      imageUrl: product["image"] as String? ?? "",
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Discount Badge
                  if (hasDiscount)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "${(((originalPrice - discountedPrice) / originalPrice) * 100).round()}% OFF",
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  // Wishlist Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onWishlistTap,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: product["isWishlisted"] == true
                              ? 'favorite'
                              : 'favorite_border',
                          color: product["isWishlisted"] == true
                              ? AppTheme.lightTheme.colorScheme.tertiary
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  // Stock Status Overlay
                  if (!isInStock)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "OUT OF STOCK",
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Product Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      product["name"] as String? ?? "",
                      style: AppTheme.lightTheme.textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Rating
                    if (rating > 0)
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'star',
                            color: Colors.amber,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating.toStringAsFixed(1),
                            style: AppTheme.lightTheme.textTheme.labelSmall,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "($reviewCount)",
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    const Spacer(),
                    // Price
                    Row(
                      children: [
                        Text(
                          formatCurrencyKsh(discountedPrice),
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (hasDiscount) ...[
                          const SizedBox(width: 8),
                          Text(
                            formatCurrencyKsh(originalPrice),
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              product["name"] as String? ?? "",
              style: AppTheme.lightTheme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickActionButton(
                  context,
                  'Add to Wishlist',
                  'favorite_border',
                  onWishlistTap,
                ),
                _buildQuickActionButton(
                  context,
                  'Compare',
                  'compare_arrows',
                  onCompareTap,
                ),
                _buildQuickActionButton(
                  context,
                  'Share',
                  'share',
                  onShareTap,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String label,
    String iconName,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap?.call();
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
