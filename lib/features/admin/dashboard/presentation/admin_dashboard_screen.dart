import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../data/services/demo_data.dart';
import '../../../../data/models/scooter.dart';
import 'admin_shell.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scooters = DemoData.scooters;
    final published = scooters.where((s) => s.isPublished).length;
    final drafts = scooters.where((s) => s.status == ScooterStatus.draft).length;

    return AdminShell(
      currentRoute: AppRouter.adminDashboard,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dashboard', style: AppTextStyles.headingLarge),
                      Text(
                        'ADMS Electric Mobility Administration',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
                _AdminAvatar(),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.statusWarning.withValues(alpha: 0.1),
                borderRadius: AppRadius.smBorderRadius,
                border: Border.all(
                    color: AppColors.statusWarning.withValues(alpha: 0.3)),
              ),
              child: Text(
                '⚠ Phase 6: Displaying demo data. Supabase not yet connected. '
                'Statistics below reflect local demo records only.',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.statusWarning),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Stats grid
            _StatsGrid(stats: [
              _StatData(
                icon: Icons.electric_scooter,
                label: 'Total Vehicles',
                value: scooters.length.toString(),
                color: AppColors.accentLime,
              ),
              _StatData(
                icon: Icons.check_circle_outline,
                label: 'Published',
                value: published.toString(),
                color: AppColors.statusSuccess,
              ),
              _StatData(
                icon: Icons.edit_outlined,
                label: 'Drafts',
                value: drafts.toString(),
                color: AppColors.statusWarning,
              ),
              _StatData(
                icon: Icons.mail_outline,
                label: 'Enquiries',
                value: '—',
                color: AppColors.statusInfo,
              ),
              _StatData(
                icon: Icons.directions_bike,
                label: 'Test Rides',
                value: '—',
                color: AppColors.statusInfo,
              ),
              _StatData(
                icon: Icons.view_in_ar,
                label: '3D Models',
                value: scooters
                    .where((s) => s.has3dModel)
                    .length
                    .toString(),
                color: AppColors.accentLimeDark,
              ),
            ]),
            const SizedBox(height: AppSpacing.xl),
            // Quick actions
            Text('Quick Actions', style: AppTextStyles.headingMedium),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                _QuickAction(
                  icon: Icons.add_circle_outline,
                  label: 'Add New Vehicle',
                  onTap: () => context.go(AppRouter.adminAddScooter),
                ),
                _QuickAction(
                  icon: Icons.list_alt,
                  label: 'Manage Vehicles',
                  onTap: () => context.go(AppRouter.adminScooters),
                ),
                _QuickAction(
                  icon: Icons.mail_outline,
                  label: 'View Enquiries',
                  onTap: () => context.go(AppRouter.adminEnquiries),
                ),
                _QuickAction(
                  icon: Icons.visibility,
                  label: 'View Customer Site',
                  onTap: () => context.go(AppRouter.home),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            // Recent vehicles table
            Text('Recent Vehicles', style: AppTextStyles.headingMedium),
            const SizedBox(height: AppSpacing.md),
            _VehiclesTable(scooters: scooters.take(5).toList()),
          ],
        ),
      ),
    );
  }
}

class _AdminAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Admin', style: AppTextStyles.bodyMedium),
        const SizedBox(width: 8),
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppColors.backgroundElevated,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person, size: 20, color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _StatData {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatData({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}

class _StatsGrid extends StatelessWidget {
  final List<_StatData> stats;
  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width > 1200;
    return GridView.count(
      crossAxisCount: isWide ? 6 : 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.3,
      children: stats.map((s) => _StatCard(data: s)).toList(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final _StatData data;
  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: AppRadius.lgBorderRadius,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(data.icon, color: data.color, size: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data.value, style: AppTextStyles.headingMedium),
              Text(data.label, style: AppTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_QuickAction> createState() => _QuickActionState();
}

class _QuickActionState extends State<_QuickAction> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.accentLimeSurface
                : AppColors.backgroundCard,
            borderRadius: AppRadius.smBorderRadius,
            border: Border.all(
              color: _hovered
                  ? AppColors.borderAccent
                  : AppColors.borderSubtle,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 18,
                color: _hovered ? AppColors.accentLime : AppColors.textMuted,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: _hovered
                      ? AppColors.accentLime
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VehiclesTable extends StatelessWidget {
  final List<Scooter> scooters;
  const _VehiclesTable({required this.scooters});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: AppRadius.lgBorderRadius,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.backgroundElevated,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppRadius.lg)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 48),
                Expanded(
                    flex: 3,
                    child: Text('Model Name',
                        style: AppTextStyles.labelMedium)),
                Expanded(
                    flex: 2,
                    child:
                        Text('Range', style: AppTextStyles.labelMedium)),
                Expanded(
                    flex: 2,
                    child:
                        Text('Price', style: AppTextStyles.labelMedium)),
                Expanded(
                    flex: 2,
                    child: Text('Status',
                        style: AppTextStyles.labelMedium)),
                SizedBox(width: 100),
              ],
            ),
          ),
          // Rows
          ...scooters.map((s) => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.borderSubtle),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundElevated,
                        borderRadius: AppRadius.smBorderRadius,
                      ),
                      child: const Icon(Icons.electric_scooter,
                          size: 20,
                          color: AppColors.textMuted),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(s.modelName,
                          style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        s.specs?.rangeKm != null
                            ? '${s.specs!.rangeKm} KM'
                            : '—',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(s.displayPrice,
                          style: AppTextStyles.bodyMedium),
                    ),
                    Expanded(
                      flex: 2,
                      child: _StatusBadge(status: s.status),
                    ),
                    SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined,
                                size: 16,
                                color: AppColors.textMuted),
                            onPressed: () {},
                            tooltip: 'Edit',
                          ),
                          IconButton(
                            icon: const Icon(Icons.visibility_outlined,
                                size: 16,
                                color: AppColors.textMuted),
                            onPressed: () =>
                                context.go('/models/${s.slug}'),
                            tooltip: 'View',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ScooterStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ScooterStatus.published => ('Active', AppColors.statusSuccess),
      ScooterStatus.draft => ('Draft', AppColors.statusWarning),
      ScooterStatus.archived => ('Inactive', AppColors.textMuted),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.smBorderRadius,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(color: color),
      ),
    );
  }
}
