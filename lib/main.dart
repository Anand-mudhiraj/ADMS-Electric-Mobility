import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/routing/app_router.dart';
import 'core/theme/theme.dart';

void main() {
  runApp(const AdmsShowroomApp());
}

class AdmsShowroomApp extends StatelessWidget {
  const AdmsShowroomApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Merge Google Fonts (Inter for body) into the ADMS dark theme.
    final baseTheme = AppTheme.darkTheme;
    final theme = baseTheme.copyWith(
      textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme),
    );

    return MaterialApp.router(
      title: 'ADMS Electric Mobility — 3D Showroom',
      debugShowCheckedModeBanner: false,
      theme: theme,
      routerConfig: AppRouter.router,
    );
  }
}
