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
    // TODO: Add your other routes here
  };
}
