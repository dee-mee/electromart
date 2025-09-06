import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SortBottomSheetWidget extends StatelessWidget {
  final String currentSort;
  final Function(String) onSortChanged;

  const SortBottomSheetWidget({
    Key? key,
    required this.currentSort,
    required this.onSortChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortOptions = [
      {'value': 'relevance', 'label': 'Relevance', 'icon': 'star'},
      {
        'value': 'price_low',
        'label': 'Price: Low to High',
        'icon': 'arrow_upward'
      },
      {
        'value': 'price_high',
        'label': 'Price: High to Low',
        'icon': 'arrow_downward'
      },
      {'value': 'rating', 'label': 'Customer Rating', 'icon': 'star_rate'},
      {'value': 'newest', 'label': 'Newest First', 'icon': 'schedule'},
      {'value': 'popularity', 'label': 'Most Popular', 'icon': 'trending_up'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                Container(
                  width: 12.w,
                  height: 1.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Sort By',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: sortOptions.length,
              itemBuilder: (context, index) {
                final option = sortOptions[index];
                final isSelected = currentSort == option['value'];

                return ListTile(
                  leading: CustomIconWidget(
                    iconName: option['icon'] as String,
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                  title: Text(
                    option['label'] as String,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  trailing: isSelected
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        )
                      : null,
                  onTap: () {
                    onSortChanged(option['value'] as String);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
