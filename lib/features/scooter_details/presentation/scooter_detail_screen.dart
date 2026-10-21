import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/widgets/adms_button.dart';
import '../../../core/widgets/navigation.dart';
import '../../../data/services/demo_data.dart';
import '../../../data/models/scooter.dart';

class ScooterDetailScreen extends StatefulWidget {
  final String slug;
  const ScooterDetailScreen({super.key, required this.slug});

  @override
  State<ScooterDetailScreen> createState() => _ScooterDetailScreenState();
}

class _ScooterDetailScreenState extends State<ScooterDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedColourIndex = 0;

  bool get _isDesktop => MediaQuery.sizeOf(context).width >= 1024;

  Scooter? get _scooter => DemoData.getBySlug(widget.slug);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scooter = _scooter;
    if (scooter == null) {
      return _NotFoundContent(slug: widget.slug);
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: _isDesktop ? const DesktopNavBar() : _mobileAppBar(scooter),
      bottomNavigationBar: _isDesktop
          ? null
          : MobileNavBar(
              currentIndex: 1,
              onTap: (i) {
                switch (i) {
                  case 0:
                    context.go(AppRouter.home);
                  case 1:
                    context.go(AppRouter.catalogue);
                  case 3:
                    context.go(AppRouter.comparison);
                  case 4:
                    context.go(AppRouter.enquiry);
                }
              },
            ),
      body: _isDesktop
          ? _DesktopDetailLayout(
              scooter: scooter,
              tabController: _tabController,
              selectedColourIndex: _selectedColourIndex,
              onColourSelected: (i) =>
                  setState(() => _selectedColourIndex = i),
            )
          : _MobileDetailLayout(
              scooter: scooter,
              tabController: _tabController,
              selectedColourIndex: _selectedColourIndex,
              onColourSelected: (i) =>
                  setState(() => _selectedColourIndex = i),
            ),
    );
  }

  PreferredSizeWidget _mobileAppBar(Scooter scooter) {
    return AppBar(
      backgroundColor: AppColors.backgroundPrimary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.go(AppRouter.catalogue),
      ),
      title: Text(scooter.modelName,
          style: AppTextStyles.headingSmall),
      actions: [
        if (scooter.has3dModel)
          IconButton(
            icon: const Icon(Icons.view_in_ar, color: AppColors.accentLime),
            onPressed: () =>
                context.go('/models/${scooter.slug}/3d'),
            tooltip: 'View in 3D',
          ),
      ],
    );
  }
}

// ── Desktop layout ─────────────────────────────────────────────────────────────
class _DesktopDetailLayout extends StatelessWidget {
  final Scooter scooter;
  final TabController tabController;
  final int selectedColourIndex;
  final ValueChanged<int> onColourSelected;

