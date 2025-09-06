import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialLoginWidget extends StatelessWidget {
  final bool isLoading;
  final Function(String provider) onSocialLogin;

  const SocialLoginWidget({
    Key? key,
    required this.isLoading,
    required this.onSocialLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.dividerColor,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Or continue with',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.dividerColor,
                thickness: 1,
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        // Social Login Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Google Login
            _SocialLoginButton(
              onPressed: isLoading ? null : () => onSocialLogin('google'),
              icon: 'g_translate',
              label: 'Google',
              backgroundColor: Colors.white,
              borderColor: AppTheme.lightTheme.dividerColor,
              textColor: AppTheme.lightTheme.colorScheme.onSurface,
            ),

            // Apple Login (iOS only)
            if (defaultTargetPlatform == TargetPlatform.iOS || kIsWeb)
              _SocialLoginButton(
                onPressed: isLoading ? null : () => onSocialLogin('apple'),
                icon: 'apple',
                label: 'Apple',
                backgroundColor: Colors.black,
                borderColor: Colors.black,
                textColor: Colors.white,
              ),

            // Facebook Login
            _SocialLoginButton(
              onPressed: isLoading ? null : () => onSocialLogin('facebook'),
              icon: 'facebook',
              label: 'Facebook',
              backgroundColor: const Color(0xFF1877F2),
              borderColor: const Color(0xFF1877F2),
              textColor: Colors.white,
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String icon;
  final String label;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const _SocialLoginButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 6.h,
        margin: EdgeInsets.symmetric(horizontal: 1.w),
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: backgroundColor,
            side: BorderSide(color: borderColor, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 2.w),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: icon,
                color: textColor,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Flexible(
                child: Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
