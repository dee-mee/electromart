import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterModalWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const FilterModalWidget({
    Key? key,
    required this.currentFilters,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<FilterModalWidget> createState() => _FilterModalWidgetState();
}

class _FilterModalWidgetState extends State<FilterModalWidget> {
  late Map<String, dynamic> _filters;
  RangeValues _priceRange = const RangeValues(0, 2000);

  final List<String> _categories = [
    'Smartphones',
    'Earphones',
    'Earpods',
    'Accessories'
  ];
  final List<String> _brands = [
    'Apple',
    'Samsung',
    'Sony',
    'Bose',
    'JBL',
    'OnePlus'
  ];
  final List<String> _ratings = [
    '4+ Stars',
    '3+ Stars',
    '2+ Stars',
    '1+ Stars'
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
    _priceRange = RangeValues(
      (_filters['minPrice'] ?? 0).toDouble(),
      (_filters['maxPrice'] ?? 2000).toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPriceRangeSection(),
                  SizedBox(height: 3.h),
                  _buildCategorySection(),
                  SizedBox(height: 3.h),
                  _buildBrandSection(),
                  SizedBox(height: 3.h),
                  _buildRatingSection(),
                  SizedBox(height: 3.h),
                  _buildAvailabilitySection(),
                ],
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              TextButton(
                onPressed: _clearAllFilters,
                child: Text(
                  'Clear All',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 2000,
          divisions: 20,
          labels: RangeLabels(
            '\$${_priceRange.start.round()}',
            '\$${_priceRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() {
              _priceRange = values;
              _filters['minPrice'] = values.start.round();
              _filters['maxPrice'] = values.end.round();
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${_priceRange.start.round()}',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            Text(
              '\$${_priceRange.end.round()}',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _categories
              .map(
                (category) => FilterChip(
                  label: Text(category),
                  selected: (_filters['categories'] as List<String>? ?? [])
                      .contains(category),
                  onSelected: (selected) {
                    setState(() {
                      final categories =
                          (_filters['categories'] as List<String>? ?? [])
                              .toList();
                      if (selected) {
                        categories.add(category);
                      } else {
                        categories.remove(category);
                      }
                      _filters['categories'] = categories;
                    });
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildBrandSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Brand',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _brands
              .map(
                (brand) => FilterChip(
                  label: Text(brand),
                  selected: (_filters['brands'] as List<String>? ?? [])
                      .contains(brand),
                  onSelected: (selected) {
                    setState(() {
                      final brands =
                          (_filters['brands'] as List<String>? ?? []).toList();
                      if (selected) {
                        brands.add(brand);
                      } else {
                        brands.remove(brand);
                      }
                      _filters['brands'] = brands;
                    });
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer Rating',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        ..._ratings.map(
          (rating) => CheckboxListTile(
            title: Text(rating),
            value:
                (_filters['ratings'] as List<String>? ?? []).contains(rating),
            onChanged: (selected) {
              setState(() {
                final ratings =
                    (_filters['ratings'] as List<String>? ?? []).toList();
                if (selected == true) {
                  ratings.add(rating);
                } else {
                  ratings.remove(rating);
                }
                _filters['ratings'] = ratings;
              });
            },
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Availability',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        SwitchListTile(
          title: const Text('In Stock Only'),
          value: _filters['inStockOnly'] ?? false,
          onChanged: (value) {
            setState(() {
              _filters['inStockOnly'] = value;
            });
          },
          dense: true,
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          title: const Text('Free Shipping'),
          value: _filters['freeShipping'] ?? false,
          onChanged: (value) {
            setState(() {
              _filters['freeShipping'] = value;
            });
          },
          dense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildFooter() {
    final filterCount = _getActiveFilterCount();

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                widget.onFiltersChanged(_filters);
                Navigator.pop(context);
              },
              child: Text('Apply${filterCount > 0 ? ' ($filterCount)' : ''}'),
            ),
          ),
        ],
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _filters.clear();
      _priceRange = const RangeValues(0, 2000);
    });
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (_filters['minPrice'] != null && _filters['minPrice'] > 0) count++;
    if (_filters['maxPrice'] != null && _filters['maxPrice'] < 2000) count++;
    if ((_filters['categories'] as List<String>? ?? []).isNotEmpty) count++;
    if ((_filters['brands'] as List<String>? ?? []).isNotEmpty) count++;
    if ((_filters['ratings'] as List<String>? ?? []).isNotEmpty) count++;
    if (_filters['inStockOnly'] == true) count++;
    if (_filters['freeShipping'] == true) count++;
    return count;
  }
}
