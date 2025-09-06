import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CustomerReviewsContent extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;

  const CustomerReviewsContent({
    Key? key,
    required this.reviews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: reviews.take(3).map((review) {
        final double rating = (review['rating'] as num).toDouble();
        final DateTime reviewDate = review['date'] as DateTime;
        final String formattedDate =
            '${reviewDate.month}/${reviewDate.day}/${reviewDate.year}';

        return Container(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 4.w,
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    child: Text(
                      (review['userName'] as String)
                          .substring(0, 1)
                          .toUpperCase(),
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review['userName'] as String,
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                return CustomIconWidget(
                                  iconName: index < rating.floor()
                                      ? 'star'
                                      : 'star_border',
                                  color:
                                      AppTheme.lightTheme.colorScheme.tertiary,
                                  size: 3.w,
                                );
                              }),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              formattedDate,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.5.h),
              Text(
                review['comment'] as String,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (review['images'] != null &&
                  (review['images'] as List).isNotEmpty) ...[
                SizedBox(height: 1.5.h),
                SizedBox(
                  height: 15.w,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (review['images'] as List).length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(right: 2.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2.w),
                          child: CustomImageWidget(
                            imageUrl:
                                (review['images'] as List)[index] as String,
                            width: 15.w,
                            height: 15.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}
