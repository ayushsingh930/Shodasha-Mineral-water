import 'package:flutter/foundation.dart';
import 'package:shodasha_mineral_water/features/wallet/domain/entities/wallet_models.dart';

class WalletProvider extends ChangeNotifier {
  WalletState _state = const WalletState(
    balance: WalletBalance(
      securityDeposit: 0.0,
      referralEarnings: 0.0,
      promoRewards: 0.0,
    ),
    inventory: CanInventory(
      cansWithMe: 0,
      returnedCans: 0,
      pendingReturn: 0,
    ),
    transactions: [],
  );

  WalletState get state => _state;
  WalletBalance get balance => _state.balance;
  CanInventory get inventory => _state.inventory;
  List<WalletTransaction> get transactions => _state.transactions;
  bool get isLoading => _state.isLoading;
  String? get error => _state.error;

  void addSecurityDeposit(double amount) {
    _state = _state.copyWith(
      balance: _state.balance.copyWith(
        securityDeposit: _state.balance.securityDeposit + amount,
      ),
      transactions: [
        WalletTransaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: TransactionType.depositPaid,
          amount: amount,
          description: 'Security deposit added',
          date: DateTime.now(),
          status: TransactionStatus.completed,
        ),
        ..._state.transactions,
      ],
    );
    notifyListeners();
  }

  void redeemRewardsOnOrder(double amount) {
    if (amount > _state.balance.totalRewards) return;
    
    final referralUsed = amount.clamp(0.0, _state.balance.referralEarnings);
    final promoUsed = amount - referralUsed;

    _state = _state.copyWith(
      balance: _state.balance.copyWith(
        referralEarnings: _state.balance.referralEarnings - referralUsed,
        promoRewards: _state.balance.promoRewards - promoUsed,
      ),
      transactions: [
        WalletTransaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: TransactionType.rewardRedeemed,
          amount: amount,
          description: 'Rewards redeemed on order',
          date: DateTime.now(),
          status: TransactionStatus.completed,
        ),
        ..._state.transactions,
      ],
    );
    notifyListeners();
  }

  void processCanReturn(int count) {
    if (count > _state.inventory.cansWithMe) return;

    _state = _state.copyWith(
      inventory: _state.inventory.copyWith(
        cansWithMe: _state.inventory.cansWithMe - count,
        pendingReturn: _state.inventory.pendingReturn + count,
        lastReturnDate: DateTime.now(),
        lastReturnStatus: 'Pending',
      ),
    );
    notifyListeners();
  }

  void confirmCanReturn(int count) {
    if (count > _state.inventory.pendingReturn) return;

    _state = _state.copyWith(
      inventory: _state.inventory.copyWith(
        pendingReturn: _state.inventory.pendingReturn - count,
        returnedCans: _state.inventory.returnedCans + count,
        lastReturnDate: DateTime.now(),
        lastReturnStatus: 'Completed',
      ),
      transactions: [
        WalletTransaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: TransactionType.depositRefunded,
          amount: count * 100.0,
          description: 'Returned $count empty can(s)',
          date: DateTime.now(),
          status: TransactionStatus.completed,
        ),
        ..._state.transactions,
      ],
    );
    notifyListeners();
  }

  void addReferralReward(double amount) {
    _state = _state.copyWith(
      balance: _state.balance.copyWith(
        referralEarnings: _state.balance.referralEarnings + amount,
      ),
      transactions: [
        WalletTransaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: TransactionType.referralCredited,
          amount: amount,
          description: 'Referral reward credited',
          date: DateTime.now(),
          status: TransactionStatus.completed,
        ),
        ..._state.transactions,
      ],
    );
    notifyListeners();
  }

  void addPromoReward(double amount) {
    _state = _state.copyWith(
      balance: _state.balance.copyWith(
        promoRewards: _state.balance.promoRewards + amount,
      ),
      transactions: [
        WalletTransaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: TransactionType.promoCredited,
          amount: amount,
          description: 'Promotional reward credited',
          date: DateTime.now(),
          status: TransactionStatus.completed,
        ),
        ..._state.transactions,
      ],
    );
    notifyListeners();
  }

  void deductCanDeposit(int count) {
    _state = _state.copyWith(
      balance: _state.balance.copyWith(
        securityDeposit: _state.balance.securityDeposit - (count * 100.0),
      ),
      inventory: _state.inventory.copyWith(
        cansWithMe: _state.inventory.cansWithMe + count,
      ),
      transactions: [
        WalletTransaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: TransactionType.canDepositDeducted,
          amount: count * 100.0,
          description: 'Can deposit for $count new can(s)',
          date: DateTime.now(),
          status: TransactionStatus.completed,
        ),
        ..._state.transactions,
      ],
    );
    notifyListeners();
  }
}