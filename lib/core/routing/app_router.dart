import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/catalogue/presentation/catalogue_screen.dart';
import '../../features/scooter_details/presentation/scooter_detail_screen.dart';
import '../../features/showroom_3d/presentation/showroom_3d_screen.dart';
import '../../features/comparison/presentation/comparison_screen.dart';
import '../../features/enquiries/presentation/enquiry_screen.dart';
import '../../features/authentication/presentation/login_screen.dart';
import '../../features/admin/dashboard/presentation/admin_dashboard_screen.dart';
import '../../features/admin/scooters/presentation/admin_scooters_screen.dart';
import '../../features/admin/scooters/presentation/admin_add_scooter_screen.dart';
import '../../features/admin/enquiries/presentation/admin_enquiries_screen.dart';
import '../widgets/not_found_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String catalogue = '/models';
  static const String scooterDetail = '/models/:slug';
  static const String showroom3d = '/models/:slug/3d';
  static const String comparison = '/compare';
  static const String enquiry = '/enquiry';
  static const String testRide = '/test-ride';
  static const String adminLogin = '/admin/login';
  static const String adminDashboard = '/admin';
  static const String adminScooters = '/admin/scooters';
  static const String adminAddScooter = '/admin/scooters/new';
  static const String adminEditScooter = '/admin/scooters/:id/edit';
  static const String adminEnquiries = '/admin/enquiries';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    debugLogDiagnostics: true,
    routes: [
      // ── Customer Routes ───────────────────────────────────────────────────
      GoRoute(
        path: home,
        name: 'home',
        pageBuilder: (context, state) => _buildPage(
          state,
          const HomeScreen(),
        ),
      ),
      GoRoute(
        path: catalogue,
        name: 'catalogue',
        pageBuilder: (context, state) => _buildPage(
          state,
          const CatalogueScreen(),
        ),
      ),
      GoRoute(
        path: '/models/:slug',
        name: 'scooterDetail',
        pageBuilder: (context, state) => _buildPage(
          state,
          ScooterDetailScreen(slug: state.pathParameters['slug']!),
        ),
      ),
      GoRoute(
        path: '/models/:slug/3d',
        name: 'showroom3d',
        pageBuilder: (context, state) => _buildPage(
          state,
          Showroom3dScreen(slug: state.pathParameters['slug']!),
        ),
      ),
      GoRoute(
        path: comparison,
        name: 'comparison',
        pageBuilder: (context, state) => _buildPage(
          state,
          const ComparisonScreen(),
        ),
      ),
      GoRoute(
        path: enquiry,
        name: 'enquiry',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return _buildPage(
            state,
            EnquiryScreen(
              isTestRide: false,
              preselectedScooterId: extra?['scooterId'] as String?,
              preselectedScooterName: extra?['scooterName'] as String?,
            ),
          );
        },
      ),
      GoRoute(
        path: testRide,
        name: 'testRide',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return _buildPage(
            state,
            EnquiryScreen(
              isTestRide: true,
              preselectedScooterId: extra?['scooterId'] as String?,
              preselectedScooterName: extra?['scooterName'] as String?,
            ),
          );
        },
      ),

      // ── Admin Routes ──────────────────────────────────────────────────────
      GoRoute(
        path: adminLogin,
        name: 'adminLogin',
        pageBuilder: (context, state) => _buildPage(
          state,
          const LoginScreen(),
        ),
      ),
      GoRoute(
        path: adminDashboard,
        name: 'adminDashboard',
        pageBuilder: (context, state) => _buildPage(
          state,
          const AdminDashboardScreen(),
        ),
      ),
      GoRoute(
        path: adminScooters,
        name: 'adminScooters',
        pageBuilder: (context, state) => _buildPage(
          state,
          const AdminScootersScreen(),
        ),
      ),
      GoRoute(
        path: adminAddScooter,
        name: 'adminAddScooter',
        pageBuilder: (context, state) => _buildPage(
          state,
          const AdminAddScooterScreen(),
        ),
      ),
      GoRoute(
        path: adminEnquiries,
        name: 'adminEnquiries',
        pageBuilder: (context, state) => _buildPage(
          state,
          const AdminEnquiriesScreen(),
        ),
      ),
    ],
    errorPageBuilder: (context, state) => _buildPage(
      state,
      const NotFoundScreen(),
    ),
  );

  static CustomTransitionPage<void> _buildPage(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 280),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: child,
        );
      },
    );
  }
}
