import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/adms_button.dart';
import '../../../admin/dashboard/presentation/admin_shell.dart';

class AdminAddScooterScreen extends StatefulWidget {
  const AdminAddScooterScreen({super.key});

  @override
  State<AdminAddScooterScreen> createState() => _AdminAddScooterScreenState();
}

class _AdminAddScooterScreenState extends State<AdminAddScooterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _shortDescCtrl = TextEditingController();
  String? _selectedCategory;
  bool _priceOnRequest = true;
  final _priceCtrl = TextEditingController();
  // Specs
  final _rangeCtrl = TextEditingController();
  final _speedCtrl = TextEditingController();
  final _battVoltCtrl = TextEditingController();
  final _battCapCtrl = TextEditingController();
  final _motorCtrl = TextEditingController();
  final _chargeCtrl = TextEditingController();
  final _loadCtrl = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    for (final c in [
      _nameCtrl, _codeCtrl, _descCtrl, _shortDescCtrl, _priceCtrl,
      _rangeCtrl, _speedCtrl, _battVoltCtrl, _battCapCtrl,
      _motorCtrl, _chargeCtrl, _loadCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _saveDraft() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '⚠ Phase 6: Draft saving will be connected to Supabase. '
            'Not saved permanently yet.',
          ),
        ),
      );
      context.go(AppRouter.adminScooters);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      currentRoute: AppRouter.adminAddScooter,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add New Vehicle', style: AppTextStyles.headingLarge),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.statusWarning.withValues(alpha: 0.1),
                    borderRadius: AppRadius.smBorderRadius,
                    border: Border.all(
                        color:
                            AppColors.statusWarning.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    '⚠ Phase 6: Form submission will save to Supabase. '
                    'Uploads and database writes are not active yet.',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.statusWarning),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── Basic Info ─────────────────────────────────────────────
                _SectionHeader('Basic Information'),
                _FormRow(children: [
                  _FormField(
                    label: 'Model Name *',
                    controller: _nameCtrl,
                    hint: 'e.g. ADMS GTR',
                    validator: (v) => v!.trim().isEmpty ? 'Required' : null,
                  ),
                  _FormField(
                    label: 'Model Code',
                    controller: _codeCtrl,
                    hint: 'e.g. GTR-001',
                  ),
                ]),
                const SizedBox(height: AppSpacing.md),
                _FormRow(children: [
                  _FormField(
                    label: 'Category',
                    controller: TextEditingController(
                        text: _selectedCategory ?? ''),
                    hint: 'e.g. City Ride',
                    onChanged: (v) => _selectedCategory = v,
                  ),
                ]),
                const SizedBox(height: AppSpacing.md),
                _FieldLabel('Short Description'),
                TextFormField(
                  controller: _shortDescCtrl,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                      hintText: 'Brief tagline, 1–2 sentences'),
                ),
                const SizedBox(height: AppSpacing.md),
                _FieldLabel('Full Description'),
                TextFormField(
                  controller: _descCtrl,
                  maxLines: 5,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                      hintText: 'Detailed product description'),
                ),

                // ── Pricing ────────────────────────────────────────────────
                const SizedBox(height: AppSpacing.xl),
                _SectionHeader('Pricing'),
                Row(
                  children: [
                    Switch(
                      value: _priceOnRequest,
                      onChanged: (v) =>
                          setState(() => _priceOnRequest = v),
                    ),
                    const SizedBox(width: 8),
                    Text('Price on Request', style: AppTextStyles.bodyMedium),
                  ],
                ),
                if (!_priceOnRequest) ...[
                  const SizedBox(height: AppSpacing.md),
                  _FormField(
                    label: 'Price (₹)',
                    controller: _priceCtrl,
                    hint: 'e.g. 85000',
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (!_priceOnRequest &&
                          (v == null || v.trim().isEmpty)) {
                        return 'Enter a price or enable Price on Request';
                      }
                      return null;
                    },
                  ),
                ],

                // ── Specifications ─────────────────────────────────────────
                const SizedBox(height: AppSpacing.xl),
                _SectionHeader('Specifications'),
                _FormRow(children: [
                  _FormField(
                    label: 'Range (KM)',
                    controller: _rangeCtrl,
                    hint: 'e.g. 80',
                    keyboardType: TextInputType.number,
                  ),
                  _FormField(
                    label: 'Top Speed (KM/H)',
                    controller: _speedCtrl,
                    hint: 'e.g. 45',
                    keyboardType: TextInputType.number,
                  ),
                ]),
                const SizedBox(height: AppSpacing.md),
                _FormRow(children: [
                  _FormField(
                    label: 'Battery Voltage (V)',
                    controller: _battVoltCtrl,
                    hint: 'e.g. 60',
                    keyboardType: TextInputType.number,
                  ),
                  _FormField(
                    label: 'Battery Capacity (Ah)',
                    controller: _battCapCtrl,
                    hint: 'e.g. 26',
                    keyboardType: TextInputType.number,
                  ),
                ]),
                const SizedBox(height: AppSpacing.md),
                _FormRow(children: [
                  _FormField(
                    label: 'Motor Power (W)',
                    controller: _motorCtrl,
                    hint: 'e.g. 2500',
                    keyboardType: TextInputType.number,
                  ),
                  _FormField(
                    label: 'Charging Time (hrs)',
                    controller: _chargeCtrl,
                    hint: 'e.g. 3',
                    keyboardType: TextInputType.number,
                  ),
                ]),
                const SizedBox(height: AppSpacing.md),
                _FormField(
                  label: 'Load Capacity (KG)',
                  controller: _loadCtrl,
                  hint: 'e.g. 180',
                  keyboardType: TextInputType.number,
                ),

                // ── Uploads ────────────────────────────────────────────────
                const SizedBox(height: AppSpacing.xl),
                _SectionHeader('Media Uploads'),
                _UploadZone(
                  label: 'Upload 3D Model (GLB/GLTF)',
                  icon: Icons.view_in_ar,
                  hint: 'Drag & drop, or tap to browse. GLB files only.',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              '⚠ Phase 6: File upload will be connected to Supabase Storage.')),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                _UploadZone(
                  label: 'Upload Images',
                  icon: Icons.image_outlined,
                  hint: 'Thumbnail and gallery images. JPG/PNG, max 5 MB each.',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              '⚠ Phase 6: Image upload will be connected to Supabase Storage.')),
                    );
                  },
                ),

                // ── Actions ────────────────────────────────────────────────
                const SizedBox(height: AppSpacing.xxl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AdmsButton(
                      label: 'Cancel',
                      variant: AdmsButtonVariant.ghost,
                      onPressed: () =>
                          context.go(AppRouter.adminScooters),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    AdmsButton(
                      label: 'Save Draft',
                      variant: AdmsButtonVariant.outline,
                      isLoading: _isSaving,
                      onPressed: _saveDraft,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    AdmsButton(
                      label: 'Publish Vehicle',
                      isLoading: _isSaving,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  '⚠ Phase 6: Publication will validate and write to Supabase.')),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Helpers ────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.headingSmall),
          const SizedBox(height: 4),
          const Divider(color: AppColors.borderSubtle),
        ],
      ),
    );
  }
}

