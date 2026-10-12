import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import 'wallet_screen.dart';
import '../../admin/presentation/owner_control_center_screen.dart';
import '../../auth/presentation/login_screen.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'ACCOUNT & PROFILE',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 16,
            color: Colors.white,
            letterSpacing: 1.1,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
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
                  child: const Icon(Icons.person, color: AppColors.primary, size: 30),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ayush Singh',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF0F172A)),
                      ),
                      SizedBox(height: 3),
                      Text(
                        '+91 98930 00000 • Bhopal, MP',
                        style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Menu Options
          const Text(
            'QUICK SERVICES',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF64748B), letterSpacing: 0.8),
          ),
          const SizedBox(height: 10),

          // 1. Shodasha Wallet
          _buildActionTile(
            context,
            icon: Icons.account_balance_wallet_outlined,
            iconColor: const Color(0xFF0284C7),
            title: 'Shodasha Wallet & Can Ledger',
            subtitle: '₹450.00 Balance • 2 Cans Held',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WalletScreen()),
              );
            },
          ),

          // 2. Owner Control Center
          _buildActionTile(
            context,
            icon: Icons.admin_panel_settings_outlined,
            iconColor: const Color(0xFF7C3AED),
            title: 'Owner Control Center',
            subtitle: 'Track Riders, Customers & Plant Hub',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OwnerControlCenterScreen()),
              );
            },
          ),

          // 3. Saved Addresses
          _buildActionTile(
            context,
            icon: Icons.location_on_outlined,
            iconColor: const Color(0xFFEA580C),
            title: 'Saved Addresses',
            subtitle: 'Flat 402, Royal Palms, Bhopal',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Address Management')),
              );
            },
          ),

          // 4. Quality Standards
          _buildActionTile(
            context,
            icon: Icons.verified_outlined,
            iconColor: const Color(0xFF16A34A),
            title: 'Water Quality Standards',
            subtitle: 'ISO 9001 & BIS IS 14543 Certified',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ISO 9001 Certified Bhopal Bottling Plant')),
              );
            },
          ),

          // 5. Plant Support
          _buildActionTile(
            context,
            icon: Icons.support_agent_outlined,
            iconColor: const Color(0xFF0D9488),
            title: 'Bhopal Plant Support',
            subtitle: '24x7 Helpline • +91 98260 00000',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Connecting to Plant Helpline...')),
              );
            },
          ),

          const SizedBox(height: 12),

          // 6. Logout Tile
          _buildActionTile(
            context,
            icon: Icons.logout,
            iconColor: const Color(0xFFDC2626),
            title: 'Logout',
            subtitle: 'Sign out and switch role account',
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.12),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF0F172A)),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 20),
        onTap: onTap,
      ),
    );
  }
}