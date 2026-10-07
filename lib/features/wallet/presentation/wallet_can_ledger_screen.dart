import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class WalletCanLedgerScreen extends StatefulWidget {
  const WalletCanLedgerScreen({super.key});

  @override
  State<WalletCanLedgerScreen> createState() => _WalletCanLedgerScreenState();
}

class _WalletCanLedgerScreenState extends State<WalletCanLedgerScreen> {
  double _depositBalance = 1500.0;
  int _activeCansWithUser = 4;
  Map<String, dynamic>? _activeRefundTicket;

  final List<Map<String, dynamic>> _ledgerLogs = [
    {
      'title': 'Can Return Refund Credited',
      'sub': '2 Cans returned to hub driver Suresh',
      'date': '04-Oct-2026',
      'amount': '+ Rs 300.00',
      'isCredit': true,
      'icon': Icons.autorenew_rounded,
    },
    {
      'title': 'New Can Security Hold',
      'sub': 'Issued 2 Extra 20L chilled cans',
      'date': '01-Oct-2026',
      'amount': '- Rs 300.00',
      'isCredit': false,
      'icon': Icons.water_drop_rounded,
    },
    {
      'title': 'Deposit Recharged via UPI',
      'sub': 'Google Pay / Bhopal Plant Gateway',
      'date': '25-Sep-2026',
      'amount': '+ Rs 1000.00',
      'isCredit': true,
      'icon': Icons.account_balance_wallet_rounded,
    },
  ];

