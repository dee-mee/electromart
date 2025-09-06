import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HeroBannerWidget extends StatefulWidget {
  const HeroBannerWidget({super.key});

  @override
  State<HeroBannerWidget> createState() => _HeroBannerWidgetState();
}

class _HeroBannerWidgetState extends State<HeroBannerWidget> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  final List<Map<String, dynamic>> _bannerData = [
    {
      "id": 1,
      "title": "iPhone 15 Pro Max",
      "subtitle": "Titanium. So strong. So light. So Pro.",
      "discount": "Up to \$200 off",
      "image":
          "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "backgroundColor": Color(0xFF1A1A1A),
      "textColor": Colors.white,
    },
    {
      "id": 2,
      "title": "Samsung Galaxy S24 Ultra",
      "subtitle": "Galaxy AI is here",
      "discount": "Save \$150 today",
      "image":
          "https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "backgroundColor": Color(0xFF4A90E2),
      "textColor": Colors.white,
    },
    {
      "id": 3,
      "title": "AirPods Pro 2nd Gen",
      "subtitle": "Adaptive Audio. Now playing.",
      "discount": "Limited time offer",
      "image":
          "https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "backgroundColor": Color(0xFFFF6B35),
      "textColor": Colors.white,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _carouselController.nextPage();
        _startAutoSlide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 25.h,
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        children: [
          Expanded(
            child: CarouselSlider.builder(
              carouselController: _carouselController,
              itemCount: _bannerData.length,
              itemBuilder: (context, index, realIndex) {
                final banner = _bannerData[index];
                return _buildBannerCard(banner);
              },
              options: CarouselOptions(
                height: double.infinity,
                viewportFraction: 0.9,
                enlargeCenterPage: true,
                autoPlay: false,
                enableInfiniteScroll: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 1.h),
          _buildIndicators(),
        ],
      ),
    );
  }

  Widget _buildBannerCard(Map<String, dynamic> banner) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 1.w),
      decoration: BoxDecoration(
        color: banner["backgroundColor"] as Color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned(
              right: -10.w,
              top: -5.h,
              child: CustomImageWidget(
                imageUrl: banner["image"] as String,
                width: 50.w,
                height: 30.h,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    (banner["backgroundColor"] as Color).withValues(alpha: 0.9),
                    (banner["backgroundColor"] as Color).withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    banner["title"] as String,
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      color: banner["textColor"] as Color,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    banner["subtitle"] as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color:
                          (banner["textColor"] as Color).withValues(alpha: 0.8),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.accentLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      banner["discount"] as String,
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _bannerData.asMap().entries.map((entry) {
        return Container(
          width: _currentIndex == entry.key ? 8.w : 2.w,
          height: 1.h,
          margin: EdgeInsets.symmetric(horizontal: 0.5.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: _currentIndex == entry.key
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
          ),
        );
      }).toList(),
    );
  }
}
