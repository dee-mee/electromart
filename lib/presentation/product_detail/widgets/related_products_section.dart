import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../core/utils/currency_formatter.dart';

class RelatedProductsSection extends StatelessWidget {
  final List<Map<String, dynamic>> relatedProducts;

  const RelatedProductsSection({
    Key? key,
    required this.relatedProducts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Related Products',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 35.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: relatedProducts.length,
              itemBuilder: (context, index) {
                final product = relatedProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/product-detail',
                      arguments: {'productId': product['id']},
                    );
                  },
                  onLongPress: () {
                    _showQuickActions(context, product);
                  },
                  child: Container(
                    width: 40.w,
                    margin: EdgeInsets.only(right: 3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(3.w),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(3.w)),
                            child: CustomImageWidget(
                              imageUrl: product['image'] as String,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.all(2.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name'] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.titleSmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  formatCurrencyKsh((product['price'] as num).toDouble()),
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Row(
                                  children: [
                                    Row(
                                      children: List.generate(5, (starIndex) {
                                        return CustomIconWidget(
                                          iconName: starIndex <
                                                  (product['rating'] as num)
                                                      .floor()
                                              ? 'star'
                                              : 'star_border',
                                          color: AppTheme
                                              .lightTheme.colorScheme.tertiary,
                                          size: 2.5.w,
                                        );
                                      }),
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      '(${product['reviewCount']})',
                                      style: AppTheme
                                          .lightTheme.textTheme.labelSmall
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface
                                            .withValues(alpha: 0.6),
                                      ),
                                    ),
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
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showQuickActions(BuildContext context, Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(1.h),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                product['name'] as String,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        // Add to wishlist logic
                      },
                      icon: CustomIconWidget(
                        iconName: 'favorite_border',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 4.w,
                      ),
                      label: Text('Wishlist'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.secondary,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          '/product-detail',
                          arguments: {'productId': product['id']},
                        );
                      },
                      icon: CustomIconWidget(
                        iconName: 'visibility',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 4.w,
                      ),
                      label: Text('View'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }
}
