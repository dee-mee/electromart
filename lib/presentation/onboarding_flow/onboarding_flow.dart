import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLastPage = false;

  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      title: 'Discover Amazing Products',
      description:
          'Explore thousands of electronics with our powerful search and barcode scanner feature.',
      imageUrl:
          'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
      features: [
        'Smart search functionality',
        'Barcode scanner integration',
        'Category-based browsing',
      ],
    ),
    OnboardingPageData(
      title: 'Personalized for You',
      description:
          'Get tailored recommendations based on your preferences and shopping history.',
      imageUrl:
          'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2340&q=80',
      features: [
        'AI-powered recommendations',
        'Wishlist and favorites',
        'Price tracking alerts',
      ],
    ),
    OnboardingPageData(
      title: 'Secure & Fast Checkout',
      description:
          'Shop with confidence using our secure payment system and fast delivery options.',
      imageUrl:
          'https://images.unsplash.com/photo-1563013544-824ae1b704d3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
      features: [
        'Multiple payment options',
        'Order tracking',
        'Fast delivery network',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // Simulate permission requests that would be needed for the app
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      _isLastPage = page == _pages.length - 1;
    });

    // Haptic feedback for page transitions
    HapticFeedback.lightImpact();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_onboarding', true);

    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  void _nextPage() {
    if (_isLastPage) {
      _completeOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _goToAuthentication() {
    Navigator.pushReplacementNamed(context, AppRoutes.authentication);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with Skip button
            _buildHeader(),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPageWidget(
                    pageData: _pages[index],
                    isActive: index == _currentPage,
                  );
                },
              ),
            ),

            // Bottom Section
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button (only show after first page)
          SizedBox(
            width: 60,
            child: _currentPage > 0
                ? TextButton(
                    onPressed: _previousPage,
                    child: Text(
                      'Back',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : null,
          ),

          // Page Indicator
          PageIndicatorWidget(
            currentPage: _currentPage,
            totalPages: _pages.length,
          ),

          // Skip button (hide on last page)
          SizedBox(
            width: 60,
            child: !_isLastPage
                ? TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      'Skip',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(153),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      child: Column(
        children: [
          // Main Action Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                elevation: 2,
                shadowColor: Theme.of(context).primaryColor.withAlpha(77),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                _isLastPage ? 'Get Started' : 'Next',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Already have account link (show on last page)
          if (_isLastPage)
            TextButton(
              onPressed: _goToAuthentication,
              child: RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(179),
                  ),
                  children: [
                    TextSpan(
                      text: 'Sign In',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class OnboardingPageData {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> features;

  OnboardingPageData({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.features,
  });
}
