import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:sizer/sizer.dart';


import './widgets/avatar_edit_bottom_sheet_widget.dart';
import './widgets/order_history_card_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/profile_section_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  // Mock user data
  String _userName = "Sarah Johnson";
  String _userEmail = "sarah.johnson@email.com";
  String _avatarUrl =
      "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face";

  // Mock order history data
  final List<Map<String, dynamic>> _orderHistory = [
    {
      "id": "ORD001",
      "productName": "iPhone 15 Pro Max",
      "status": "Delivered",
      "date": "Dec 28, 2024",
      "price": "\$1,199.00",
      "imageUrl":
          "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400&h=400&fit=crop",
    },
    {
      "id": "ORD002",
      "productName": "AirPods Pro (2nd Gen)",
      "status": "Shipped",
      "date": "Jan 2, 2025",
      "price": "\$249.00",
      "imageUrl":
          "https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=400&h=400&fit=crop",
    },
    {
      "id": "ORD003",
      "productName": "Samsung Galaxy Buds2 Pro",
      "status": "Processing",
      "date": "Jan 5, 2025",
      "price": "\$229.99",
      "imageUrl":
          "https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400&h=400&fit=crop",
    },
  ];

  // Mock notification settings
  bool _orderNotifications = true;
  bool _offerNotifications = true;
  bool _updateNotifications = false;
  bool _biometricAuth = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  

  void _showAvatarEditBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AvatarEditBottomSheetWidget(
        onImageSelected: (String imagePath) {
          setState(() {
            _avatarUrl = imagePath;
          });
        },
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Sign Out',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to sign out of your account?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/authentication-screen');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Sign Out',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoTab() {
    return SingleChildScrollView(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 2.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  ProfileSectionWidget(
                    title: "Personal Information",
                    iconName: "person",
                    subtitle: "Name, email, phone number",
                    onTap: () {
                      launchUrl(Uri.parse('https://google.com'));
                    },
                  ),
                  ProfileSectionWidget(
                    title: "Payment Methods",
                    iconName: "credit_card",
                    subtitle: "Manage saved cards",
                    trailingText: "2 cards",
                    onTap: () {
                      launchUrl(Uri.parse('https://google.com'));
                    },
                  ),
                  ProfileSectionWidget(
                    title: "Addresses",
                    iconName: "location_on",
                    subtitle: "Shipping and billing addresses",
                    trailingText: "3 addresses",
                    onTap: () {
                      launchUrl(Uri.parse('https://google.com'));
                    },
                    showDivider: false,
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Row(
                      children: [
                        Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.secondary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'notifications',
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              size: 5.w,
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notifications',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                'Manage notification preferences',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    thickness: 0.5,
                    indent: 4.w,
                    endIndent: 4.w,
                  ),
                  _buildNotificationSetting(
                      "Order Updates", _orderNotifications, (value) {
                    setState(() => _orderNotifications = value);
                  }),
                  _buildNotificationSetting(
                      "Offers & Promotions", _offerNotifications, (value) {
                    setState(() => _offerNotifications = value);
                  }),
                  _buildNotificationSetting("App Updates", _updateNotifications,
                      (value) {
                    setState(() => _updateNotifications = value);
                  }),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Row(
                      children: [
                        Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.secondary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'settings',
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              size: 5.w,
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'App Settings',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                'Security and privacy controls',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    thickness: 0.5,
                    indent: 4.w,
                    endIndent: 4.w,
                  ),
                  _buildNotificationSetting(
                      "Biometric Authentication", _biometricAuth, (value) {
                    setState(() => _biometricAuth = value);
                  }),
                  ProfileSectionWidget(
                    title: "Language",
                    iconName: "language",
                    trailingText: "English",
                    onTap: () {
                      launchUrl(Uri.parse('https://google.com'));
                    },
                  ),
                  ProfileSectionWidget(
                    title: "Privacy Policy",
                    iconName: "privacy_tip",
                    onTap: () {
                      launchUrl(Uri.parse('https://google.com'));
                    },
                    showDivider: false,
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showSignOutDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
                child: Text(
                  'Sign Out',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHistoryTab() {
    return _orderHistory.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'shopping_bag',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 15.w,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'No orders yet',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Start shopping to see your orders here',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: _orderHistory.length,
              itemBuilder: (context, index) {
                final order = _orderHistory[index];
                return OrderHistoryCardWidget(
                  order: order,
                  onTrackOrder: () => Navigator.pushNamed(context, '/track-order-screen'),
                  onReorder: () => Navigator.pushNamed(context, '/reorder-screen'),
                  onReview: () => Navigator.pushNamed(context, '/review-product-screen'),
                );
              },
            ),
    );
  }

  Widget _buildNotificationSetting(
      String title, bool value, Function(bool) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.lightTheme.colorScheme.secondary,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            ProfileHeaderWidget(
              userName: _userName,
              userEmail: _userEmail,
              avatarUrl: _avatarUrl,
              onEditAvatar: _showAvatarEditBottomSheet,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                indicatorPadding: EdgeInsets.all(1.w),
                labelColor: AppTheme.lightTheme.colorScheme.secondary,
                unselectedLabelColor:
                    AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                labelStyle: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle:
                    AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'person',
                          color: _tabController.index == 0
                              ? AppTheme.lightTheme.colorScheme.secondary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 4.w,
                        ),
                        SizedBox(width: 2.w),
                        Text('Profile'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'shopping_bag',
                          color: _tabController.index == 1
                              ? AppTheme.lightTheme.colorScheme.secondary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 4.w,
                        ),
                        SizedBox(width: 2.w),
                        Text('Orders'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPersonalInfoTab(),
                  _buildOrderHistoryTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
