import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../onboarding_flow.dart';

class OnboardingPageWidget extends StatefulWidget {
  final OnboardingPageData pageData;
  final bool isActive;

  const OnboardingPageWidget({
    super.key,
    required this.pageData,
    required this.isActive,
  });

  @override
  State<OnboardingPageWidget> createState() => _OnboardingPageWidgetState();
}

class _OnboardingPageWidgetState extends State<OnboardingPageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    if (widget.isActive) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(OnboardingPageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // Hero Image with Animation
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: _buildHeroImage(),
                ),
              );
            },
          ),

          SizedBox(height: 6.h),

          // Content Section
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildContent(),
                ),
              );
            },
          ),

          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withAlpha(26),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: CachedNetworkImage(
          imageUrl: widget.pageData.imageUrl,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Title
        Text(
          widget.pageData.title,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
            height: 1.2,
          ),
        ),

        SizedBox(height: 2.h),

        // Description
        Text(
          widget.pageData.description,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(179),
            height: 1.5,
          ),
        ),

        SizedBox(height: 4.h),

        // Features List
        _buildFeaturesList(),
      ],
    );
  }

  Widget _buildFeaturesList() {
    return Column(
      children: widget.pageData.features.asMap().entries.map((entry) {
        final index = entry.key;
        final feature = entry.value;

        return Container(
          margin: EdgeInsets.only(bottom: 1.5.h),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(
                    0.4 + (index * 0.1),
                    0.8 + (index * 0.1),
                    curve: Curves.easeOut,
                  ),
                )),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-0.3, 0.0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(
                      0.4 + (index * 0.1),
                      0.8 + (index * 0.1),
                      curve: Curves.easeOutCubic,
                    ),
                  )),
                  child: _buildFeatureItem(feature),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check,
            size: 14,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            feature,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(204),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