class _FormRow extends StatelessWidget {
  final List<Widget> children;
  const _FormRow({required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children
          .map((c) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: c,
                ),
              ))
          .toList(),
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const _FormField({
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: AppTextStyles.bodyMedium
              .copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(hintText: hint ?? ''),
          validator: validator,
          onChanged: onChanged,
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(label, style: AppTextStyles.labelMedium),
    );
  }
}

class _UploadZone extends StatefulWidget {
  final String label;
  final IconData icon;
  final String hint;
  final VoidCallback onTap;

  const _UploadZone({
    required this.label,
    required this.icon,
    required this.hint,
    required this.onTap,
  });

  @override
  State<_UploadZone> createState() => _UploadZoneState();
}

class _UploadZoneState extends State<_UploadZone> {
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
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.accentLimeSurface
                : AppColors.backgroundCard,
            borderRadius: AppRadius.lgBorderRadius,
            border: Border.all(
              color: _hovered
                  ? AppColors.borderAccent
                  : AppColors.borderMedium,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            children: [
              Icon(
                widget.icon,
                size: 36,
                color: _hovered ? AppColors.accentLime : AppColors.textMuted,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(widget.label,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: _hovered
                        ? AppColors.accentLime
                        : AppColors.textPrimary,
                  )),
              const SizedBox(height: 4),
              Text(widget.hint,
                  style: AppTextStyles.bodySmall,
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
