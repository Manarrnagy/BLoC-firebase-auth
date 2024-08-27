import 'package:flutter/material.dart';
import 'package:task_one_think/utils/app_colors.dart';
class AppConstants{
  final APP_GRADIENT = LinearGradient(
    colors: [
      AppColors.pink.withAlpha(80),
      Colors.white.withAlpha(2),
      AppColors.orange.withAlpha(80)
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomLeft,
  );

}