  const _DesktopDetailLayout({
    required this.scooter,
    required this.tabController,
    required this.selectedColourIndex,
    required this.onColourSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 72),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pagePaddingDesktop,
                vertical: AppSpacing.xl,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left — image & 3D viewer
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        _ScooterImageViewer(scooter: scooter),
                        const SizedBox(height: AppSpacing.md),
                        if (scooter.has3dModel)
                          AdmsButton(
                            label: 'View in 3D Showroom',
                            leadingIcon: Icons.view_in_ar,
                            onPressed: () =>
                                context.go('/models/${scooter.slug}/3d'),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundCard,
                              borderRadius: AppRadius.smBorderRadius,
                              border: Border.all(color: AppColors.borderSubtle),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.view_in_ar,
                                    color: AppColors.textMuted, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  '3D model not yet available for this scooter',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textMuted,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xl),
                  // Right — details
                  Expanded(
                    flex: 6,
                    child: _DetailPanel(
                      scooter: scooter,
                      tabController: tabController,
                      selectedColourIndex: selectedColourIndex,
                      onColourSelected: onColourSelected,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Mobile layout ──────────────────────────────────────────────────────────────
class _MobileDetailLayout extends StatelessWidget {
  final Scooter scooter;
  final TabController tabController;
  final int selectedColourIndex;
  final ValueChanged<int> onColourSelected;

  const _MobileDetailLayout({
    required this.scooter,
    required this.tabController,
    required this.selectedColourIndex,
    required this.onColourSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _ScooterImageViewer(scooter: scooter),
          _DetailPanel(
            scooter: scooter,
            tabController: tabController,
            selectedColourIndex: selectedColourIndex,
            onColourSelected: onColourSelected,
          ),
        ],
      ),
    );
  }
}

// ── Image viewer ───────────────────────────────────────────────────────────────
class _ScooterImageViewer extends StatelessWidget {
  final Scooter scooter;
  const _ScooterImageViewer({required this.scooter});

  @override
  Widget build(BuildContext context) {
    final url = scooter.thumbnailUrl;
    if (url != null && url.isNotEmpty) {
      return Container(
        height: 340,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: AppRadius.lgBorderRadius,
          border: Border.all(color: AppColors.borderSubtle),
        ),
        clipBehavior: Clip.antiAlias,
        child: url.startsWith('assets/')
            ? Image.asset(url, fit: BoxFit.cover, width: double.infinity)
            : Image.network(url, fit: BoxFit.cover, width: double.infinity),
      );
    }

    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: AppRadius.lgBorderRadius,
        border: Border.all(color: AppColors.borderSubtle),
        gradient: RadialGradient(
          colors: [
            AppColors.accentLime.withValues(alpha: 0.05),
            AppColors.backgroundSecondary,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.electric_scooter,
              size: 120,
              color: AppColors.textMuted.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 8),
            Text(
              scooter.modelName,
              style: AppTextStyles.headingSmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Detail panel ───────────────────────────────────────────────────────────────
class _DetailPanel extends StatelessWidget {
  final Scooter scooter;
  final TabController tabController;
  final int selectedColourIndex;
  final ValueChanged<int> onColourSelected;

  const _DetailPanel({
    required this.scooter,
    required this.tabController,
    required this.selectedColourIndex,
    required this.onColourSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Demo warning
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.statusWarning.withValues(alpha: 0.1),
              borderRadius: AppRadius.smBorderRadius,
              border: Border.all(
                  color: AppColors.statusWarning.withValues(alpha: 0.3)),
            ),
            child: Text(
              '⚠ Demo specifications — not confirmed by ADMS',
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.statusWarning),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Model name
          Text(scooter.modelName, style: AppTextStyles.displayMedium),
          if (scooter.shortDescription != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              scooter.shortDescription!,
              style: AppTextStyles.bodyMedium,
            ),
          ],
          if (scooter.category != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.backgroundElevated,
                borderRadius: AppRadius.smBorderRadius,
              ),
              child: Text(
                scooter.category!,
                style: AppTextStyles.labelSmall,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          // Price
          Text(
            scooter.displayPrice,
            style: AppTextStyles.priceTag,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Tabs: Specs, Colours, Features
          TabBar(
            controller: tabController,
            tabs: const [
              Tab(text: 'Specs'),
              Tab(text: 'Colours'),
              Tab(text: 'Features'),
              Tab(text: '360°'),
            ],
          ),
          SizedBox(
            height: 320,
            child: TabBarView(
              controller: tabController,
              children: [
                _SpecsTab(specs: scooter.specs),
                _ColoursTab(
                  colours: scooter.colours,
                  selectedIndex: selectedColourIndex,
                  onSelected: onColourSelected,
                ),
                _FeaturesTab(),
                _ThreeSixtyTab(scooter: scooter),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: AdmsButton(
                  label: 'Enquire Now',
                  variant: AdmsButtonVariant.outline,
                  onPressed: () => context.go(
                    AppRouter.enquiry,
                    extra: {
                      'scooterId': scooter.id,
                      'scooterName': scooter.modelName,
                    },
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AdmsButton(
                  label: 'Book Test Ride',
                  onPressed: () => context.go(
                    AppRouter.testRide,
                    extra: {
                      'scooterId': scooter.id,
                      'scooterName': scooter.modelName,
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SpecsTab extends StatelessWidget {
  final ScooterSpecs? specs;
  const _SpecsTab({required this.specs});

  @override
  Widget build(BuildContext context) {
    if (specs == null) {
      return const Center(
          child: Text('No specifications available.',
              style: AppTextStyles.bodyMedium));
    }
    final rows = <(IconData, String, String?)>[
      (Icons.route, 'Range', specs!.rangeKm != null ? '${specs!.rangeKm} KM' : null),
      (Icons.speed, 'Top Speed', specs!.topSpeedKmh != null ? '${specs!.topSpeedKmh} KM/H' : null),
      (Icons.battery_charging_full, 'Battery', () {
        final parts = <String>[];
        if (specs!.batteryVoltage != null) parts.add('${specs!.batteryVoltage}V');
        if (specs!.batteryCapacityAh != null) parts.add('${specs!.batteryCapacityAh}Ah');
        return parts.isEmpty ? null : parts.join(' ');
      }()),
      (Icons.bolt, 'Motor Power', specs!.motorPowerW != null ? '${specs!.motorPowerW}W' : null),
      (Icons.timer, 'Charging Time', specs!.chargingTimeHours != null ? '${specs!.chargingTimeHours} Hours' : null),
      (Icons.person, 'Load Capacity', specs!.loadCapacityKg != null ? '${specs!.loadCapacityKg} KG' : null),
    ];

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      itemCount: rows.length,
      separatorBuilder: (_, __) =>
          const Divider(color: AppColors.borderSubtle),
      itemBuilder: (_, i) {
        final row = rows[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(row.$1, size: 18, color: AppColors.accentLime),
              const SizedBox(width: 12),
              Text(row.$2, style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textPrimary)),
              const Spacer(),
              Text(
                row.$3 ?? 'Not provided',
                style: AppTextStyles.labelLarge.copyWith(
                  color: row.$3 != null
                      ? AppColors.textPrimary
                      : AppColors.textMuted,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ColoursTab extends StatelessWidget {
  final List<ScooterColour> colours;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _ColoursTab({
    required this.colours,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (colours.isEmpty) {
      return const Center(
          child: Text('Colour information not available.',
              style: AppTextStyles.bodyMedium));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Available Colours', style: AppTextStyles.headingSmall),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: List.generate(colours.length, (i) {
              final c = colours[i];
              final isSelected = i == selectedIndex;
              return GestureDetector(
                onTap: () => onSelected(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.accentLime
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Color(c.colorHex),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.borderMedium),
                          boxShadow: isSelected
                              ? [AppShadows.accentGlow]
                              : null,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        c.name,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: isSelected
                              ? AppColors.accentLime
                              : AppColors.textMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _FeaturesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Placeholder — real features will be loaded from database
    final features = [
      (Icons.light, 'LED Headlight', 'Better visibility at night'),
      (Icons.dashboard, 'Digital Display', 'Real-time information'),
      (Icons.circle, 'Disc Brakes', 'Safer and smoother'),
      (Icons.chair, 'Comfort Seat', 'Designed for long rides'),
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      children: features
          .map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundElevated,
                        borderRadius: AppRadius.smBorderRadius,
                      ),
                      child: Icon(f.$1,
                          size: 18, color: AppColors.accentLime),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(f.$2, style: AppTextStyles.labelLarge),
                          Text(f.$3, style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class _ThreeSixtyTab extends StatelessWidget {
  final Scooter scooter;
  const _ThreeSixtyTab({required this.scooter});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.view_in_ar,
            size: 56,
            color: AppColors.accentLime.withValues(alpha: 0.6),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            scooter.has3dModel
                ? 'Open full 3D Showroom'
                : '3D model not yet available',
            style: AppTextStyles.headingSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          if (scooter.has3dModel)
            AdmsButton(
              label: 'View in 3D',
              leadingIcon: Icons.view_in_ar,
              onPressed: () =>
                  context.go('/models/${scooter.slug}/3d'),
            )
          else
            Text(
              'The admin can upload a GLB/GLTF model to enable 3D viewing.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textMuted,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}

class _NotFoundContent extends StatelessWidget {
  final String slug;
  const _NotFoundContent({required this.slug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('404', style: AppTextStyles.displayLarge
                .copyWith(color: AppColors.accentLime)),
            const SizedBox(height: 8),
            Text('Scooter not found: $slug',
                style: AppTextStyles.headingSmall),
            const SizedBox(height: 20),
            AdmsButton(
              label: 'Back to Catalogue',
              onPressed: () => context.go(AppRouter.catalogue),
            ),
          ],
        ),
      ),
    );
  }
}
