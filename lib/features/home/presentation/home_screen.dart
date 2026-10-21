import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/theme.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/widgets/adms_logo.dart';
import '../../../core/widgets/adms_button.dart';
import '../../../core/widgets/scooter_card.dart';
import '../../../core/widgets/navigation.dart';
import '../../../data/services/demo_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  bool get _isDesktop => MediaQuery.sizeOf(context).width >= 1024;
  int get _mobileNavIndex => 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      extendBodyBehindAppBar: true,
      appBar: _isDesktop ? const DesktopNavBar() : null,
      bottomNavigationBar: _isDesktop
          ? null
          : MobileNavBar(
              currentIndex: _mobileNavIndex,
              onTap: (i) {
                switch (i) {
                  case 0:
                    context.go(AppRouter.home);
                  case 1:
                    context.go(AppRouter.catalogue);
                  case 2:
                    context.go(AppRouter.catalogue);
                  case 3:
                    context.go(AppRouter.comparison);
                  case 4:
                    context.go(AppRouter.enquiry);
                }
              },
            ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HeroSection(isDesktop: _isDesktop),
            _BenefitsSection(isDesktop: _isDesktop),
            _FeaturedScootersSection(isDesktop: _isDesktop),
            _ShowroomCtaSection(isDesktop: _isDesktop),
            _ContactSection(isDesktop: _isDesktop),
            _Footer(),
          ],
        ),
      ),
    );
  }
}

// ── Hero ──────────────────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  final bool isDesktop;
  const _HeroSection({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: isDesktop
            ? MediaQuery.sizeOf(context).height
            : MediaQuery.sizeOf(context).height * 0.85,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0B0D0F),
            Color(0xFF0F1318),
            Color(0xFF0B0D0F),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background glow
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accentLime.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Content
          if (isDesktop)
            _HeroDesktopContent()
          else
            _HeroMobileContent(),
        ],
      ),
    );
  }
}

