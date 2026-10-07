import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class SupportHelpScreen extends StatelessWidget {
  const SupportHelpScreen({super.key});

  void _triggerAction(BuildContext context, String title, String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Text(msg, style: const TextStyle(fontSize: 13, height: 1.4)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildIssueTile(BuildContext context, {required IconData icon, required String title, required String desc}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text(desc, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
        onTap: () {
          _triggerAction(
            context,
            'Ticket Raised: $title',
            'Aapki query register ho gayi hai. Bhopal Hub team 15 minute ke andar contact karegi.',
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'PLANT HELP & SUPPORT',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.1,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Helpline Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF0F766E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Shodasha Bhopal Plant Desk',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Operating Hours: 6:00 AM - 9:00 PM (All 7 Days)',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF16A34A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            _triggerAction(
                              context,
                              'WhatsApp Support',
                              'Connecting to +91 755-SHODASHA on WhatsApp with priority queue.',
                            );
                          },
                          icon: const Icon(Icons.chat_bubble_rounded, size: 16),
                          label: const Text('WhatsApp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            _triggerAction(
                              context,
                              'Calling Helpline',
                              'Dialing Bhopal Central Plant Manager: +91 98260 00112',
                            );
                          },
                          icon: const Icon(Icons.phone, size: 16),
                          label: const Text('Direct Call', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'QUICK RESOLUTION ISSUES',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.textSecondary, letterSpacing: 0.8),
            ),
            const SizedBox(height: 10),

            _buildIssueTile(
              context,
              icon: Icons.access_time_filled_rounded,
              title: 'Water Delivery Delayed',
              desc: 'Van has not arrived in selected morning/evening slot',
            ),
            _buildIssueTile(
              context,
              icon: Icons.autorenew_rounded,
              title: 'Empty Can Balance Not Updated',
              desc: 'Returned cans not reflecting in Wallet Ledger',
            ),
            _buildIssueTile(
              context,
              icon: Icons.water_drop_rounded,
              title: 'Damaged Seal / Leaking Can',
              desc: 'Immediate replacement request with driver',
            ),
            _buildIssueTile(
              context,
              icon: Icons.pause_circle_filled_rounded,
              title: 'Pause Daily Subscription',
              desc: 'Going on vacation or out of town for few days',
            ),

            const SizedBox(height: 20),
            Center(
              child: Text(
                'Bhopal Industrial Hub Unit • ISO 9001:2015 Certified',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary.withOpacity(0.7)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}