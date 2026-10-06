import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shodasha_mineral_water/core/constants/app_constants.dart';
import 'package:shodasha_mineral_water/core/theme/app_theme.dart';
import 'package:shodasha_mineral_water/features/wallet/domain/entities/wallet_models.dart';
import 'package:shodasha_mineral_water/features/wallet/presentation/providers/wallet_provider.dart';

class CanInventoryLedger extends StatelessWidget {
  final VoidCallback? onProcessReturn;

  const CanInventoryLedger({super.key, this.onProcessReturn});

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(
      builder: (context, provider, _) {
        final inventory = provider.inventory;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Can Inventory',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  if (inventory.cansWithMe > 0)
                    TextButton.icon(
                      onPressed: onProcessReturn,
                      icon: Icon(Icons.assignment_return_rounded, size: 18, color: AppColors.primary),
                      label: Text(
                        'Return Cans',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(AppConstants.largePadding),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _InventoryMetric(
                            label: 'Cans with Me',
                            count: inventory.cansWithMe,
                            icon: Icons.local_drink_rounded,
                            color: AppColors.primary,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _InventoryMetric(
                            label: 'Returned Cans',
                            count: inventory.returnedCans,
                            icon: Icons.check_circle_rounded,
                            color: AppColors.success,
                            backgroundColor: AppColors.success.withOpacity(0.1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _InventoryMetric(
                            label: 'Pending Return',
                            count: inventory.pendingReturn,
                            icon: Icons.pending_rounded,
                            color: AppColors.accentDark,
                            backgroundColor: AppColors.accent.withOpacity(0.15),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(height: 1, color: AppColors.divider),
                    const SizedBox(height: 16),
                    if (inventory.lastReturnDate != null) ...[
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.history_rounded,
                              size: 22,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Last Return',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                                Text(
                                  _formatDate(inventory.lastReturnDate!),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          if (inventory.lastReturnStatus != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified_rounded, size: 16, color: AppColors.success),
                                  const SizedBox(width: 6),
                                  Text(
                                    inventory.lastReturnStatus!,
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          color: AppColors.success,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.info_outline_rounded,
                              size: 22,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'No returns recorded yet',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _InventoryMetric extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  const _InventoryMetric({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: color,
                  fontSize: 28,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}