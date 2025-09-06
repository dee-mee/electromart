import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ProductVariantsSection extends StatefulWidget {
  final List<Map<String, dynamic>> colors;
  final List<Map<String, dynamic>> storage;
  final Function(String colorId, String storageId) onVariantChanged;

  const ProductVariantsSection({
    Key? key,
    required this.colors,
    required this.storage,
    required this.onVariantChanged,
  }) : super(key: key);

  @override
  State<ProductVariantsSection> createState() => _ProductVariantsSectionState();
}

class _ProductVariantsSectionState extends State<ProductVariantsSection> {
  String selectedColorId = '';
  String selectedStorageId = '';

  @override
  void initState() {
    super.initState();
    if (widget.colors.isNotEmpty) {
      selectedColorId = widget.colors.first['id'] as String;
    }
    if (widget.storage.isNotEmpty) {
      selectedStorageId = widget.storage.first['id'] as String;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.colors.isNotEmpty) ...[
            Text(
              'Color',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.5.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: widget.colors.map((color) {
                final bool isSelected = selectedColorId == color['id'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColorId = color['id'] as String;
                    });
                    widget.onVariantChanged(selectedColorId, selectedStorageId);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(2.h),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      color['name'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 3.h),
          ],
          if (widget.storage.isNotEmpty) ...[
            Text(
              'Storage',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.5.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: widget.storage.map((storage) {
                final bool isSelected = selectedStorageId == storage['id'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedStorageId = storage['id'] as String;
                    });
                    widget.onVariantChanged(selectedColorId, selectedStorageId);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(2.h),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          storage['size'] as String,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.onPrimary
                                : AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (storage['priceExtra'] != null &&
                            (storage['priceExtra'] as double) > 0)
                          Text(
                            '+\$${(storage['priceExtra'] as double).toStringAsFixed(0)}',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.onPrimary
                                      .withValues(alpha: 0.8)
                                  : AppTheme.lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
