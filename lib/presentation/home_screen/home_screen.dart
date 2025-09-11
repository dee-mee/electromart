import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_grid_widget.dart';
import './widgets/hero_banner_widget.dart';
import './widgets/product_section_widget.dart';
import './widgets/search_header_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _showNotificationBanner = true;
  int _currentBottomNavIndex = 0;

  // Mock data for different product sections
  final List<Map<String, dynamic>> _newArrivals = [
    {
      "id": 1,
      "name": "iPhone 15 Pro Max",
      "price": 1199.0,
      "rating": 4.8,
      "reviews": 2847,
      "image":
          "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 2,
      "name": "Samsung Galaxy S24 Ultra",
      "price": 1299.0,
      "rating": 4.7,
      "reviews": 1923,
      "image":
          "https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 3,
      "name": "Google Pixel 8 Pro",
      "price": 999.0,
      "rating": 4.6,
      "reviews": 1456,
      "image":
          "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
  ];

  final List<Map<String, dynamic>> _trendingPhones = [
    {
      "id": 4,
      "name": "OnePlus 12",
      "price": 799.0,
      "rating": 4.5,
      "reviews": 892,
      "image":
          "https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 5,
      "name": "Xiaomi 14 Ultra",
      "price": 899.0,
      "rating": 4.4,
      "reviews": 743,
      "image":
          "https://images.unsplash.com/photo-1567581935884-3349723552ca?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 6,
      "name": "Nothing Phone (2a)",
      "price": 349.0,
      "rating": 4.3,
      "reviews": 567,
      "image":
          "https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
  ];

  final List<Map<String, dynamic>> _audioDeals = [
    {
      "id": 7,
      "name": "AirPods Pro 2nd Gen",
      "price": 249.0,
      "rating": 4.9,
      "reviews": 3421,
      "image":
          "https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 8,
      "name": "Sony WH-1000XM5",
      "price": 399.0,
      "rating": 4.8,
      "reviews": 2156,
      "image":
          "https://images.unsplash.com/photo-1583394838336-acd977736f90?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 9,
      "name": "Bose QuietComfort Earbuds",
      "price": 279.0,
      "rating": 4.7,
      "reviews": 1834,
      "image":
          "https://images.unsplash.com/photo-1590658268037-6bf12165a8df?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
  ];

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
    _showWelcomeNotification();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      // Handle scroll position for potential features like hiding/showing elements
    });
  }

  void _showWelcomeNotification() {
    // Simulate a push notification banner
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showNotificationBanner = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          if (_showNotificationBanner) _buildNotificationBanner(),
          const SearchHeaderWidget(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              color: AppTheme.secondaryLight,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HeroBannerWidget(),
                        ProductSectionWidget(
                          title: "New Arrivals",
                          seeAllRoute: "/product-catalog",
                          products: _newArrivals,
                        ),
                        const CategoryGridWidget(),
                        ProductSectionWidget(
                          title: "Trending Phones",
                          seeAllRoute: "/product-catalog",
                          products: _trendingPhones,
                        ),
                        ProductSectionWidget(
                          title: "Audio Deals",
                          seeAllRoute: "/product-catalog",
                          products: _audioDeals,
                        ),
                        SizedBox(height: 10.h), // Bottom padding for navigation
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildNotificationBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentLight,
            AppTheme.accentLight.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'local_offer',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                "🎉 New Year Sale! Up to 50% off on selected items",
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showNotificationBanner = false;
                });
              },
              child: CustomIconWidget(
                iconName: 'close',
                color: Colors.white,
                size: 5.w,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 8.h,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, 'home', 'Home', '/home-screen'),
              _buildNavItem(1, 'category', 'Categories', '/product-catalog'),
              _buildNavItem(2, 'search', 'Search', '/search-results'),
              _buildNavItem(3, 'person', 'Profile', '/user-profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String iconName, String label, String route) {
    final isSelected = _currentBottomNavIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentBottomNavIndex = index;
        });
        if (route != '/home-screen') {
          Navigator.pushNamed(context, route);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, '/search-results');
      },
      backgroundColor: AppTheme.accentLight,
      child: CustomIconWidget(
        iconName: 'search',
        color: Colors.white,
        size: 6.w,
      ),
    );
  }

  Future<void> _handleRefresh() async {
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Content refreshed successfully!"),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
