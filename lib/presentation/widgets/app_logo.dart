import 'package:flutter/material.dart';
import 'package:calories_tracker/core/theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final bool showText;
  final Color? textColor;

  const AppLogo({
    super.key,
    this.width,
    this.height,
    this.showText = false,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width ?? 80,
          height: height ?? 80,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppColors.softShadow,
          ),
          child: const Icon(
            Icons.restaurant_menu,
            color: AppColors.cardBackground,
            size: 40,
          ),
        ),

        if (showText) ...[
          const SizedBox(height: 8),
          Text(
            'Calories Tracker',
            style: AppTextStylesHelper.h4(context).copyWith(
              color: textColor ?? AppTextStylesHelper.textPrimary(context),
            ),
          ),
        ],
      ],
    );
  }
}

class CustomImageLogo extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final bool showText;
  final Color? textColor;

  const CustomImageLogo({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.showText = false,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width ?? 80,
          height: height ?? 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppColors.softShadow,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              imagePath,
              width: width ?? 80,
              height: height ?? 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return AppLogo(
                  width: width,
                  height: height,
                  showText: false,
                  textColor: textColor,
                );
              },
            ),
          ),
        ),

        if (showText) ...[
          const SizedBox(height: 8),
          Text(
            'CaloriesTracker',
            style: AppTextStylesHelper.h4(context).copyWith(
              color: textColor ?? AppTextStylesHelper.textPrimary(context),
            ),
          ),
        ],
      ],
    );
  }
}
