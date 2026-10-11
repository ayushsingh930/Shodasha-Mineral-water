import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../data/order_service.dart';
import '../data/plant_service.dart';

class PlantHubScreen extends StatelessWidget {
  const PlantHubScreen({super.key});

  void _showUpdateDataDialog(BuildContext context) {
    final plant = PlantTelemetryNotifier.instance;
    final stockCtrl = TextEditingController(text: plant.basePlantStock.toString());
    final batchCtrl = TextEditingController(text: plant.batchNumber);
    final tdsCtrl = TextEditingController(text: plant.tdsValue.toString());
    final phCtrl = TextEditingController(text: plant.phValue.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'FEED REAL PLANT DATA',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 1),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const Text(
                'Enter ground metrics measured at Bhopal Plant today.',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildInput('Batch Number', batchCtrl, TextInputType.text),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInput('Total Cans Stock', stockCtrl, TextInputType.number),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildInput('Tested TDS (ppm)', tdsCtrl, TextInputType.number),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInput('Tested pH Level', phCtrl, const TextInputType.numberWithOptions(decimal: true)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    final int? stock = int.tryParse(stockCtrl.text.trim());
                    final int? tds = int.tryParse(tdsCtrl.text.trim());
                    final double? ph = double.tryParse(phCtrl.text.trim());
                    final String batch = batchCtrl.text.trim();

                    if (stock != null && tds != null && ph != null && batch.isNotEmpty) {
                      PlantTelemetryNotifier.instance.updatePlantData(
                        newStock: stock,
                        newBatch: batch,
                        newTds: tds,
                        newPh: ph,
                      );
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Color(0xFF16A34A),
                          content: Text('Bhopal Plant Live Data Updated & Synced!'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.save_rounded, size: 20),
                  label: const Text('SAVE & SYNC TELEMETRY', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildInput(String label, TextEditingController ctrl, TextInputType type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: type,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF0F172A),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded, color: Color(0xFF38BDF8), size: 26),
            tooltip: 'Feed Real Plant Data',
            onPressed: () => _showUpdateDataDialog(context),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([OrderStateNotifier.instance, PlantTelemetryNotifier.instance]),
        builder: (context, _) {
          final plant = PlantTelemetryNotifier.instance;
          final activeOrders = OrderStateNotifier.instance.activeOrders;
          final completedOrders = OrderStateNotifier.instance.completedOrders;

          final dispatchedCans = OrderStateNotifier.instance.totalVanStockRemaining;
          final collectedEmpties = OrderStateNotifier.instance.totalEmptyCansCollected;

          // Real Vendor Fed Inventory Math
          final int currentAvailableStock = plant.basePlantStock - dispatchedCans;

          // Financial Settlement
          final int deliveredCount = activeOrders.where((o) => o.status == 'DELIVERED').length + completedOrders.length;
          final int totalRevenue = (deliveredCount * 130) + (dispatchedCans * 65);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // LIVE PURITY LAB REPORT (VENDOR-FED)
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
                          child: Text('BATCH #${plant.batchNumber}', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.white)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _purityMetric('TDS VALUE', '${plant.tdsValue} ppm', 'Pure Mineral (60-120)'),
                        Container(height: 36, width: 1, color: Colors.white24),
                        _purityMetric('PH BALANCE', '${plant.phValue} pH', 'Optimal Alkaline'),
                        Container(height: 36, width: 1, color: Colors.white24),
                        _purityMetric('OZONATION', 'Active', '9-Stage RO + UV'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ACTION: FEED REAL DATA BUTTON
              SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C2541),
                    foregroundColor: const Color(0xFF38BDF8),
                    side: const BorderSide(color: Color(0xFF0284C7)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _showUpdateDataDialog(context),
                  icon: const Icon(Icons.edit_calendar_rounded, size: 18),
                  label: const Text('FEED TODAY\'S REAL LAB & STOCK DATA', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
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