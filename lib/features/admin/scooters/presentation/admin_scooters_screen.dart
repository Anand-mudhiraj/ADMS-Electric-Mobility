import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/adms_button.dart';
import '../../../../data/services/demo_data.dart';
import '../../../../data/models/scooter.dart';
import '../../../admin/dashboard/presentation/admin_shell.dart';

class AdminScootersScreen extends StatefulWidget {
  const AdminScootersScreen({super.key});

  @override
  State<AdminScootersScreen> createState() => _AdminScootersScreenState();
}

class _AdminScootersScreenState extends State<AdminScootersScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  List<Scooter> get _filtered {
    final q = _query.toLowerCase();
    return DemoData.scooters.where((s) {
      if (q.isEmpty) return true;
      return s.modelName.toLowerCase().contains(q) ||
          (s.shortDescription?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      currentRoute: AppRouter.adminScooters,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text('Manage Vehicles',
                      style: AppTextStyles.headingLarge),
                ),
                AdmsButton(
                  label: 'Add New Vehicle',
                  leadingIcon: Icons.add,
                  onPressed: () => context.go(AppRouter.adminAddScooter),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.statusWarning.withValues(alpha: 0.1),
                borderRadius: AppRadius.smBorderRadius,
                border: Border.all(
                    color: AppColors.statusWarning.withValues(alpha: 0.3)),
              ),
              child: Text(
                '⚠ Displaying demo data. Supabase CRUD not yet connected (Phase 6).',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.statusWarning),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Search
            TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Search vehicles...',
                prefixIcon: Icon(Icons.search, size: 20),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Table
            _ScooterTable(scooters: _filtered),
          ],
        ),
      ),
    );
  }
}

class _ScooterTable extends StatelessWidget {
  final List<Scooter> scooters;
  const _ScooterTable({required this.scooters});

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
                SizedBox(width: 48),
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
                SizedBox(width: 120, child: Text('Actions', style: AppTextStyles.labelMedium)),
              ],
            ),
          ),
          if (scooters.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Text('No vehicles found.',
                  style: AppTextStyles.bodyMedium),
            )
          else
            ...scooters.map((s) => _ScooterRow(scooter: s)),
        ],
      ),
    );
  }
}

class _ScooterRow extends StatefulWidget {
  final Scooter scooter;
  const _ScooterRow({required this.scooter});

  @override
  State<_ScooterRow> createState() => _ScooterRowState();
}

class _ScooterRowState extends State<_ScooterRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.scooter;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        color: _hovered
            ? AppColors.backgroundElevated
            : Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(color: AppColors.borderSubtle)),
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
                    size: 20, color: AppColors.textMuted),
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
                child: _StatusChip(status: s.status),
              ),
              SizedBox(
                width: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined,
                          size: 16, color: AppColors.textMuted),
                      onPressed: () {},
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      icon: const Icon(Icons.visibility_outlined,
                          size: 16, color: AppColors.textMuted),
                      onPressed: () =>
                          context.go('/models/${s.slug}'),
                      tooltip: 'View on site',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          size: 16, color: AppColors.statusError),
                      onPressed: () {},
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final ScooterStatus status;
  const _StatusChip({required this.status});

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
