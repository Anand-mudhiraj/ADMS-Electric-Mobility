import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/routing/app_router.dart';
import '../../../admin/dashboard/presentation/admin_shell.dart';

class AdminEnquiriesScreen extends StatelessWidget {
  const AdminEnquiriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      currentRoute: AppRouter.adminEnquiries,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enquiries & Test Rides', style: AppTextStyles.headingLarge),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.backgroundCard,
                borderRadius: AppRadius.lgBorderRadius,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.mail_outline,
                    size: 56,
                    color: AppColors.textMuted.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Enquiry Management',
                    style: AppTextStyles.headingMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Phase 6: Enquiries submitted via the customer form will appear here '
                    'once Supabase is connected. You will be able to update status, '
                    'contact customers, and track test-ride appointments.',
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundElevated,
                      borderRadius: AppRadius.smBorderRadius,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Status options that will be available:',
                            style: AppTextStyles.labelMedium),
                        const SizedBox(height: AppSpacing.sm),
                        ...[
                          ('New', AppColors.statusInfo),
                          ('Contacted', AppColors.statusWarning),
                          ('Scheduled', AppColors.accentLimeDark),
                          ('Completed', AppColors.statusSuccess),
                          ('Cancelled', AppColors.textMuted),
                        ].map((s) => Padding(
                              padding: const EdgeInsets.only(
                                  bottom: AppSpacing.xs),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      color: s.$2,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Text(s.$1, style: AppTextStyles.bodySmall),
                                ],
                              ),
                            )),
                      ],
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
