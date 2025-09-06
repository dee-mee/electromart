import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _fadeController;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;

  bool _isLoading = true;
  String _statusText = 'Loading...';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoScale = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _textFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _logoController.forward();

    Future.delayed(const Duration(milliseconds: 800), () {
      _fadeController.forward();
    });
  }

  Future<void> _startSplashSequence() async {
    try {
      // Simulate app initialization tasks
      await _performInitializationTasks();

      // Wait for animations to complete
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        await _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusText = 'Loading error. Tap to retry';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _performInitializationTasks() async {
    // Task 1: Check authentication
    if (mounted) {
      setState(() => _statusText = 'Checking authentication...');
    }
    await Future.delayed(const Duration(milliseconds: 600));

    // Task 2: Preload critical data
    if (mounted) {
      setState(() => _statusText = 'Loading data...');
    }
    await Future.delayed(const Duration(milliseconds: 800));

    // Task 3: System initialization
    if (mounted) {
      setState(() => _statusText = 'Initializing...');
    }
    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      setState(() => _statusText = 'Ready!');
    }
  }

  Future<void> _navigateToNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedOnboarding =
        prefs.getBool('has_completed_onboarding') ?? false;

    if (mounted) {
      if (hasCompletedOnboarding) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.onboardingFlow);
      }
    }
  }

  Future<void> _retryInitialization() async {
    setState(() {
      _isLoading = true;
      _statusText = 'Loading...';
    });
    await _startSplashSequence();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withAlpha(204),
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Animated Logo
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoScale.value,
                      child: Opacity(
                        opacity: _logoFade.value,
                        child: Container(
                          width: 120.0,
                          height: 120.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(26),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/images/img_app_logo.svg',
                              width: 80.0,
                              height: 80.0,
                              colorFilter: ColorFilter.mode(
                                Theme.of(context).primaryColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 4.h),

                // App Name
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoFade.value,
                      child: Text(
                        'ElectroMart',
                        style: GoogleFonts.inter(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 1.h),

                // Tagline
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoFade.value,
                      child: Text(
                        'Your Electronics Destination',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: Colors.white.withAlpha(230),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  },
                ),

                const Spacer(flex: 2),

                // Loading Section
                AnimatedBuilder(
                  animation: _textFade,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _textFade.value,
                      child: Column(
                        children: [
                          if (_isLoading) ...[
                            SizedBox(
                              width: 24.0,
                              height: 24.0,
                              child: CircularProgressIndicator(
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                                strokeWidth: 2.5,
                              ),
                            ),
                            SizedBox(height: 2.h),
                          ],
                          GestureDetector(
                            onTap: _isLoading ? null : _retryInitialization,
                            child: Text(
                              _statusText,
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: Colors.white.withAlpha(204),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                SizedBox(height: 8.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
