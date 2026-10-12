import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'SHODASHA WALLET',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white, letterSpacing: 1.1),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          // Wallet Balance Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('AVAILABLE BALANCE', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
                    Icon(Icons.account_balance_wallet, color: Colors.white70),
                  ],
                ),
                const SizedBox(height: 10),
                const Text('₹450.00', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Recharge Gateway will open shortly')),
                    );
                  },
                  icon: const Icon(Icons.add, color: AppColors.primary),
                  label: const Text('Add Money', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Can Security Deposit Ledger Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('CAN SECURITY LEDGER', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF64748B))),
                    Text('2 Cans Held', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF16A34A))),
                  ],
                ),
                SizedBox(height: 8),
                Text('Refundable Deposit: ₹300 (₹150/can)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                SizedBox(height: 4),
                Text('Deposit is refunded to your wallet when cans are returned to the rider.', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Recent Passbook / Transactions
          const Text('RECENT TRANSACTIONS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF64748B), letterSpacing: 0.8)),
          const SizedBox(height: 12),
          _TransactionTile(
            title: 'Water Delivery #ORD-892',
            date: 'Today, 08:30 AM',
            amount: '-₹65.00',
            isDebit: true,
          ),
          _TransactionTile(
            title: 'Wallet Recharge (UPI)',
            date: 'Yesterday, 05:12 PM',
            amount: '+₹500.00',
            isDebit: false,
          ),
          _TransactionTile(
            title: 'Empty Can Deposit Refund',
            date: '10 Oct 2026',
            amount: '+₹150.00',
            isDebit: false,
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final String title;
  final String date;
  final String amount;
  final bool isDebit;

  const _TransactionTile({
    required this.title,
    required this.date,
    required this.amount,
    required this.isDebit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isDebit ? const Color(0xFFFEE2E2) : const Color(0xFFDCFCE7),
          child: Icon(
            isDebit ? Icons.arrow_outward : Icons.arrow_downward,
            color: isDebit ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
            size: 18,
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
        subtitle: Text(date, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
        trailing: Text(
          amount,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 14,
            color: isDebit ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
          ),
        ),
      ),
    );
  }
}