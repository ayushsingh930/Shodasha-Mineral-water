import 'package:flutter/material.dart';
import '../../../orders/data/plant_service.dart';

class LivePurityCard extends StatelessWidget {
  const LivePurityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: PlantTelemetryNotifier.instance,
      builder: (context, _) {
        final plant = PlantTelemetryNotifier.instance;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF0284C7).withOpacity(0.4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.water_drop, color: Color(0xFF38BDF8), size: 16),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'BHOPAL PLANT PURITY REPORT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF15803D),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'BATCH #${plant.batchNumber}',
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _chip('TDS VALUE', '${plant.tdsValue} ppm', 'Pure Mineral'),
                  Container(height: 28, width: 1, color: const Color(0xFF334155)),
                  _chip('PH LEVEL', '${plant.phValue} pH', 'Alkaline Balance'),
                  Container(height: 28, width: 1, color: const Color(0xFF334155)),
                  _chip('PURIFICATION', '9-Stage', 'RO + UV + Ozone'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _chip(String title, String val, String sub) {
    return Column(
      children: [
        Text(val, style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.w900, fontSize: 14)),
        const SizedBox(height: 2),
        Text(title, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700, fontSize: 9)),
        Text(sub, style: const TextStyle(color: Color(0xFF64748B), fontSize: 8)),
      ],
    );
  }
}