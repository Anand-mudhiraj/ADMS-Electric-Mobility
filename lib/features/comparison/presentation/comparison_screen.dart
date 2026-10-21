import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/widgets/navigation.dart';
import '../../../data/services/demo_data.dart';
import '../../../data/models/scooter.dart';

class ComparisonScreen extends StatefulWidget {
  const ComparisonScreen({super.key});

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  final List<Scooter?> _selected = [null, null, null];

  bool get _isDesktop => MediaQuery.sizeOf(context).width >= 1024;

  List<Scooter> get _publishedScooters =>
      DemoData.scooters.where((s) => s.isPublished).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: _isDesktop
          ? const DesktopNavBar()
          : AppBar(
              backgroundColor: AppColors.backgroundPrimary,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go(AppRouter.home),
              ),
              title: const Text('Compare Models'),
              actions: [
                TextButton(
                  onPressed: () =>
                      setState(() => _selected.fillRange(0, 3, null)),
                  child: Text(
                    'Clear All',
                    style: AppTextStyles.labelMedium
                        .copyWith(color: AppColors.accentLime),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _isDesktop
          ? null
          : MobileNavBar(
              currentIndex: 3,
              onTap: (i) {
                if (i == 0) context.go(AppRouter.home);
                if (i == 1) context.go(AppRouter.catalogue);
                if (i == 4) context.go(AppRouter.enquiry);
              },
            ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: _isDesktop ? 72 + 24.0 : 24.0,
            left: _isDesktop
                ? AppSpacing.pagePaddingDesktop
                : AppSpacing.pagePaddingMobile,
            right: _isDesktop
                ? AppSpacing.pagePaddingDesktop
                : AppSpacing.pagePaddingMobile,
            bottom: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isDesktop)
                Row(
                  children: [
                    Text('Compare Models',
                        style: AppTextStyles.headingLarge),
                    const Spacer(),
                    TextButton(
                      onPressed: () =>
                          setState(() => _selected.fillRange(0, 3, null)),
                      child: const Text('Clear All'),
                    ),
                  ],
                ),
              const SizedBox(height: AppSpacing.lg),
              // Demo warning
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.statusWarning.withValues(alpha: 0.1),
                  borderRadius: AppRadius.smBorderRadius,
                  border: Border.all(
                      color:
                          AppColors.statusWarning.withValues(alpha: 0.3)),
                ),
                child: Text(
                  '⚠ Demo data — specifications not confirmed by ADMS',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.statusWarning),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              // Selector row
              _SelectorRow(
                selected: _selected,
                scooters: _publishedScooters,
                onSelect: (index, scooter) =>
                    setState(() => _selected[index] = scooter),
              ),
              const SizedBox(height: AppSpacing.xl),
              // Comparison table
              if (_selected.any((s) => s != null))
                _ComparisonTable(selected: _selected)
              else
                _EmptyState(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectorRow extends StatelessWidget {
  final List<Scooter?> selected;
  final List<Scooter> scooters;
  final void Function(int index, Scooter? scooter) onSelect;

  const _SelectorRow({
    required this.selected,
    required this.scooters,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (i) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < 2 ? AppSpacing.md : 0),
            child: _ScooterSelector(
              index: i,
              selected: selected[i],
              scooters: scooters,
              onSelect: (s) => onSelect(i, s),
            ),
          ),
        );
      }),
    );
  }
}

class _ScooterSelector extends StatelessWidget {
  final int index;
  final Scooter? selected;
  final List<Scooter> scooters;
  final ValueChanged<Scooter?> onSelect;

