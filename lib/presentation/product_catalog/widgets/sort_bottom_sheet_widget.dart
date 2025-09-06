import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

enum SortOption {
  relevance,
  priceLowToHigh,
  priceHighToLow,
  rating,
  newest,
}

class SortBottomSheetWidget extends StatelessWidget {
  final SortOption currentSort;
  final Function(SortOption) onSortSelected;

  const SortBottomSheetWidget({
    Key? key,
    required this.currentSort,
    required this.onSortSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Title
          Text(
            "Sort by",
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          // Sort Options
          _buildSortOption(
            context,
            "Relevance",
            SortOption.relevance,
            'trending_up',
          ),
          _buildSortOption(
            context,
            "Price: Low to High",
            SortOption.priceLowToHigh,
            'arrow_upward',
          ),
          _buildSortOption(
            context,
            "Price: High to Low",
            SortOption.priceHighToLow,
            'arrow_downward',
          ),
          _buildSortOption(
            context,
            "Customer Rating",
            SortOption.rating,
            'star',
          ),
          _buildSortOption(
            context,
            "Newest First",
            SortOption.newest,
            'schedule',
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    String title,
    SortOption option,
    String iconName,
  ) {
    final bool isSelected = currentSort == option;

    return GestureDetector(
      onTap: () {
        onSortSelected(option);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.secondary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.secondary
                      : AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected)
              CustomIconWidget(
                iconName: 'check',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
