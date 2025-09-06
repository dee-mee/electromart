import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class FilterModalWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterModalWidget({
    Key? key,
    required this.currentFilters,
    required this.onFiltersApplied,
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
    'Accessories',
  ];

  final List<String> _brands = [
    'Apple',
    'Samsung',
    'Sony',
    'Bose',
    'JBL',
    'OnePlus',
    'Google',
    'Xiaomi',
  ];

  final List<String> _features = [
    'Wireless',
    'Noise Cancelling',
    'Water Resistant',
    'Fast Charging',
    '5G Compatible',
    'Bluetooth 5.0+',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
    _priceRange = RangeValues(
      (_filters['minPrice'] as double?) ?? 0,
      (_filters['maxPrice'] as double?) ?? 2000,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Filters",
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _clearAllFilters,
            child: Text(
              "Clear All",
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategorySection(),
                  const SizedBox(height: 24),
                  _buildPriceRangeSection(),
                  const SizedBox(height: 24),
                  _buildBrandSection(),
                  const SizedBox(height: 24),
                  _buildFeaturesSection(),
                  const SizedBox(height: 24),
                  _buildRatingSection(),
                ],
              ),
            ),
          ),
          _buildApplyButton(),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return _buildExpandableSection(
      title: "Category",
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _categories.map((category) {
          final isSelected =
              (_filters['categories'] as List<String>?)?.contains(category) ??
                  false;
          return _buildFilterChip(
            label: category,
            isSelected: isSelected,
            onTap: () => _toggleFilter('categories', category),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPriceRangeSection() {
    return _buildExpandableSection(
      title: "Price Range",
      child: Column(
        children: [
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 2000,
            divisions: 40,
            labels: RangeLabels(
              "\$${_priceRange.start.round()}",
              "\$${_priceRange.end.round()}",
            ),
            onChanged: (values) {
              setState(() {
                _priceRange = values;
                _filters['minPrice'] = values.start;
                _filters['maxPrice'] = values.end;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "\$${_priceRange.start.round()}",
                style: AppTheme.lightTheme.textTheme.labelMedium,
              ),
              Text(
                "\$${_priceRange.end.round()}",
                style: AppTheme.lightTheme.textTheme.labelMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBrandSection() {
    return _buildExpandableSection(
      title: "Brand",
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _brands.map((brand) {
          final isSelected =
              (_filters['brands'] as List<String>?)?.contains(brand) ?? false;
          return _buildFilterChip(
            label: brand,
            isSelected: isSelected,
            onTap: () => _toggleFilter('brands', brand),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return _buildExpandableSection(
      title: "Features",
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _features.map((feature) {
          final isSelected =
              (_filters['features'] as List<String>?)?.contains(feature) ??
                  false;
          return _buildFilterChip(
            label: feature,
            isSelected: isSelected,
            onTap: () => _toggleFilter('features', feature),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRatingSection() {
    return _buildExpandableSection(
      title: "Customer Rating",
      child: Column(
        children: [4, 3, 2, 1].map((rating) {
          final isSelected = (_filters['minRating'] as int?) == rating;
          return GestureDetector(
            onTap: () {
              setState(() {
                _filters['minRating'] = isSelected ? null : rating;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.secondary
                      : AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
              child: Row(
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return CustomIconWidget(
                        iconName: index < rating ? 'star' : 'star_border',
                        color: index < rating
                            ? Colors.amber
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 16,
                      );
                    }),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "$rating & up",
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.secondary
                          : AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.secondary
                : AppTheme.lightTheme.colorScheme.outline,
          ),
        ),
        child: Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.secondary
                : AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            widget.onFiltersApplied(_filters);
            Navigator.pop(context);
          },
          child: Text("Apply Filters"),
        ),
      ),
    );
  }

  void _toggleFilter(String filterType, String value) {
    setState(() {
      if (_filters[filterType] == null) {
        _filters[filterType] = <String>[];
      }

      final List<String> currentList =
          List<String>.from(_filters[filterType] as List);
      if (currentList.contains(value)) {
        currentList.remove(value);
      } else {
        currentList.add(value);
      }
      _filters[filterType] = currentList;
    });
  }

  void _clearAllFilters() {
    setState(() {
      _filters.clear();
      _priceRange = const RangeValues(0, 2000);
    });
  }
}
