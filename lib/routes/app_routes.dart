import '../presentation/review_product_screen/review_product_screen.dart';
import '../presentation/reorder_screen/reorder_screen.dart';
import '../presentation/track_order_screen/track_order_screen.dart';
import 'package:flutter/material.dart';
import '../presentation/product_detail/product_detail.dart';
import '../presentation/search_results/search_results.dart';
import '../presentation/user_profile/user_profile.dart';
import '../presentation/authentication_screen/authentication_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/product_catalog/product_catalog.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/shopping_cart/shopping_cart.dart';
import '../presentation/personal_info_screen/personal_info_screen.dart';
import '../presentation/payment_methods_screen/payment_methods_screen.dart';
import '../presentation/addresses_screen/addresses_screen.dart';
import '../presentation/language_screen/language_screen.dart';
import '../presentation/privacy_policy_screen/privacy_policy_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/splash-screen';
  static const String splashScreen = '/splash-screen';
  static const String onboardingFlow = '/onboarding-flow';
  static const String productDetail = '/product-detail';
  static const String searchResults = '/search-results';
  static const String userProfile = '/user-profile';
  static const String authentication = '/authentication-screen';
  static const String home = '/home-screen';
  static const String productCatalog = '/product-catalog';
  static const String shoppingCart = '/shopping-cart';
  static const String trackOrderScreen = '/track-order-screen';
  static const String reorderScreen = '/reorder-screen';
  static const String reviewProductScreen = '/review-product-screen';
  static const String personalInfoScreen = '/personal-info-screen';
  static const String paymentMethodsScreen = '/payment-methods-screen';
  static const String addressesScreen = '/addresses-screen';
  static const String languageScreen = '/language-screen';
  static const String privacyPolicyScreen = '/privacy-policy-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    productDetail: (context) => ProductDetail(),
    searchResults: (context) => const SearchResults(),
    userProfile: (context) => const UserProfile(),
    authentication: (context) => const AuthenticationScreen(),
    home: (context) => const HomeScreen(),
    productCatalog: (context) => const ProductCatalog(),
    shoppingCart: (context) => const ShoppingCart(),
    trackOrderScreen: (context) => const TrackOrderScreen(),
    reorderScreen: (context) => const ReorderScreen(),
    reviewProductScreen: (context) => const ReviewProductScreen(),
    personalInfoScreen: (context) => const PersonalInfoScreen(),
    paymentMethodsScreen: (context) => const PaymentMethodsScreen(),
    addressesScreen: (context) => const AddressesScreen(),
    languageScreen: (context) => const LanguageScreen(),
    privacyPolicyScreen: (context) => const PrivacyPolicyScreen(),
    // TODO: Add your other routes here
  };
}