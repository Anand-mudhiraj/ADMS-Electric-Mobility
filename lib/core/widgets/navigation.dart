import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/theme.dart';
import '../routing/app_router.dart';
import 'adms_logo.dart';

/// Desktop top navigation bar
class DesktopNavBar extends StatelessWidget implements PreferredSizeWidget {
  const DesktopNavBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary.withValues(alpha: 0.95),
        border: const Border(
          bottom: BorderSide(color: AppColors.borderSubtle),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePaddingDesktop),
        child: Row(
          children: [
            // Logo
            GestureDetector(
              onTap: () => context.go(AppRouter.home),
              child: const AdmsLogo(height: 36),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => context.go(AppRouter.home),
              child: Text(
                'ELECTRIC MOBILITY',
                style: AppTextStyles.tagline.copyWith(fontSize: 10),
              ),
            ),
            const Spacer(),
            // Nav items
            _NavItem(
              label: 'Home',
              route: AppRouter.home,
              currentLocation: location,
            ),
            _NavItem(
              label: 'Models',
              route: AppRouter.catalogue,
              currentLocation: location,
            ),
            _NavItem(
              label: '3D Showroom',
              route: AppRouter.catalogue,
              currentLocation: location,
              isSpecial: true,
            ),
            _NavItem(
              label: 'Compare',
              route: AppRouter.comparison,
              currentLocation: location,
            ),
            _NavItem(
              label: 'Enquiries',
              route: AppRouter.enquiry,
              currentLocation: location,
            ),
            const SizedBox(width: 24),
            // Book Test Ride CTA
            _BookTestRideBtn(),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final String route;
  final String currentLocation;
  final bool isSpecial;

  const _NavItem({
    required this.label,
    required this.route,
    required this.currentLocation,
    this.isSpecial = false,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  bool get _isActive => widget.currentLocation == widget.route;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(widget.route),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isSpecial
                ? AppColors.accentLimeSurface
                : _hovered || _isActive
                    ? AppColors.backgroundElevated
                    : Colors.transparent,
            borderRadius: AppRadius.smBorderRadius,
            border: widget.isSpecial
                ? Border.all(color: AppColors.borderAccent)
                : null,
          ),
          child: Text(
            widget.label,
            style: AppTextStyles.navItem.copyWith(
              color: widget.isSpecial
                  ? AppColors.accentLime
                  : _isActive || _hovered
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _BookTestRideBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(AppRouter.testRide),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.accentLime,
          borderRadius: AppRadius.smBorderRadius,
          boxShadow: [AppShadows.accentGlow],
        ),
        child: Text(
          'BOOK TEST RIDE',
          style: AppTextStyles.buttonText.copyWith(
            color: AppColors.textInverse,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

/// Mobile bottom navigation bar
class MobileNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const MobileNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: const Border(
          top: BorderSide(color: AppColors.borderSubtle),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x60000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              _MobileNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _MobileNavItem(
                icon: Icons.electric_scooter_outlined,
                activeIcon: Icons.electric_scooter,
                label: 'Models',
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _MobileNavItem(
                icon: Icons.view_in_ar_outlined,
                activeIcon: Icons.view_in_ar,
                label: '3D',
                isActive: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _MobileNavItem(
                icon: Icons.compare_arrows_outlined,
                activeIcon: Icons.compare_arrows,
                label: 'Compare',
                isActive: currentIndex == 3,
                onTap: () => onTap(3),
              ),
              _MobileNavItem(
                icon: Icons.mail_outline,
                activeIcon: Icons.mail,
                label: 'Enquire',
                isActive: currentIndex == 4,
                onTap: () => onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileNavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _MobileNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: 22,
              color: isActive ? AppColors.accentLime : AppColors.textMuted,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isActive ? AppColors.accentLime : AppColors.textMuted,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
