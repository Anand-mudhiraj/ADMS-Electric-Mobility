import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/adms_logo.dart';

/// Admin sidebar shell — wraps all admin screens with a sidebar.
class AdminShell extends StatelessWidget {
  final String currentRoute;
  final Widget child;

  const AdminShell({
    super.key,
    required this.currentRoute,
    required this.child,
  });

  static const List<_NavEntry> _navItems = [
    _NavEntry(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
      route: AppRouter.adminDashboard,
    ),
    _NavEntry(
      icon: Icons.electric_scooter_outlined,
      activeIcon: Icons.electric_scooter,
      label: 'Vehicles',
      route: AppRouter.adminScooters,
    ),
    _NavEntry(
      icon: Icons.add_circle_outline,
      activeIcon: Icons.add_circle,
      label: 'Add Vehicle',
      route: AppRouter.adminAddScooter,
    ),
    _NavEntry(
      icon: Icons.view_in_ar_outlined,
      activeIcon: Icons.view_in_ar,
      label: '3D Library',
      route: AppRouter.adminScooters,
    ),
    _NavEntry(
      icon: Icons.mail_outline,
      activeIcon: Icons.mail,
      label: 'Enquiries',
      route: AppRouter.adminEnquiries,
    ),
    _NavEntry(
      icon: Icons.directions_bike_outlined,
      activeIcon: Icons.directions_bike,
      label: 'Test Rides',
      route: AppRouter.adminEnquiries,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    if (isWide) {
      return Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        body: Row(
          children: [
            // Sidebar
            _Sidebar(currentRoute: currentRoute, navItems: _navItems),
            // Main content
            Expanded(child: child),
          ],
        ),
      );
    } else {
      // Mobile: use drawer
      return Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        drawer: Drawer(
          backgroundColor: AppColors.backgroundSecondary,
          child: _SidebarContent(
              currentRoute: currentRoute, navItems: _navItems),
        ),
        appBar: AppBar(
          backgroundColor: AppColors.backgroundSecondary,
          title: const AdmsLogo(height: 32),
          actions: [
            _AdminBadge(),
          ],
        ),
        body: child,
      );
    }
  }
}

class _NavEntry {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  const _NavEntry({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}

class _Sidebar extends StatelessWidget {
  final String currentRoute;
  final List<_NavEntry> navItems;

  const _Sidebar({required this.currentRoute, required this.navItems});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: const BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border(right: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: _SidebarContent(
          currentRoute: currentRoute, navItems: navItems),
    );
  }
}

class _SidebarContent extends StatelessWidget {
  final String currentRoute;
  final List<_NavEntry> navItems;

  const _SidebarContent(
      {required this.currentRoute, required this.navItems});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              const AdmsLogo(height: 36),
              const SizedBox(height: 4),
              Text(
                'ADMIN',
                style: AppTextStyles.tagline.copyWith(
                  fontSize: 9,
                  color: AppColors.accentLime,
                  letterSpacing: 4,
                ),
              ),
            ],
          ),
        ),
        const Divider(color: AppColors.borderSubtle),
        const SizedBox(height: AppSpacing.sm),
        // Nav items
        ...navItems.map((item) => _SidebarItem(
              entry: item,
              isActive: currentRoute == item.route,
            )),
        const Spacer(),
        const Divider(color: AppColors.borderSubtle),
        // Bottom items
        _SidebarItem(
          entry: const _NavEntry(
            icon: Icons.visibility_outlined,
            activeIcon: Icons.visibility,
            label: 'Customer Site',
            route: AppRouter.home,
          ),
          isActive: false,
        ),
        _SidebarItem(
          entry: const _NavEntry(
            icon: Icons.logout,
            activeIcon: Icons.logout,
            label: 'Logout',
            route: AppRouter.adminLogin,
          ),
          isActive: false,
          isDestructive: true,
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final _NavEntry entry;
  final bool isActive;
  final bool isDestructive;

  const _SidebarItem({
    required this.entry,
    required this.isActive,
    this.isDestructive = false,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;

  Color get _color {
    if (widget.isDestructive) return AppColors.statusError;
    if (widget.isActive) return AppColors.accentLime;
    if (_hovered) return AppColors.textPrimary;
    return AppColors.textMuted;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(widget.entry.route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppColors.accentLimeSurface
                : _hovered
                    ? AppColors.backgroundElevated
                    : Colors.transparent,
            borderRadius: AppRadius.smBorderRadius,
            border: widget.isActive
                ? Border.all(color: AppColors.borderAccent)
                : null,
          ),
          child: Row(
            children: [
              Icon(
                widget.isActive
                    ? widget.entry.activeIcon
                    : widget.entry.icon,
                size: 18,
                color: _color,
              ),
              const SizedBox(width: 10),
              Text(
                widget.entry.label,
                style: AppTextStyles.navItem.copyWith(color: _color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Row(
        children: [
          Text('Admin', style: AppTextStyles.bodySmall),
          const SizedBox(width: 8),
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: AppColors.backgroundElevated,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person,
                size: 16, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