class _HeroDesktopContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 72 + 80, // app bar + spacing
        left: AppSpacing.pagePaddingDesktop,
        right: AppSpacing.pagePaddingDesktop,
        bottom: AppSpacing.xxxl,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left — text content
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tagline chip
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accentLimeSurface,
                    borderRadius: AppRadius.smBorderRadius,
                    border: Border.all(color: AppColors.borderAccent),
                  ),
                  child: Text(
                    'SMART • POWERFUL • SUSTAINABLE',
                    style: AppTextStyles.tagline.copyWith(
                      color: AppColors.accentLime,
                      fontSize: 11,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),
                const SizedBox(height: AppSpacing.lg),
                // Hero heading
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'RIDE THE\n',
                        style: AppTextStyles.displayHero,
                      ),
                      TextSpan(
                        text: 'FUTURE',
                        style: AppTextStyles.displayHero.copyWith(
                          color: AppColors.accentLime,
                          shadows: [
                            Shadow(
                              color: AppColors.accentLime.withValues(alpha: 0.4),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Smart. Powerful. Sustainable.\nADMS Electric Scooters.',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.7,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 600.ms),
                const SizedBox(height: AppSpacing.xl),
                // CTAs
                Row(
                  children: [
                    AdmsButton(
                      label: 'Explore Models',
                      trailingIcon: Icons.arrow_forward,
                      onPressed: () => context.go(AppRouter.catalogue),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    AdmsButton(
                      label: 'Book Test Ride',
                      variant: AdmsButtonVariant.outline,
                      leadingIcon: Icons.directions_bike,
                      onPressed: () => context.go(AppRouter.testRide),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(delay: 800.ms, duration: 600.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: AppSpacing.xxl),
                // Stats row
                const _HeroStats(),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xxl),
          // Right — hero scooter image
          Expanded(
            flex: 6,
            child: _HeroScooterVisual()
                .animate()
                .fadeIn(delay: 300.ms, duration: 800.ms)
                .slideX(begin: 0.1, end: 0),
          ),
        ],
      ),
    );
  }
}

class _HeroMobileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pagePaddingMobile,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.paddingOf(context).top + 40),
          // Mobile logo
          const AdmsLogo(height: 40, showTagline: true)
              .animate()
              .fadeIn(duration: 600.ms),
          const SizedBox(height: AppSpacing.xl),
          // Hero image
          _HeroScooterVisual()
              .animate()
              .fadeIn(delay: 200.ms, duration: 600.ms),
          const SizedBox(height: AppSpacing.xl),
          // Heading
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'RIDE THE\n',
                  style: AppTextStyles.displayMedium,
                ),
                TextSpan(
                  text: 'FUTURE',
                  style: AppTextStyles.displayMedium.copyWith(
                    color: AppColors.accentLime,
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(delay: 300.ms, duration: 600.ms)
              .slideY(begin: 0.2, end: 0),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Smart. Powerful. Sustainable.\nADMS Electric Scooters.',
            style: AppTextStyles.bodyMedium,
          ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
          const SizedBox(height: AppSpacing.lg),
          AdmsButton(
            label: 'Explore Models',
            trailingIcon: Icons.arrow_forward,
            onPressed: () => context.go(AppRouter.catalogue),
            width: double.infinity,
          ).animate().fadeIn(delay: 500.ms, duration: 600.ms),
          const SizedBox(height: AppSpacing.sm),
          AdmsButton(
            label: 'Book Test Ride',
            variant: AdmsButtonVariant.outline,
            onPressed: () => context.go(AppRouter.testRide),
            width: double.infinity,
          ).animate().fadeIn(delay: 600.ms, duration: 600.ms),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _HeroScooterVisual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      decoration: BoxDecoration(
        borderRadius: AppRadius.xlBorderRadius,
        border: Border.all(
          color: AppColors.borderAccent.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentLime.withValues(alpha: 0.15),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/adms_gtr.jpg',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.backgroundSecondary,
              child: const Center(
                child: Icon(
                  Icons.electric_scooter,
                  size: 120,
                  color: AppColors.accentLime,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: AppRadius.smBorderRadius,
                border: Border.all(
                  color: AppColors.accentLime.withValues(alpha: 0.6),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.accentLime,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'FLAGSHIP: ADMS GTR',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.accentLime,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroStats extends StatelessWidget {
  const _HeroStats();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatItem(value: 'Long\nRange', label: ''),
        _divider(),
        _StatItem(value: 'Fast\nCharging', label: ''),
        _divider(),
        _StatItem(value: 'Eco\nFriendly', label: ''),
        _divider(),
        _StatItem(value: 'Trusted\nBrand', label: ''),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: AppColors.borderSubtle,
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textPrimary,
            fontSize: 13,
          ),
        ),
        if (label.isNotEmpty)
          Text(label, style: AppTextStyles.specLabel),
      ],
    );
  }
}

// ── Benefits ──────────────────────────────────────────────────────────────────
class _BenefitsSection extends StatelessWidget {
  final bool isDesktop;
  const _BenefitsSection({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final benefits = [
      (Icons.battery_charging_full, 'Long Range',
          'Travel further on a single charge with our high-capacity battery systems.'),
      (Icons.flash_on, 'Fast Charging',
          'Get back on the road quickly with intelligent fast-charging technology.'),
      (Icons.eco, 'Eco Friendly',
          'Zero emissions, cleaner cities. Ride green with ADMS.'),
      (Icons.verified, 'Trusted Brand',
          'Built to last with quality components and reliable after-sales support.'),
    ];

    final hPad = isDesktop
        ? AppSpacing.pagePaddingDesktop
        : AppSpacing.pagePaddingMobile;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: hPad,
        vertical: AppSpacing.xxl,
      ),
      decoration: BoxDecoration(
        border: const Border(
          top: BorderSide(color: AppColors.borderSubtle),
          bottom: BorderSide(color: AppColors.borderSubtle),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.backgroundSecondary,
            AppColors.backgroundPrimary,
          ],
        ),
      ),
      child: Column(
        children: [
          Text('Why ADMS?', style: AppTextStyles.headingLarge),
          const SizedBox(height: AppSpacing.xl),
          isDesktop
              ? Row(
                  children: benefits
                      .map((b) => Expanded(
                            child: _BenefitCard(
                              icon: b.$1,
                              title: b.$2,
                              description: b.$3,
                            ),
                          ))
                      .toList(),
                )
              : Column(
                  children: benefits
                      .map((b) => Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppSpacing.md),
                            child: _BenefitCard(
                              icon: b.$1,
                              title: b.$2,
                              description: b.$3,
                            ),
                          ))
                      .toList(),
                ),
        ],
      ),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _BenefitCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: AppRadius.lgBorderRadius,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.accentLimeSurface,
              borderRadius: AppRadius.smBorderRadius,
            ),
            child: Icon(icon, color: AppColors.accentLime, size: 24),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: AppTextStyles.headingSmall),
          const SizedBox(height: AppSpacing.sm),
          Text(description, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

// ── Featured Scooters ─────────────────────────────────────────────────────────
class _FeaturedScootersSection extends StatelessWidget {
  final bool isDesktop;
  const _FeaturedScootersSection({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    // Only show published scooters
    final featured = DemoData.scooters
        .where((s) => s.isPublished)
        .take(3)
        .toList();

    final hPad = isDesktop
        ? AppSpacing.pagePaddingDesktop
        : AppSpacing.pagePaddingMobile;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: hPad,
        vertical: AppSpacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Our Scooter Range',
                      style: AppTextStyles.headingLarge,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '⚠ Demo data — specifications not confirmed by ADMS.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.statusWarning,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () => context.go(AppRouter.catalogue),
                icon: const Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: AppColors.accentLime,
                ),
                label: Text(
                  'View All',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.accentLime,
                  ),
                ),
                iconAlignment: IconAlignment.end,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: featured
                  .map((s) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ScooterCard(
                            scooter: s,
                            onTap: () => context.go(
                              '/models/${s.slug}',
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            )
          else
            SizedBox(
              height: 410,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: featured.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.md),
                itemBuilder: (ctx, i) => SizedBox(
                  width: 280,
                  child: ScooterCard(
                    scooter: featured[i],
                    onTap: () => context.go(
                      '/models/${featured[i].slug}',
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── 3D Showroom CTA ───────────────────────────────────────────────────────────
class _ShowroomCtaSection extends StatelessWidget {
  final bool isDesktop;
  const _ShowroomCtaSection({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal:
            isDesktop ? AppSpacing.pagePaddingDesktop : AppSpacing.pagePaddingMobile,
        vertical: AppSpacing.xxl,
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/showroom_hero.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Color(0xDD0A0D05),
            BlendMode.darken,
          ),
        ),
        borderRadius: AppRadius.xlBorderRadius,
        border: Border.all(color: AppColors.borderAccent),
        boxShadow: [AppShadows.subtleGlow],
      ),
      child: isDesktop
          ? Row(
              children: [
                Expanded(child: _buildShowroomCtaText(context)),
                AdmsButton(
                  label: 'Enter 3D Showroom',
                  leadingIcon: Icons.view_in_ar,
                  onPressed: () => context.go(AppRouter.catalogue),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShowroomCtaText(context),
                const SizedBox(height: AppSpacing.lg),
                AdmsButton(
                  label: 'Enter 3D Showroom',
                  leadingIcon: Icons.view_in_ar,
                  onPressed: () => context.go(AppRouter.catalogue),
                  width: double.infinity,
                ),
              ],
            ),
    );
  }

  Widget _buildShowroomCtaText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.view_in_ar,
                color: AppColors.accentLime, size: 20),
            const SizedBox(width: 8),
            Text('3D SHOWROOM',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.accentLime,
                  letterSpacing: 2.0,
                )),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Explore Every Angle',
          style: AppTextStyles.headingLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Rotate, zoom, and inspect our scooters in real interactive 3D. '
          'View from any angle before you visit the showroom.',
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}

// ── Contact ───────────────────────────────────────────────────────────────────
class _ContactSection extends StatelessWidget {
  final bool isDesktop;
  const _ContactSection({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final hPad = isDesktop
        ? AppSpacing.pagePaddingDesktop
        : AppSpacing.pagePaddingMobile;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: hPad, vertical: AppSpacing.xxl),
      color: AppColors.backgroundSecondary,
      child: Column(
        children: [
          Text('Get in Touch', style: AppTextStyles.headingLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Contact details will be provided by the ADMS team.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textMuted,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AdmsButton(
            label: 'Book Test Ride / Enquire',
            trailingIcon: Icons.arrow_forward,
            onPressed: () => context.go(AppRouter.enquiry),
          ),
        ],
      ),
    );
  }
}

// ── Footer ────────────────────────────────────────────────────────────────────
class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 768;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop
            ? AppSpacing.pagePaddingDesktop
            : AppSpacing.pagePaddingMobile,
        vertical: AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border(top: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 12,
        children: [
          const AdmsLogo(height: 28),
          Text(
            '© 2025 ADMS Electric Mobility. All rights reserved.',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}
