import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
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
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.water_drop, color: AppColors.primary, size: 16),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'BHOPAL PLANT PURITY REPORT',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'BATCH #${plant.batchNumber}',
                      style: const TextStyle(color: Color(0xFF15803D), fontSize: 9, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _chip('TDS VALUE', '${plant.tdsValue} ppm', 'Pure Mineral'),
                    Container(height: 28, width: 1, color: AppColors.border),
                    _chip('PH LEVEL', '${plant.phValue} pH', 'Alkaline Balance'),
                    Container(height: 28, width: 1, color: AppColors.border),
                    _chip('PURIFICATION', '9-Stage', 'RO + UV + Ozone'),
                  ],
                ),
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
        Text(val, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900, fontSize: 14)),
        const SizedBox(height: 2),
        Text(title, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 9)),
        Text(sub, style: const TextStyle(color: AppColors.textSecondary, fontSize: 8)),
      ],
    );
  }
}