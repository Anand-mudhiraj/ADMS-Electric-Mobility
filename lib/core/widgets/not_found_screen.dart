import 'package:flutter/material.dart';
import '../theme/theme.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('404', style: AppTextStyles.displayLarge.copyWith(
              color: AppColors.accentLime,
            )),
            const SizedBox(height: 16),
            Text('Page not found', style: AppTextStyles.headingMedium),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
