import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../orders/presentation/rider_dashboard_screen.dart';
import '../../orders/presentation/plant_hub_screen.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'ACCOUNT & SETTINGS',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white, letterSpacing: 1.1),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          // User Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary.withOpacity(0.12),
                  child: const Text('AS', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.primary, fontSize: 18)),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ayush Singh', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.textPrimary)),
                      SizedBox(height: 2),
                      Text('+91 98930 12345', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(8)),
                  child: const Text('VERIFIED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF15803D))),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ENTERPRISE ROLE SWITCHER (SHODASHA BRAND THEME)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
              border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'MNC ENTERPRISE SUITE',
                        style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w900),
                      ),
                    ),
                    const Icon(Icons.corporate_fare_rounded, color: AppColors.primary, size: 22),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Enterprise Operational Consoles',
                  style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w900, fontSize: 15),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Switch between Van Fleet Cockpit and Bhopal Factory Inventory Hub.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const RiderDashboardScreen()),
                            );
                          },
                          icon: const Icon(Icons.delivery_dining, size: 18),
                          label: const Text(
                            'RIDER FLEET',
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const PlantHubScreen()),
                            );
                          },
                          icon: const Icon(Icons.factory_rounded, size: 18, color: AppColors.primary),
                          label: const Text(
                            'BHOPAL PLANT',
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: AppColors.primary),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('APP SETTINGS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.textSecondary, letterSpacing: 0.8)),
          const SizedBox(height: 8),
          _buildTile(Icons.location_on_outlined, 'Saved Addresses', 'Flat 402, Royal Palms, Bhopal'),
          _buildTile(Icons.account_balance_wallet_outlined, 'Shodasha Wallet', 'Rs 240.00 Balance'),
          _buildTile(Icons.security_outlined, 'Water Quality Standards', 'ISO 9001 & BIS Certified'),
          _buildTile(Icons.support_agent_outlined, 'Bhopal Plant Support', '24x7 Helpline active'),
        ],
      ),
    );
  }

  static Widget _buildTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        trailing: const Icon(Icons.chevron_right, size: 20, color: Color(0xFF94A3B8)),
      ),
    );
  }
}