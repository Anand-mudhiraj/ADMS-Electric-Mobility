import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../../core/theme/theme.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/widgets/adms_button.dart';
import '../../../data/services/demo_data.dart';
import '../../../data/models/scooter.dart';

class Showroom3dScreen extends StatefulWidget {
  final String slug;
  const Showroom3dScreen({super.key, required this.slug});

  @override
  State<Showroom3dScreen> createState() => _Showroom3dScreenState();
}

class _Showroom3dScreenState extends State<Showroom3dScreen> {
  String? _selectedVariantId;

  Scooter? get _scooter => DemoData.getBySlug(widget.slug);

  @override
  Widget build(BuildContext context) {
    final scooter = _scooter;

    if (scooter == null) {
      return _ErrorView(
        message: 'Scooter not found.',
        onBack: () => context.go(AppRouter.catalogue),
      );
    }

    if (!scooter.has3dModel) {
      return _NoModelView(
        scooter: scooter,
        onBack: () => context.go('/models/${scooter.slug}'),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.go('/models/${scooter.slug}'),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(scooter.modelName, style: AppTextStyles.headingSmall),
            Text(
              '360° Interactive Showroom',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.accentLime,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.swipe,
                  size: 14,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  'Drag to rotate',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 3D Viewer
          ModelViewer(
            src: scooter.modelUrl3d!,
            alt: '${scooter.modelName} 3D model',
            ar: true, // enables AR on supported devices
            autoRotate: true,
            cameraControls: true,
            shadowIntensity: 1,
            shadowSoftness: 1,
            exposure: 1.0,
            loading: Loading.eager,
            reveal: Reveal.auto,
            backgroundColor: const Color(0xFF000000),
          ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomControls(
              scooter: scooter,
              selectedVariantId: _selectedVariantId,
              onVariantSelected: (id) =>
                  setState(() => _selectedVariantId = id),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomControls extends StatelessWidget {
  final Scooter scooter;
  final String? selectedVariantId;
  final ValueChanged<String?> onVariantSelected;

  const _BottomControls({
    required this.scooter,
    required this.selectedVariantId,
    required this.onVariantSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: AppColors.darkFadeBottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Colour variants
          if (scooter.colours.isNotEmpty) ...[
            Row(
              children: [
                Text('Colour:', style: AppTextStyles.labelMedium),
                const SizedBox(width: 12),
                ...scooter.colours.map((c) => GestureDetector(
                      onTap: () => onVariantSelected(c.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: const EdgeInsets.only(right: 8),
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Color(c.colorHex),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedVariantId == c.id
                                ? AppColors.accentLime
                                : AppColors.borderMedium,
                            width: selectedVariantId == c.id ? 2 : 1,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          // Action buttons
          Row(
            children: [
              Expanded(
                child: AdmsButton(
                  label: 'Enquire',
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

// ── Fallback: no model available ───────────────────────────────────────────────
class _NoModelView extends StatelessWidget {
  final Scooter scooter;
  final VoidCallback onBack;

  const _NoModelView({required this.scooter, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        title: Text(scooter.modelName,
            style: AppTextStyles.headingSmall),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.view_in_ar,
                size: 80,
                color: AppColors.textMuted.withValues(alpha: 0.3),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                '3D Model Not Available',
                style: AppTextStyles.headingMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'A 3D model for ${scooter.modelName} has not been uploaded yet.\n\n'
                'Administrators can upload a GLB or GLTF model file from the admin panel '
                'to enable interactive 3D viewing.',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              AdmsButton(
                label: 'Back to Details',
                variant: AdmsButtonVariant.outline,
                onPressed: onBack,
              ),
              const SizedBox(height: AppSpacing.md),
              AdmsButton(
                label: 'Book Test Ride',
                onPressed: () => context.go(
                  AppRouter.testRide,
                  extra: {
                    'scooterId': scooter.id,
                    'scooterName': scooter.modelName,
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onBack;

  const _ErrorView({required this.message, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline,
                color: AppColors.statusError, size: 56),
            const SizedBox(height: AppSpacing.lg),
            Text(message, style: AppTextStyles.headingSmall),
            const SizedBox(height: AppSpacing.lg),
            AdmsButton(
              label: 'Go Back',
              variant: AdmsButtonVariant.outline,
              onPressed: onBack,
            ),
          ],
        ),
      ),
    );
  }
}
