import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NoResultsWidget extends StatelessWidget {
  final String searchQuery;
  final VoidCallback onClearFilters;
  final Function(String) onSuggestedSearch;
  final List<String> suggestedSearches;

  const NoResultsWidget({
    Key? key,
    required this.searchQuery,
    required this.onClearFilters,
    required this.onSuggestedSearch,
    required this.suggestedSearches,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(6.w),
      child: Column(
        children: [
          SizedBox(height: 8.h),
          CustomImageWidget(
            imageUrl:
                'https://images.unsplash.com/photo-1584464491033-06628f3a6b7b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
            width: 60.w,
            height: 30.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 4.h),
          Text(
            'No Results Found',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            searchQuery.isNotEmpty
                ? 'We couldn\'t find any products matching "$searchQuery"'
                : 'Try adjusting your search or filters',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          ElevatedButton(
            onPressed: onClearFilters,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            ),
            child: Text('Clear All Filters'),
          ),
          SizedBox(height: 4.h),
          if (suggestedSearches.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Suggested Searches',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: suggestedSearches
                  .map(
                    (suggestion) => GestureDetector(
                      onTap: () => onSuggestedSearch(suggestion),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          suggestion,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          SizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Search Tips',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                _buildSearchTip('• Check your spelling'),
                _buildSearchTip('• Try more general keywords'),
                _buildSearchTip('• Use fewer filters'),
                _buildSearchTip('• Try searching for brand names'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTip(String tip) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Text(
        tip,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
