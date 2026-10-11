import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../data/order_service.dart';

class PlantHubScreen extends StatelessWidget {
  const PlantHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B132B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2541),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF0284C7),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('FACTORY CONSOLE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white)),
            ),
            const SizedBox(width: 10),
            const Text(
              'BHOPAL PLANT HUB',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 1.1, color: Colors.white),
            ),
          ],
        ),
      ),
      body: AnimatedBuilder(
        animation: OrderStateNotifier.instance,
        builder: (context, _) {
          final activeOrders = OrderStateNotifier.instance.activeOrders;
          final completedOrders = OrderStateNotifier.instance.completedOrders;
          
          final dispatchedCans = OrderStateNotifier.instance.totalVanStockRemaining;
          final collectedEmpties = OrderStateNotifier.instance.totalEmptyCansCollected;
          
          // Factory Stock Balance Math
          const int basePlantStock = 450;
          final int currentAvailableStock = basePlantStock - dispatchedCans;
          
          // COD / Cash Math
          final int deliveredCount = activeOrders.where((o) => o.status == 'DELIVERED').length + completedOrders.length;
          final int totalRevenue = (deliveredCount * 130) + (dispatchedCans * 65);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // WATER PURITY LAB REPORT (MNC QUALITY ASSURANCE)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF0284C7).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.verified_user_rounded, color: Colors.white, size: 18),
                            SizedBox(width: 6),
                            Text('LIVE PURITY LAB TELEMETRY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.8)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: const Color(0xFF16A34A), borderRadius: BorderRadius.circular(6)),
                          child: const Text('BATCH #BHP-X4 CERTIFIED', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.white)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _purityMetric('TDS VALUE', '85 ppm', 'Pure Mineral (60-120)'),
                        Container(height: 36, width: 1, color: Colors.white24),
                        _purityMetric('PH BALANCE', '7.2 pH', 'Optimal Alkaline'),
                        Container(height: 36, width: 1, color: Colors.white24),
                        _purityMetric('OZONATION', 'Active', '9-Stage RO + UV'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // WAREHOUSE INVENTORY METRICS
              const Text(
                'WAREHOUSE INVENTORY & BOTTLE LEDGER',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 0.8),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C2541),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _inventoryItem('READY IN PLANT', '$currentAvailableStock Cans', Icons.warehouse_rounded, const Color(0xFF38BDF8)),
                        Container(height: 36, width: 1, color: const Color(0xFF334155)),
                        _inventoryItem('DISPATCHED IN VANS', '$dispatchedCans Cans', Icons.local_shipping_rounded, const Color(0xFFEAB308)),
                        Container(height: 36, width: 1, color: const Color(0xFF334155)),
                        _inventoryItem('RETURNED EMPTIES', '$collectedEmpties Cans', Icons.recycling_rounded, const Color(0xFF16A34A)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1, color: Color(0xFF334155)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.info_outline, size: 14, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '$collectedEmpties empty cans queued in Bhopal sterilization washing bay.',
                            style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // FINANCIAL CASH RECONCILIATION
              const Text(
                'DAILY CASH & SETTLEMENT RECONCILIATION',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 0.8),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C2541),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Column(
                  children: [
                    _reconciliationRow('Total Daily Invoiced Value', 'Rs $totalRevenue.00', Colors.white, isBold: true),
                    const SizedBox(height: 10),
                    _reconciliationRow('Rider Cash Collection (COD Due)', 'Rs ${(deliveredCount * 130)}.00', const Color(0xFF4ADE80)),
                    const SizedBox(height: 10),
                    _reconciliationRow('Prepaid / Online Settlement', 'Rs ${(dispatchedCans * 65)}.00', const Color(0xFF38BDF8)),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF38BDF8),
                          side: const BorderSide(color: Color(0xFF38BDF8)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Color(0xFF16A34A),
                              content: Text('Bhopal Day-End Cash Settlement Audited & Closed!'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.receipt_long_rounded, size: 18),
                        label: const Text('RUN DAY-END CASH AUDIT', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _purityMetric(String title, String val, String sub) {
    return Column(
      children: [
        Text(val, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
        const SizedBox(height: 2),
        Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white70)),
        const SizedBox(height: 2),
        Text(sub, style: const TextStyle(fontSize: 9, color: Colors.white54)),
      ],
    );
  }

  Widget _inventoryItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold, fontSize: 9), textAlign: TextAlign.center),
      ],
    );
  }

  Widget _reconciliationRow(String title, String amount, Color color, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: const Color(0xFF94A3B8), fontSize: 12, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(amount, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w900)),
      ],
    );
  }
}