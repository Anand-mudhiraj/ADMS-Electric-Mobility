import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// ADMS Logo rendered in pure Flutter (no external image needed initially).
/// Replace with actual SVG/image asset once client provides branding files.
class AdmsLogo extends StatelessWidget {
  final double height;
  final bool showTagline;

  const AdmsLogo({super.key, this.height = 40, this.showTagline = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo mark — stylised A
            Container(
              width: height,
              height: height,
              decoration: BoxDecoration(
                color: AppColors.accentLime,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  'A',
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: height * 0.68,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textInverse,
                    height: 1.0,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Wordmark
            Text(
              'ADMS',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: height * 0.70,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: 2.0,
                height: 1.0,
              ),
            ),
          ],
        ),
        if (showTagline) ...[
          const SizedBox(height: 4),
          Text(
            'ELECTRIC MOBILITY',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: height * 0.22,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
              letterSpacing: 3.0,
            ),
          ),
        ],
      ],
    );
  }
}
