import 'package:flutter/material.dart';
import '../theme/theme.dart';

enum AdmsButtonVariant { primary, secondary, outline, ghost }

class AdmsButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final AdmsButtonVariant variant;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool isLoading;
  final double? width;

  const AdmsButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AdmsButtonVariant.primary,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.width,
  });

  @override
  State<AdmsButton> createState() => _AdmsButtonState();
}

class _AdmsButtonState extends State<AdmsButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnim = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _backgroundColor {
    switch (widget.variant) {
      case AdmsButtonVariant.primary:
        return AppColors.accentLime;
      case AdmsButtonVariant.secondary:
        return AppColors.backgroundElevated;
      case AdmsButtonVariant.outline:
        return Colors.transparent;
      case AdmsButtonVariant.ghost:
        return Colors.transparent;
    }
  }

  Color get _foregroundColor {
    switch (widget.variant) {
      case AdmsButtonVariant.primary:
        return AppColors.textInverse;
      case AdmsButtonVariant.secondary:
        return AppColors.textPrimary;
      case AdmsButtonVariant.outline:
        return AppColors.textPrimary;
      case AdmsButtonVariant.ghost:
        return AppColors.accentLime;
    }
  }

  Border? get _border {
    switch (widget.variant) {
      case AdmsButtonVariant.outline:
        return Border.all(color: AppColors.borderStrong, width: 1.5);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;
    return GestureDetector(
      onTapDown: (_) => _controller.reverse(),
      onTapUp: (_) => _controller.forward(),
      onTapCancel: () => _controller.forward(),
      onTap: isDisabled ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: child,
        ),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isDisabled ? 0.5 : 1.0,
          child: Container(
            width: widget.width,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: AppRadius.smBorderRadius,
              border: _border,
              boxShadow: widget.variant == AdmsButtonVariant.primary
                  ? [AppShadows.accentGlow]
                  : null,
            ),
            child: Row(
              mainAxisSize: widget.width != null
                  ? MainAxisSize.max
                  : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.isLoading) ...[
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: _foregroundColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                if (!widget.isLoading && widget.leadingIcon != null) ...[
                  Icon(widget.leadingIcon, size: 18, color: _foregroundColor),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.label.toUpperCase(),
                  style: AppTextStyles.buttonText.copyWith(
                    color: _foregroundColor,
                  ),
                ),
                if (!widget.isLoading && widget.trailingIcon != null) ...[
                  const SizedBox(width: 8),
                  Icon(widget.trailingIcon, size: 18, color: _foregroundColor),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
