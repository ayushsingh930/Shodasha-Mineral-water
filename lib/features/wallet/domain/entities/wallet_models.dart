import 'package:equatable/equatable.dart';

enum TransactionType {
  depositPaid,
  depositRefunded,
  referralCredited,
  promoCredited,
  orderPayment,
  canDepositDeducted,
  rewardRedeemed,
}

enum TransactionStatus {
  completed,
  pending,
  failed,
}

class WalletBalance extends Equatable {
  final double securityDeposit;
  final double referralEarnings;
  final double promoRewards;

  const WalletBalance({
    required this.securityDeposit,
    required this.referralEarnings,
    required this.promoRewards,
  });

  double get totalRewards => referralEarnings + promoRewards;
  double get totalBalance => securityDeposit + totalRewards;

  WalletBalance copyWith({
    double? securityDeposit,
    double? referralEarnings,
    double? promoRewards,
  }) {
    return WalletBalance(
      securityDeposit: securityDeposit ?? this.securityDeposit,
      referralEarnings: referralEarnings ?? this.referralEarnings,
      promoRewards: promoRewards ?? this.promoRewards,
    );
  }

  @override
  List<Object?> get props => [securityDeposit, referralEarnings, promoRewards];
}

class CanInventory extends Equatable {
  final int cansWithMe;
  final int returnedCans;
  final int pendingReturn;
  final DateTime? lastReturnDate;
  final String? lastReturnStatus;

  const CanInventory({
    required this.cansWithMe,
    required this.returnedCans,
    required this.pendingReturn,
    this.lastReturnDate,
    this.lastReturnStatus,
  });

  int get totalCans => cansWithMe + returnedCans + pendingReturn;

  CanInventory copyWith({
    int? cansWithMe,
    int? returnedCans,
    int? pendingReturn,
    DateTime? lastReturnDate,
    String? lastReturnStatus,
  }) {
    return CanInventory(
      cansWithMe: cansWithMe ?? this.cansWithMe,
      returnedCans: returnedCans ?? this.returnedCans,
      pendingReturn: pendingReturn ?? this.pendingReturn,
      lastReturnDate: lastReturnDate ?? this.lastReturnDate,
      lastReturnStatus: lastReturnStatus ?? this.lastReturnStatus,
    );
  }

  @override
  List<Object?> get props => [cansWithMe, returnedCans, pendingReturn, lastReturnDate, lastReturnStatus];
}

class WalletTransaction extends Equatable {
  final String id;
  final TransactionType type;
  final double amount;
  final String description;
  final DateTime date;
  final TransactionStatus status;
  final String? referenceId;

  const WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
    required this.status,
    this.referenceId,
  });

  bool get isCredit => type == TransactionType.depositPaid ||
      type == TransactionType.referralCredited ||
      type == TransactionType.promoCredited ||
      type == TransactionType.depositRefunded;

  bool get isDebit => type == TransactionType.orderPayment ||
      type == TransactionType.canDepositDeducted ||
      type == TransactionType.rewardRedeemed;

  String get formattedAmount {
    final sign = isCredit ? '+' : '-';
    return '$signRs ${amount.toStringAsFixed(2)}';
  }

  String get typeLabel {
    switch (type) {
      case TransactionType.depositPaid:
        return 'Deposit Paid';
      case TransactionType.depositRefunded:
        return 'Deposit Refunded';
      case TransactionType.referralCredited:
        return 'Referral Credited';
      case TransactionType.promoCredited:
        return 'Promo Credited';
      case TransactionType.orderPayment:
        return 'Order Payment';
      case TransactionType.canDepositDeducted:
        return 'Can Deposit Deducted';
      case TransactionType.rewardRedeemed:
        return 'Reward Redeemed';
    }
  }

  @override
  List<Object?> get props => [id, type, amount, description, date, status, referenceId];
}

class WalletState extends Equatable {
  final WalletBalance balance;
  final CanInventory inventory;
  final List<WalletTransaction> transactions;
  final bool isLoading;
  final String? error;

  const WalletState({
    required this.balance,
    required this.inventory,
    required this.transactions,
    this.isLoading = false,
    this.error,
  });

  WalletState copyWith({
    WalletBalance? balance,
    CanInventory? inventory,
    List<WalletTransaction>? transactions,
    bool? isLoading,
    String? error,
  }) {
    return WalletState(
      balance: balance ?? this.balance,
      inventory: inventory ?? this.inventory,
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [balance, inventory, transactions, isLoading, error];
}