import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../data/order_service.dart';
import 'rider_delivery_screen.dart';

class RiderDashboardScreen extends StatelessWidget {
  const RiderDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF16A34A),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('FLEET ACTIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white)),
            ),
            const SizedBox(width: 10),
            const Text(
              'RIDER COCKPIT',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 1.1, color: Colors.white),
            ),
          ],
        ),
      ),
      body: AnimatedBuilder(
        animation: OrderStateNotifier.instance,
        builder: (context, _) {
          final pendingOrders = OrderStateNotifier.instance.activeOrders.where((o) => o.status != 'DELIVERED').toList();
          final stockCans = OrderStateNotifier.instance.totalVanStockRemaining;
          final collectedCans = OrderStateNotifier.instance.totalEmptyCansCollected;

          return ListView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            children: [
              // REAL-TIME VAN METRICS CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _metricItem('VAN STOCK', '$stockCans Cans', Icons.water_drop_rounded, const Color(0xFF0284C7)),
                    Container(height: 36, width: 1, color: const Color(0xFF334155)),
                    _metricItem('COLLECTED', '$collectedCans Empty', Icons.recycling_rounded, const Color(0xFF16A34A)),
                    Container(height: 36, width: 1, color: const Color(0xFF334155)),
                    _metricItem('DROPS LEFT', '${pendingOrders.length}', Icons.local_shipping_rounded, const Color(0xFFEAB308)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'ASSIGNED DELIVERY ROUTE (BHOPAL HUB)',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 0.8),
              ),
              const SizedBox(height: 12),

              if (pendingOrders.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text('All assigned water drops completed for today!', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                  ),
                )
              else
                ...pendingOrders.map((order) => _buildRiderOrderCard(context, order)),
            ],
          );
        },
      ),
    );
  }

  Widget _metricItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
        Text(label, style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold, fontSize: 10)),
      ],
    );
  }

  Widget _buildRiderOrderCard(BuildContext context, OrderItem order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order.orderId, style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.w900, fontSize: 14)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF0369A1), borderRadius: BorderRadius.circular(6)),
                child: Text(order.status, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(order.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on, color: Color(0xFF94A3B8), size: 14),
              const SizedBox(width: 4),
              Expanded(child: Text(order.address, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12))),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16A34A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RiderDeliveryScreen(order: order)),
                );
              },
              icon: const Icon(Icons.verified, size: 18),
              label: const Text('VERIFY CUSTOMER PIN & COMPLETE', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}