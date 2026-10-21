import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/widgets/adms_button.dart';
import '../../../core/widgets/navigation.dart';
import '../../../data/services/demo_data.dart';
import '../../../data/models/scooter.dart';

class EnquiryScreen extends StatefulWidget {
  final bool isTestRide;
  final String? preselectedScooterId;
  final String? preselectedScooterName;

  const EnquiryScreen({
    super.key,
    this.isTestRide = false,
    this.preselectedScooterId,
    this.preselectedScooterName,
  });

  @override
  State<EnquiryScreen> createState() => _EnquiryScreenState();
}

class _EnquiryScreenState extends State<EnquiryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  String? _selectedScooterId;
  String? _selectedScooterName;
  bool _consented = false;
  bool _isSubmitting = false;
  bool _submitted = false;

  bool get _isDesktop => MediaQuery.sizeOf(context).width >= 1024;

  List<Scooter> get _publishedScooters =>
      DemoData.scooters.where((s) => s.isPublished).toList();

  @override
  void initState() {
    super.initState();
    _selectedScooterId = widget.preselectedScooterId;
    _selectedScooterName = widget.preselectedScooterName;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _cityCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_consented) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please consent to our privacy policy.'),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    // Simulate submission; Supabase integration in Phase 6
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isSubmitting = false;
      _submitted = true;
    });
  }

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
              title: Text(
                widget.isTestRide ? 'Book Test Ride' : 'Enquiry',
                style: AppTextStyles.headingSmall,
              ),
            ),
      bottomNavigationBar: _isDesktop
          ? null
          : MobileNavBar(
              currentIndex: 4,
              onTap: (i) {
                if (i == 0) context.go(AppRouter.home);
                if (i == 1) context.go(AppRouter.catalogue);
                if (i == 3) context.go(AppRouter.comparison);
              },
            ),
      body: _submitted ? _buildSuccessView() : _buildFormView(),
    );
  }

  Widget _buildFormView() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: _isDesktop ? 72 + 40.0 : 24,
        left: _isDesktop ? AppSpacing.pagePaddingDesktop : AppSpacing.pagePaddingMobile,
        right: _isDesktop ? AppSpacing.pagePaddingDesktop : AppSpacing.pagePaddingMobile,
        bottom: 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              if (_isDesktop)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                  child: Text(
                    widget.isTestRide
                        ? 'Book Test Ride'
                        : 'Book Test Ride / Enquiry',
                    style: AppTextStyles.headingLarge,
                  ),
                ),
              // Scooter preview card
              if (_selectedScooterName != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    gradient: AppColors.cardGradient,
                    borderRadius: AppRadius.lgBorderRadius,
                    border: Border.all(color: AppColors.borderAccent),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundElevated,
                          borderRadius: AppRadius.smBorderRadius,
                        ),
                        child: const Icon(
                          Icons.electric_scooter,
                          color: AppColors.accentLime,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedScooterName!,
                              style: AppTextStyles.headingSmall,
                            ),
                            Text(
                              'Electric Scooter',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              // Info text
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.backgroundCard,
                  borderRadius: AppRadius.smBorderRadius,
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Text(
                  'Fill in this form and our team will contact you soon.',
                  style: AppTextStyles.bodyMedium,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              // Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _FieldLabel('Your Name'),
                    TextFormField(
                      controller: _nameCtrl,
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'Enter your full name',
                        prefixIcon: Icon(Icons.person_outline, size: 20),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Name is required'
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _FieldLabel('Phone Number'),
                    TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: '+91 XXXXX XXXXX',
                        prefixIcon: Icon(Icons.phone_outlined, size: 20),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Phone number is required';
                        }
                        if (v.trim().length < 8) {
                          return 'Enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _FieldLabel('Your City'),
                    TextFormField(
                      controller: _cityCtrl,
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'e.g. Hyderabad',
                        prefixIcon: Icon(Icons.location_city_outlined, size: 20),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'City is required'
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _FieldLabel('Scooter Model (Optional)'),
                    DropdownButtonFormField<String?>(
                      initialValue: _selectedScooterId,
                      dropdownColor: AppColors.backgroundCard,
                      decoration: const InputDecoration(
                        prefixIcon:
                            Icon(Icons.electric_scooter, size: 20),
                      ),
                      hint: Text(
                        'Select a model',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.textMuted),
                      ),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('No preference'),
                        ),
                        ..._publishedScooters.map(
                          (s) => DropdownMenuItem<String?>(
                            value: s.id,
                            child: Text(
                              s.modelName,
                              style: AppTextStyles.bodyMedium
                                  .copyWith(color: AppColors.textPrimary),
                            ),
                          ),
                        ),
                      ],
                      onChanged: (v) => setState(() {
                        _selectedScooterId = v;
                        _selectedScooterName = _publishedScooters
                            .firstWhere((s) => s.id == v,
                                orElse: () => _publishedScooters.first)
                            .modelName;
                      }),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _FieldLabel('Message (Optional)'),
                    TextFormField(
                      controller: _messageCtrl,
                      maxLines: 4,
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'Any additional information...',
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Privacy consent
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _consented,
                          onChanged: (v) =>
                              setState(() => _consented = v ?? false),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'I agree to the privacy policy and consent to ADMS Electric Mobility '
                            'contacting me regarding my enquiry. My data will be handled in accordance '
                            'with applicable data protection regulations.',
                            style: AppTextStyles.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AdmsButton(
                      label: widget.isTestRide
                          ? 'Submit Test Ride Request'
                          : 'Submit Enquiry',
                      trailingIcon: Icons.arrow_forward,
                      isLoading: _isSubmitting,
                      onPressed: _submit,
                      width: double.infinity,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Submitting a request does not automatically confirm an appointment. '
                      'Our team will contact you to arrange details.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textMuted,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
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

  Widget _buildSuccessView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.statusSuccess.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.statusSuccess.withValues(alpha: 0.3)),
              ),
              child: const Icon(
                Icons.check,
                color: AppColors.statusSuccess,
                size: 40,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              widget.isTestRide
                  ? 'Test Ride Request Submitted!'
                  : 'Enquiry Submitted!',
              style: AppTextStyles.headingMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Thank you, ${_nameCtrl.text}. Our team will contact you at ${_phoneCtrl.text} shortly.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Note: This submission does not confirm an appointment.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textMuted,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            AdmsButton(
              label: 'Back to Home',
              onPressed: () => context.go(AppRouter.home),
            ),
            const SizedBox(height: AppSpacing.md),
            AdmsButton(
              label: 'Explore More Models',
              variant: AdmsButtonVariant.outline,
              onPressed: () => context.go(AppRouter.catalogue),
            ),
          ],
        ),
      ),
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
