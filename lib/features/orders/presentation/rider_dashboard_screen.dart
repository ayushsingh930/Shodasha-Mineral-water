import '../../auth/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../data/order_service.dart';
import 'rider_delivery_screen.dart';

class RiderDashboardScreen extends StatelessWidget {
  const RiderDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'RIDER COCKPIT',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white, letterSpacing: 1.1),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: const Text('Logout Rider', style: TextStyle(fontWeight: FontWeight.bold)),
                  content: const Text('Are you sure you want to end your shift and logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626)),
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                      child: const Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: OrderStateNotifier.instance,
        builder: (context, _) {
          final pendingOrders = OrderStateNotifier.instance.activeOrders
              .where((o) => o.status != 'DELIVERED')
              .toList();
          final deliveredOrders = OrderStateNotifier.instance.activeOrders
              .where((o) => o.status == 'DELIVERED')
              .toList();

          final loadedStock = OrderStateNotifier.instance.totalVanStockRemaining;
          final collectedEmpties = OrderStateNotifier.instance.totalEmptyCansCollected;

          return ListView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            children: [
              // RIDER METRICS STRIP
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: const Icon(Icons.delivery_dining, color: AppColors.primary, size: 22),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Mahesh (Route Van #4)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppColors.textPrimary)),
                              Text('Bhopal Hub: Arera Colony & MP Nagar', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
                          child: const Text('ON DUTY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF15803D))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1, color: AppColors.border),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _metric('LOADED CANS', '$loadedStock', Icons.water_drop, AppColors.primary),
                        Container(height: 30, width: 1, color: AppColors.border),
                        _metric('EMPTIES COLLECTED', '$collectedEmpties', Icons.recycling, const Color(0xFF16A34A)),
                        Container(height: 30, width: 1, color: AppColors.border),
                        _metric('PENDING DROPS', '${pendingOrders.length}', Icons.timer_outlined, const Color(0xFFD97706)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // PENDING ASSIGNMENTS
              Text(
                'ACTIVE ROUTE DROPS (${pendingOrders.length})',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.textSecondary, letterSpacing: 0.8),
              ),
              const SizedBox(height: 10),

              if (pendingOrders.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Center(
                    child: Column(
                      children: [
                        Icon(Icons.check_circle_outline, color: Color(0xFF16A34A), size: 40),
                        SizedBox(height: 8),
                        Text('All orders for this route are delivered!', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                )
              else
                ...pendingOrders.map(
                  (order) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(order.orderId, style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.primary, fontSize: 13)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: const Color(0xFFFEF9C3), borderRadius: BorderRadius.circular(6)),
                              child: Text(order.status, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF854D0E))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(order.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(order.address, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => RiderDeliveryScreen(order: order)),
                              );
                            },
                            icon: const Icon(Icons.verified_user, size: 16),
                            label: const Text('VERIFY OTP & COMPLETE DROP', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              if (deliveredOrders.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(
                  'COMPLETED TODAY (${deliveredOrders.length})',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.textSecondary, letterSpacing: 0.8),
                ),
                const SizedBox(height: 8),
                ...deliveredOrders.map(
                  (order) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFDCFCE7)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text('${order.orderId} - ${order.title}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        ),
                        Text('Returned: ${order.emptyCansToReturn} Can(s)', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF16A34A))),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  static Widget _metric(String title, String val, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(val, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppColors.textPrimary)),
        Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 9, fontWeight: FontWeight.bold)),
      ],
    );
  }
}