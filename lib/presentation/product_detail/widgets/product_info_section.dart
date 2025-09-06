import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductInfoSection extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductInfoSection({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double originalPrice = (product['originalPrice'] as num).toDouble();
    final double discountPrice = (product['discountPrice'] as num).toDouble();
    final int discountPercentage =
        ((originalPrice - discountPrice) / originalPrice * 100).round();
    final bool isInStock = product['inStock'] as bool;
    final double rating = (product['rating'] as num).toDouble();
    final int reviewCount = product['reviewCount'] as int;

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product['name'] as String,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Text(
                '\$${discountPrice.toStringAsFixed(2)}',
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 2.w),
              if (originalPrice > discountPrice) ...[
                Text(
                  '\$${originalPrice.toStringAsFixed(2)}',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                  ),
                ),
                SizedBox(width: 2.w),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(1.h),
                  ),
                  child: Text(
                    '${discountPercentage}% OFF',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 1.5.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: isInStock
                      ? AppTheme.lightTheme.colorScheme.tertiary
                          .withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.error
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(1.h),
                  border: Border.all(
                    color: isInStock
                        ? AppTheme.lightTheme.colorScheme.tertiary
                        : AppTheme.lightTheme.colorScheme.error,
                    width: 1,
                  ),
                ),
                child: Text(
                  isInStock ? 'In Stock' : 'Out of Stock',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: isInStock
                        ? AppTheme.lightTheme.colorScheme.tertiary
                        : AppTheme.lightTheme.colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Spacer(),
              Row(
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return CustomIconWidget(
                        iconName:
                            index < rating.floor() ? 'star' : 'star_border',
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        size: 4.w,
                      );
                    }),
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    '${rating.toStringAsFixed(1)} (${reviewCount})',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