  const _ScooterSelector({
    required this.index,
    required this.selected,
    required this.scooters,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: AppRadius.lgBorderRadius,
        border: Border.all(
          color: selected != null
              ? AppColors.borderAccent
              : AppColors.borderSubtle,
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: AppRadius.smBorderRadius,
            ),
            child: Center(
              child: Icon(
                Icons.electric_scooter,
                size: 64,
                color: selected != null
                    ? AppColors.accentLime.withValues(alpha: 0.4)
                    : AppColors.textMuted.withValues(alpha: 0.2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<Scooter?>(
            initialValue: selected,
            dropdownColor: AppColors.backgroundCard,
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            hint: Text('Select model',
                style:
                    AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
            items: [
              const DropdownMenuItem<Scooter?>(
                value: null,
                child: Text('None'),
              ),
              ...scooters.map((s) => DropdownMenuItem<Scooter?>(
                    value: s,
                    child: Text(s.modelName,
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.textPrimary)),
                  )),
            ],
            onChanged: onSelect,
          ),
          if (selected != null) ...[
            const SizedBox(height: AppSpacing.sm),
            GestureDetector(
              onTap: () => context.go('/models/${selected!.slug}'),
              child: Text(
                'View Details →',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.accentLime,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  final List<Scooter?> selected;
  const _ComparisonTable({required this.selected});

  @override
  Widget build(BuildContext context) {
    final specs = [
      'Model',
      'Category',
      'Price',
      'Range',
      'Top Speed',
      'Battery',
      'Motor Power',
      'Charging Time',
      'Load Capacity',
      '3D Model',
    ];

    String cell(Scooter? s, String field) {
      if (s == null) return '—';
      switch (field) {
        case 'Model':
          return s.modelName;
        case 'Category':
          return s.category ?? 'Not specified';
        case 'Price':
          return s.displayPrice;
        case 'Range':
          return s.specs?.rangeKm != null ? '${s.specs!.rangeKm} KM' : 'Not provided';
        case 'Top Speed':
          return s.specs?.topSpeedKmh != null ? '${s.specs!.topSpeedKmh} KM/H' : 'Not provided';
        case 'Battery':
          if (s.specs == null) return 'Not provided';
          final v = s.specs!.batteryVoltage;
          final c = s.specs!.batteryCapacityAh;
          if (v != null && c != null) return '${v}V ${c}Ah';
          if (v != null) return '${v}V';
          if (c != null) return '${c}Ah';
          return 'Not provided';
        case 'Motor Power':
          return s.specs?.motorPowerW != null ? '${s.specs!.motorPowerW}W' : 'Not provided';
        case 'Charging Time':
          return s.specs?.chargingTimeHours != null ? '${s.specs!.chargingTimeHours} hrs' : 'Not provided';
        case 'Load Capacity':
          return s.specs?.loadCapacityKg != null ? '${s.specs!.loadCapacityKg} KG' : 'Not provided';
        case '3D Model':
          return s.has3dModel ? 'Available' : 'Not available';
        default:
          return '—';
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: AppRadius.lgBorderRadius,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Table(
        border: TableBorder(
          horizontalInside: BorderSide(color: AppColors.borderSubtle),
          verticalInside: BorderSide(color: AppColors.borderSubtle),
        ),
        children: [
          // Header row
          TableRow(
            decoration: const BoxDecoration(
              color: AppColors.backgroundElevated,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadius.lg),
              ),
            ),
            children: [
              _Cell(text: 'Specification', isHeader: true),
              ...selected.map((s) => _Cell(
                    text: s?.modelName ?? '—',
                    isHeader: true,
                    isAccent: s != null,
                  )),
            ],
          ),
          // Data rows
          ...specs.map((field) => TableRow(
                children: [
                  _Cell(text: field, isLabel: true),
                  ...selected.map((s) => _Cell(text: cell(s, field))),
                ],
              )),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String text;
  final bool isHeader;
  final bool isLabel;
  final bool isAccent;

  const _Cell({
    required this.text,
    this.isHeader = false,
    this.isLabel = false,
    this.isAccent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Text(
        text,
        style: isHeader
            ? AppTextStyles.labelMedium.copyWith(
                color: isAccent ? AppColors.accentLime : AppColors.textPrimary,
              )
            : isLabel
                ? AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textSecondary)
                : AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textPrimary),
        textAlign: isLabel ? TextAlign.start : TextAlign.center,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.compare_arrows,
              size: 64,
              color: AppColors.textMuted.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Select models to compare',
                style: AppTextStyles.headingSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Choose up to 3 scooters from the dropdowns above.',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
