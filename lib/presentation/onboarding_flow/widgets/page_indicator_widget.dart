import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PageIndicatorWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const PageIndicatorWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        totalPages,
        (index) => _buildDot(context, index),
      ),
    );
  }

  Widget _buildDot(BuildContext context, int index) {
    final isActive = index == currentPage;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isActive ? 24.0 : 8.0,
      height: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 0.5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: isActive
            ? Theme.of(context).primaryColor
            : Theme.of(context).colorScheme.onSurface.withAlpha(77),
      ),
    );
  }
}
