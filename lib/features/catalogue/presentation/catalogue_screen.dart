import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/widgets/adms_button.dart';
import '../../../core/widgets/scooter_card.dart';
import '../../../core/widgets/navigation.dart';
import '../../../data/services/demo_data.dart';
import '../../../data/models/scooter.dart';

class CatalogueScreen extends StatefulWidget {
  const CatalogueScreen({super.key});

  @override
  State<CatalogueScreen> createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends State<CatalogueScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;
  String _sortBy = 'name';

  bool get _isDesktop => MediaQuery.sizeOf(context).width >= 1024;

  List<Scooter> get _filteredScooters {
    var list = DemoData.scooters.where((s) => s.isPublished).toList();

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((s) =>
              s.modelName.toLowerCase().contains(q) ||
              (s.shortDescription?.toLowerCase().contains(q) ?? false) ||
              (s.description?.toLowerCase().contains(q) ?? false))
          .toList();
    }

    if (_selectedCategory != null) {
      list = list.where((s) => s.category == _selectedCategory).toList();
    }

    list.sort((a, b) {
      switch (_sortBy) {
        case 'name':
          return a.modelName.compareTo(b.modelName);
        default:
          return a.modelName.compareTo(b.modelName);
      }
    });

    return list;
  }

  List<String> get _categories {
    return DemoData.scooters
        .where((s) => s.isPublished && s.category != null)
        .map((s) => s.category!)
        .toSet()
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: _isDesktop ? const DesktopNavBar() : _mobileAppBar(),
      bottomNavigationBar: _isDesktop
          ? null
          : MobileNavBar(
              currentIndex: 1,
              onTap: (i) {
                switch (i) {
                  case 0:
                    context.go(AppRouter.home);
                  case 1:
                    break;
                  case 3:
                    context.go(AppRouter.comparison);
                  case 4:
                    context.go(AppRouter.enquiry);
                }
              },
            ),
      body: Column(
        children: [
          if (_isDesktop) const SizedBox(height: 72),
          _buildSearchAndFilter(),
          Expanded(child: _buildGrid()),
        ],
      ),
    );
  }

  PreferredSizeWidget _mobileAppBar() {
    return AppBar(
      backgroundColor: AppColors.backgroundPrimary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => context.go(AppRouter.home),
      ),
      title: Text('Models', style: AppTextStyles.headingSmall),
      actions: [
        IconButton(
          icon: const Icon(Icons.compare_arrows, color: AppColors.textSecondary),
          onPressed: () => context.go(AppRouter.comparison),
          tooltip: 'Compare',
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    final hPad = _isDesktop
        ? AppSpacing.pagePaddingDesktop
        : AppSpacing.pagePaddingMobile;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: hPad, vertical: AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_isDesktop)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                '⚠ Demo data — not confirmed by ADMS',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.statusWarning),
              ),
            ),
          Row(
            children: [
              // Search bar
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textPrimary),
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search models...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Sort
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.backgroundElevated,
                  borderRadius: AppRadius.smBorderRadius,
                  border: Border.all(color: AppColors.borderMedium),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _sortBy,
                    dropdownColor: AppColors.backgroundCard,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textPrimary),
                    items: const [
                      DropdownMenuItem(value: 'name', child: Text('Name')),
                    ],
                    onChanged: (v) =>
                        setState(() => _sortBy = v ?? 'name'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Category filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: _selectedCategory == null,
                  onTap: () =>
                      setState(() => _selectedCategory = null),
                ),
                ..._categories.map((c) => _FilterChip(
                      label: c,
                      isSelected: _selectedCategory == c,
                      onTap: () =>
                          setState(() => _selectedCategory = c),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    final scooters = _filteredScooters;
    final hPad = _isDesktop
        ? AppSpacing.pagePaddingDesktop
        : AppSpacing.pagePaddingMobile;

    if (scooters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textMuted.withValues(alpha: 0.4),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('No models found', style: AppTextStyles.headingSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Try adjusting your search or filters.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            AdmsButton(
              label: 'Clear Filters',
              variant: AdmsButtonVariant.outline,
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _selectedCategory = null;
                });
              },
            ),
          ],
        ),
      );
    }

    final crossAxisCount = _isDesktop ? 3 : 1;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: hPad, vertical: AppSpacing.lg),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: _isDesktop ? 0.78 : 1.2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
        ),
        itemCount: scooters.length,
        itemBuilder: (ctx, i) {
          final s = scooters[i];
          return ScooterCard(
            scooter: s,
            onTap: () => context.go('/models/${s.slug}'),
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accentLimeSurface
              : AppColors.backgroundElevated,
          borderRadius: AppRadius.smBorderRadius,
          border: Border.all(
            color: isSelected
                ? AppColors.borderAccent
                : AppColors.borderMedium,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: isSelected
                ? AppColors.accentLime
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
