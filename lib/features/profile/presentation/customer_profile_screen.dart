import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import 'support_help_screen.dart';
import 'saved_addresses_screen.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: AppColors.textSecondary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: iconColor ?? AppColors.primary, size: 22),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
        ),
        subtitle: subtitle != null
            ? Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary))
            : null,
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
        onTap: onTap,
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
          'ACCOUNT & PROFILE',
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: AppColors.primary, size: 32),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Ayush Singh',
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.textPrimary),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF9C3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'GOLD TIER',
                                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF854D0E)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          '+91 98765 43210',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Bhopal Central Zone',
                          style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Active Bottles with You:',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                  ),
                  Text(
                    '4 Rented Cans',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF15803D)),
                  ),
                ],
              ),
            ),
            _buildSectionHeader('DELIVERY & LOCATIONS'),
            _buildTile(
              icon: Icons.location_on_outlined,
              title: 'Primary Delivery Location',
              subtitle: 'Flat 402, Arera Colony, Bhopal',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SavedAddressesScreen()),
                );
              },
            ),
            _buildTile(
              icon: Icons.access_time_rounded,
              title: 'Preferred Time Slot',
              subtitle: 'Morning (8:00 AM - 3:00 PM)',
              onTap: () {},
            ),
            _buildSectionHeader('PAYMENTS & LEDGER'),
            _buildTile(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Security Deposit Balance',
              subtitle: 'Rs 1500.00 (Refundable)',
              trailing: const Text(
                'Rs 1500',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppColors.primary),
              ),
              onTap: () {},
            ),
            _buildSectionHeader('QUALITY & PURITY GUARANTEE'),
            _buildTile(
              icon: Icons.verified_outlined,
              title: 'TDS & Purity Certificate',
              subtitle: 'Current Plant TDS: 110 ppm • ISO 9001:2015',
              iconColor: const Color(0xFF0284C7),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    title: const Text('Water Purity Specs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    content: const Text(
                      '• Plant: Govindpura Industrial Hub\n• Multi-Stage RO + UV + Ozonation\n• Packed in BPA-free Food Grade Cans\n• Batch Lab Tested Daily',
                      style: TextStyle(fontSize: 13, height: 1.5),
                    ),
                    actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
                  ),
                );
              },
            ),
            _buildSectionHeader('HELP & ASSISTANCE'),
            _buildTile(
              icon: Icons.support_agent_rounded,
              title: 'Customer Care & Plant Desk',
              subtitle: 'Instant WhatsApp & Call Support',
              iconColor: const Color(0xFF16A34A),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SupportHelpScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Shodasha Mineral Water v1.0.4 • Bhopal Plant Hub',
                style: TextStyle(color: AppColors.textSecondary.withOpacity(0.6), fontSize: 11),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}