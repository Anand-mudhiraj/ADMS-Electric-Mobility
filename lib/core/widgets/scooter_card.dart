import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/theme.dart';
import '../../data/models/scooter.dart';

/// Scooter card for the catalogue grid
class ScooterCard extends StatefulWidget {
  final Scooter scooter;
  final VoidCallback? onTap;
  final VoidCallback? onViewIn3d;

  const ScooterCard({
    super.key,
    required this.scooter,
    this.onTap,
    this.onViewIn3d,
  });

  @override
  State<ScooterCard> createState() => _ScooterCardState();
}

class _ScooterCardState extends State<ScooterCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: AppColors.cardGradient,
            borderRadius: AppRadius.lgBorderRadius,
            border: Border.all(
              color: _isHovered
                  ? AppColors.borderAccent
                  : AppColors.borderSubtle,
              width: 1.0,
            ),
            boxShadow: _isHovered
                ? [AppShadows.cardShadow, AppShadows.subtleGlow]
                : [AppShadows.cardShadow],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image area
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.lg),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Stack(
                    children: [
                      _buildImage(),
                      // Category badge
                      if (widget.scooter.category != null)
                        Positioned(
                          top: 12,
                          left: 12,
                          child: _CategoryBadge(
                            label: widget.scooter.category!),
                        ),
                      // 3D badge
                      if (widget.scooter.has3dModel)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.accentLimeSurface,
                              borderRadius: AppRadius.smBorderRadius,
                              border: Border.all(
                                  color: AppColors.borderAccent),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.view_in_ar,
                                  size: 12,
                                  color: AppColors.accentLime,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '3D',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.accentLime,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.scooter.modelName,
                      style: AppTextStyles.headingSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.scooter.shortDescription != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.scooter.shortDescription!,
                        style: AppTextStyles.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 12),
                    // Mini specs row
                    if (widget.scooter.specs != null)
                      _MiniSpecsRow(specs: widget.scooter.specs!),
                    const SizedBox(height: 12),
                    // Price and CTA row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.scooter.displayPrice,
                            style: AppTextStyles.priceTag
                                .copyWith(fontSize: 16),
                          ),
                        ),
                        _CardActionButton(
                          label: 'Details',
                          onTap: widget.onTap,
                        ),
                      ],
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

  Widget _buildImage() {
    final url = widget.scooter.thumbnailUrl;
    if (url != null && url.isNotEmpty) {
      if (url.startsWith('assets/')) {
        return Image.asset(
          url,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (_, __, ___) => _imageFallback(),
        );
      }
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        width: double.infinity,
        placeholder: (_, __) => _shimmerPlaceholder(),
        errorWidget: (_, __, ___) => _imageFallback(),
      );
    }
    return _imageFallback();
  }

  Widget _shimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: AppColors.backgroundCard,
      highlightColor: AppColors.backgroundElevated,
      child: Container(color: AppColors.backgroundCard),
    );
  }

  Widget _imageFallback() {
    return Container(
      color: AppColors.backgroundSecondary,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.electric_scooter,
              size: 64,
              color: AppColors.textMuted.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 8),
            Text(
              widget.scooter.modelName,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textMuted.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String label;
  const _CategoryBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.backgroundOverlay,
        borderRadius: AppRadius.smBorderRadius,
        border: Border.all(color: AppColors.borderMedium),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _MiniSpecsRow extends StatelessWidget {
  final ScooterSpecs specs;
  const _MiniSpecsRow({required this.specs});

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, String, String)>[];

    if (specs.rangeKm != null && specs.rangeKm!.isNotEmpty) {
      items.add((Icons.route, specs.rangeKm!, 'KM'));
    }
    if (specs.topSpeedKmh != null && specs.topSpeedKmh!.isNotEmpty) {
      items.add((Icons.speed, specs.topSpeedKmh!, 'KM/H'));
    }
    if (specs.motorPowerW != null && specs.motorPowerW!.isNotEmpty) {
      items.add((Icons.bolt, specs.motorPowerW!, 'W'));
    }

    if (items.isEmpty) return const SizedBox.shrink();

    return Row(
      children: items.take(3).map((item) {
        final val = item.$2.length > 5 && !RegExp(r'^\d+$').hasMatch(item.$2)
            ? '—'
            : item.$2;
        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(item.$1, size: 12, color: AppColors.accentLime),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      val,
                      style: AppTextStyles.specValue.copyWith(fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Text(item.$3, style: AppTextStyles.specLabel),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _CardActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _CardActionButton({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.accentLimeSurface,
          borderRadius: AppRadius.smBorderRadius,
          border: Border.all(color: AppColors.borderAccent),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.accentLime,
          ),
        ),
      ),
    );
  }
}
