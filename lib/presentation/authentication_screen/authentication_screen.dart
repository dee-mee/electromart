import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/auth_form_widget.dart';
import './widgets/auth_toggle_widget.dart';
import './widgets/social_login_widget.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool _isLogin = true;
  bool _isLoading = false;

  // Mock credentials for testing
  final Map<String, dynamic> _mockCredentials = {
    'admin': {
      'email': 'admin@electromart.com',
      'password': 'admin123',
      'name': 'Admin User',
      'role': 'admin'
    },
    'customer': {
      'email': 'customer@electromart.com',
      'password': 'customer123',
      'name': 'John Customer',
      'role': 'customer'
    },
    'manager': {
      'email': 'manager@electromart.com',
      'password': 'manager123',
      'name': 'Store Manager',
      'role': 'manager'
    }
  };

  void _toggleAuthMode(bool isLogin) {
    if (_isLogin != isLogin && !_isLoading) {
      setState(() {
        _isLogin = isLogin;
      });
    }
  }

  Future<void> _handleAuthentication(
      String email, String password, String? confirmPassword) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      if (_isLogin) {
        // Login logic
        bool isValidCredentials = false;
        String userName = '';

        for (var userType in _mockCredentials.keys) {
          var credentials = _mockCredentials[userType];
          if (credentials['email'] == email &&
              credentials['password'] == password) {
            isValidCredentials = true;
            userName = credentials['name'];
            break;
          }
        }

        if (isValidCredentials) {
          // Success haptic feedback
          HapticFeedback.lightImpact();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Welcome back, $userName!'),
                backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                behavior: SnackBarBehavior.floating,
              ),
            );

            // Navigate to home screen
            Navigator.pushReplacementNamed(context, '/home-screen');
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                    'Invalid email or password. Please check your credentials.'),
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      } else {
        // Registration logic
        if (password == confirmPassword) {
          // Success haptic feedback
          HapticFeedback.lightImpact();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    const Text('Account created successfully! Please sign in.'),
                backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                behavior: SnackBarBehavior.floating,
              ),
            );

            // Switch to login mode
            setState(() {
              _isLogin = true;
            });
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    const Text('Passwords do not match. Please try again.'),
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Network error. Please check your connection and try again.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleSocialLogin(String provider) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate social login delay
      await Future.delayed(const Duration(seconds: 1));

      // Success haptic feedback
      HapticFeedback.lightImpact();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${provider.toUpperCase()} login successful!'),
            backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Navigate to home screen
        Navigator.pushReplacementNamed(context, '/home-screen');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${provider.toUpperCase()} login failed. Please try again.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            // Dismiss keyboard when tapping outside
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 4.h),

                    // App Logo
                    Center(
                      child: Container(
                        width: 25.w,
                        height: 25.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'shopping_bag',
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                size: 8.w,
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'EM',
                                style: AppTheme.lightTheme.textTheme.titleLarge
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Welcome Text
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Welcome to ElectroMart',
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            _isLogin
                                ? 'Sign in to your account to continue shopping'
                                : 'Create your account to start shopping',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Auth Toggle
                    AuthToggleWidget(
                      isLogin: _isLogin,
                      onToggle: _toggleAuthMode,
                    ),

                    SizedBox(height: 3.h),

                    // Auth Form
                    AuthFormWidget(
                      isLogin: _isLogin,
                      onSubmit: _handleAuthentication,
                      isLoading: _isLoading,
                    ),

                    SizedBox(height: 4.h),

                    // Social Login
                    SocialLoginWidget(
                      isLoading: _isLoading,
                      onSocialLogin: _handleSocialLogin,
                    ),

                    SizedBox(height: 4.h),

                    // Terms and Privacy
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          children: [
                            const TextSpan(
                                text: 'By continuing, you agree to our '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color:
                                    AppTheme.lightTheme.colorScheme.secondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color:
                                    AppTheme.lightTheme.colorScheme.secondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