  void _showTopUpSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recharge Security Deposit', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(sheetCtx)),
                ],
              ),
              const SizedBox(height: 4),
              const Text('100% refundable deposit for renting 20L BPA-free cans.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 20),
              Row(
                children: [500, 1000, 1500].map((amt) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          setState(() {
                            _depositBalance += amt;
                            _ledgerLogs.insert(0, {
                              'title': 'Deposit Recharged (UPI)',
                              'sub': 'Fast Top-up completed',
                              'date': 'Today',
                              'amount': '+ Rs ${amt.toStringAsFixed(2)}',
                              'isCredit': true,
                              'icon': Icons.add_circle_outline_rounded,
                            });
                          });
                          Navigator.pop(sheetCtx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(backgroundColor: const Color(0xFF15803D), content: Text('Rs $amt added to Security Balance!')),
                          );
                        },
                        child: Text('+ Rs $amt', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12.5)),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showRefundClaimModal() {
    final upiController = TextEditingController();
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetCtx) {
        return Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.verified_user_rounded, color: Color(0xFF16A34A), size: 24),
                        SizedBox(width: 8),
                        Text('Zero-Fraud UPI Refund', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                      ],
                    ),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(sheetCtx)),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('All cans returned. Deposit will be credited to bank via UPI in 48-72h.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Refundable Amount:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      Text('Rs ${_depositBalance.toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF15803D))),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Account Holder Banking Name',
                    hintText: 'e.g. Ayush Singh',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter registered bank name' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: upiController,
                  decoration: InputDecoration(
                    labelText: 'Customer UPI ID / VPA',
                    hintText: 'e.g. ayush@okaxis / 9876543210@paytm',
                    prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (val) => (val == null || !val.contains('@')) ? 'Please enter a valid UPI ID (e.g. name@bank)' : null,
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.pop(sheetCtx);
                        _showOtpVerificationDialog(upiId: upiController.text.trim(), name: nameController.text.trim());
                      }
                    },
                    child: const Text('VERIFY & INITIATE REFUND', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showOtpVerificationDialog({required String upiId, required String name}) {
    final otpController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dlgCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: const [
            Icon(Icons.shield_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Security OTP Auth', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter 4-digit PIN sent to registered mobile (+91 98765 43210):', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 14),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 8),
              decoration: InputDecoration(
                hintText: '4 8 2 1',
                counterText: '',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dlgCtx), child: const Text('CANCEL')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(dlgCtx);
              setState(() {
                _activeRefundTicket = {
                  'ticketId': '#REF-BHOPAL-108',
                  'upiId': upiId,
                  'name': name,
                  'amount': _depositBalance,
                  'date': 'Today',
                  'status': 'Processing (48-72h SLA)',
                };
                _depositBalance = 0.0;
                _ledgerLogs.insert(0, {
                  'title': 'Deposit Refund Claim Submitted',
                  'sub': 'UPI: $upiId ($name)',
                  'date': 'Today',
                  'amount': 'Processing',
                  'isCredit': false,
                  'icon': Icons.pending_actions_rounded,
                });
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(backgroundColor: Color(0xFF15803D), content: Text('Refund Ticket #REF-BHOPAL-108 generated successfully!')),
              );
            },
            child: const Text('CONFIRM', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool canClaimRefund = (_activeCansWithUser == 0) && (_depositBalance > 0);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'WALLET & CAN LEDGER',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.1, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF0D9488)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
                boxShadow: [
                  BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('SECURITY DEPOSIT BALANCE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white70, letterSpacing: 0.8)),
                      Icon(Icons.shield_outlined, color: Colors.white70, size: 20),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Rs ${_depositBalance.toStringAsFixed(2)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white)),
                  const SizedBox(height: 4),
                  const Text('100% Refundable on bottle return', style: TextStyle(fontSize: 11.5, color: Colors.white70)),
                  const Divider(color: Colors.white24, height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          onPressed: _showTopUpSheet,
                          icon: const Icon(Icons.add_circle, size: 16),
                          label: const Text('Add Deposit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: canClaimRefund ? const Color(0xFF22C55E) : Colors.white12,
                            foregroundColor: canClaimRefund ? Colors.white : Colors.white54,
                            elevation: canClaimRefund ? 3 : 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: canClaimRefund
                              ? _showRefundClaimModal
                              : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Pehele apne $_activeCansWithUser Cans return karein. Driver verify karne ke baad refund unlock hoga.')),
                                  );
                                },
                          icon: Icon(canClaimRefund ? Icons.add_circle_outline_rounded : Icons.lock_outline_rounded, size: 16),
                          label: Text(canClaimRefund ? 'CLAIM REFUND +' : 'Refund (Locked)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _activeCansWithUser == 0 ? const Color(0xFFBBF7D0) : AppColors.border, width: _activeCansWithUser == 0 ? 1.5 : 1.0),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          color: _activeCansWithUser == 0 ? const Color(0xFFDCFCE7) : AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _activeCansWithUser == 0 ? Icons.check_circle_rounded : Icons.water_drop_rounded,
                          color: _activeCansWithUser == 0 ? const Color(0xFF16A34A) : AppColors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _activeCansWithUser == 0 ? '0 Cans with User (All Bottles Returned)' : '$_activeCansWithUser Cans Rented at Your Home',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              _activeCansWithUser == 0 ? 'Verified by Hub Agent • Ready for Instant Refund' : 'Bhopal Central Hub • 20L Food-Grade Plastic',
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Simulate Driver Can Pickup:', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                      TextButton.icon(
                        style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                        onPressed: () {
                          setState(() {
                            _activeCansWithUser = (_activeCansWithUser > 0) ? 0 : 4;
                          });
                        },
                        icon: Icon(_activeCansWithUser == 0 ? Icons.undo_rounded : Icons.delivery_dining_rounded, size: 14),
                        label: Text(_activeCansWithUser == 0 ? 'Reset to 4 Cans' : 'Return All 4 Cans', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_activeRefundTicket != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF86EFAC), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_activeRefundTicket!['ticketId'], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF166534))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
                          child: const Text('ETA: 48-72 HOURS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF15803D))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Refund of Rs ${_activeRefundTicket!['amount']} initiated to UPI: ${_activeRefundTicket!['upiId']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF14532D))),
                    const SizedBox(height: 4),
                    Text('Account Holder: ${_activeRefundTicket!['name']} • Bhopal Desk Payout Queue', style: const TextStyle(fontSize: 11, color: Color(0xFF166534))),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            const Text('LEDGER & TRANSACTION HISTORY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.textSecondary, letterSpacing: 0.8)),
            const SizedBox(height: 10),
            ..._ledgerLogs.map((log) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      color: (log['isCredit'] as bool) ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      log['icon'] as IconData,
                      color: (log['isCredit'] as bool) ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(log['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                        Text('${log['sub']} • ${log['date']}', style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Text(
                    log['amount'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 12.5,
                      color: (log['isCredit'] as bool) ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}