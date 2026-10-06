import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shodasha_mineral_water/core/constants/app_constants.dart';
import 'package:shodasha_mineral_water/core/theme/app_theme.dart';
import 'package:shodasha_mineral_water/features/wallet/domain/entities/wallet_models.dart';
import 'package:shodasha_mineral_water/features/wallet/presentation/providers/wallet_provider.dart';

class TransactionHistoryList extends StatelessWidget {
  final bool showAll;

  const TransactionHistoryList({super.key, this.showAll = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(
      builder: (context, provider, _) {
        final transactions = provider.transactions;
        final displayTransactions = showAll ? transactions : transactions.take(5).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transaction History',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  if (!showAll && transactions.length > 5)
                    TextButton(
                      onPressed: () {
                        _showFullHistory(context, transactions);
                      },
                      child: Text(
                        'View All',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              if (transactions.isEmpty)
                _EmptyState()
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayTransactions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final transaction = displayTransactions[index];
                    return _TransactionTile(transaction: transaction);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _showFullHistory(BuildContext context, List<WalletTransaction> transactions) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FullHistorySheet(transactions: transactions),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final WalletTransaction transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _TransactionIcon(type: transaction.type),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        transaction.typeLabel,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      transaction.formattedAmount,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: transaction.isCredit ? AppColors.success : AppColors.error,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _formatDate(transaction.date),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    if (transaction.referenceId != null) ...[
                      const SizedBox(width: 12),
                      Text(
                        'Ref: ${transaction.referenceId}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          _StatusBadge(status: transaction.status),
        ],
      ),
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

class _TransactionIcon extends StatelessWidget {
  final TransactionType type;

  const _TransactionIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    Color backgroundColor;

    switch (type) {
      case TransactionType.depositPaid:
      case TransactionType.depositRefunded:
        icon = Icons.security_rounded;
        color = AppColors.primary;
        backgroundColor = AppColors.primary.withOpacity(0.1);
        break;
      case TransactionType.referralCredited:
        icon = Icons.people_rounded;
        color = AppColors.primary;
        backgroundColor = AppColors.primary.withOpacity(0.1);
        break;
      case TransactionType.promoCredited:
        icon = Icons.local_offer_rounded;
        color = AppColors.accentDark;
        backgroundColor = AppColors.accent.withOpacity(0.15);
        break;
      case TransactionType.orderPayment:
        icon = Icons.shopping_cart_rounded;
        color = AppColors.error;
        backgroundColor = AppColors.error.withOpacity(0.1);
        break;
      case TransactionType.canDepositDeducted:
        icon = Icons.local_drink_rounded;
        color = AppColors.accentDark;
        backgroundColor = AppColors.accent.withOpacity(0.15);
        break;
      case TransactionType.rewardRedeemed:
        icon = Icons.redeem_rounded;
        color = AppColors.accentDark;
        backgroundColor = AppColors.accent.withOpacity(0.15);
        break;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 22, color: color),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final TransactionStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;
    Color backgroundColor;
    IconData icon;

    switch (status) {
      case TransactionStatus.completed:
        label = 'Completed';
        color = AppColors.success;
        backgroundColor = AppColors.success.withOpacity(0.1);
        icon = Icons.check_circle_rounded;
        break;
      case TransactionStatus.pending:
        label = 'Pending';
        color = AppColors.accentDark;
        backgroundColor = AppColors.accent.withOpacity(0.15);
        icon = Icons.schedule_rounded;
        break;
      case TransactionStatus.failed:
        label = 'Failed';
        color = AppColors.error;
        backgroundColor = AppColors.error.withOpacity(0.1);
        icon = Icons.error_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.largePadding * 2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_rounded,
            size: 48,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'No transactions yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your wallet activity will appear here',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

class _FullHistorySheet extends StatelessWidget {
  final List<WalletTransaction> transactions;

  const _FullHistorySheet({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Row(
                  children: [
                    Text(
                      'All Transactions',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.divider),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  itemCount: transactions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return _TransactionTile(transaction: transactions[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}