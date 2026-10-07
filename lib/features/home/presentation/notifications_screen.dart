import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'Delivery Van On Route',
        'desc': 'Mahesh is driving MP-04 Van 5412 towards Arera Colony. ETA: 25 mins.',
        'time': '10 mins ago',
        'icon': Icons.local_shipping_rounded,
        'color': AppColors.primary,
        'unread': true,
      },
      {
        'title': 'Empty Can Return Reminder',
        'desc': 'Please keep 2 empty 20L water cans ready at the door for pickup.',
        'time': '35 mins ago',
        'icon': Icons.autorenew_rounded,
        'color': const Color(0xFFD97706),
        'unread': true,
      },
      {
        'title': 'Daily Plant Quality Tested',
        'desc': 'Today’s batch TDS tested at 110 ppm. 100% compliant with Bureau of Indian Standards.',
        'time': 'Today, 8:00 AM',
        'icon': Icons.verified_rounded,
        'color': const Color(0xFF16A34A),
        'unread': false,
      },
      {
        'title': 'Deposit Recharged',
        'desc': 'Rs 500 added to your Security Deposit balance successfully.',
        'time': 'Yesterday',
        'icon': Icons.account_balance_wallet_rounded,
        'color': AppColors.primary,
        'unread': false,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'NOTIFICATIONS & ALERTS',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.1,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          final unread = item['unread'] as bool;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: unread ? const Color(0xFFF0FDF4) : AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
              border: Border.all(
                color: unread ? const Color(0xFFBBF7D0) : AppColors.border,
                width: unread ? 1.5 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: item['color'] as Color,
                    size: 22,
                  ),
                ),
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
                              item['title'] as String,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: unread ? FontWeight.w900 : FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            item['time'] as String,
                            style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['desc'] as String,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}