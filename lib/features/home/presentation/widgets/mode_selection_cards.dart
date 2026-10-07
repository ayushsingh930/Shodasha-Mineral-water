import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../orders/data/order_service.dart';

class ModeSelectionCards extends StatelessWidget {
  final Function(int) onNavigateTab;

  const ModeSelectionCards({
    super.key,
    required this.onNavigateTab,
  });

  void _showInstantOrderSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        int cans = 1;
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Instant Water Can Delivery',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(sheetCtx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Direct dispatch from Bhopal Central Plant Hub • 30-45 mins',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Quantity (20L Cans):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Row(
                        children: [
                          IconButton(
                            onPressed: cans > 1 ? () => setSheetState(() => cans--) : null,
                            icon: const Icon(Icons.remove_circle_outline, color: AppColors.primary),
                          ),
                          Text('$cans', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          IconButton(
                            onPressed: () => setSheetState(() => cans++),
                            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        final price = 'Rs ${(cans * 65).toStringAsFixed(2)}';
                        OrderStateNotifier.instance.placeNewOrder(
                          itemName: '20L Mineral Water Can (Instant)',
                          address: 'Flat 402, Arera Colony, Bhopal',
                          slot: 'Express Delivery (~30 mins)',
                          price: price,
                          cansCount: cans,
                        );

                        Navigator.pop(sheetCtx);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFF15803D),
                            content: Text('$cans x Instant Can booked! Added to My Orders.'),
                            duration: const Duration(seconds: 3),
                          ),
                        );

                        onNavigateTab(1); // Auto switch to My Orders tab
                      },
                      child: const Text('CONFIRM INSTANT DISPATCH', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Card 1: Instant Order
        Expanded(
          child: GestureDetector(
            onTap: () => _showInstantOrderSheet(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.bolt_rounded, color: Colors.white, size: 26),
                  SizedBox(height: 12),
                  Text(
                    'Instant Delivery',
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Get water within 45 mins',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Card 2: Subscribe & Save
        Expanded(
          child: GestureDetector(
            onTap: () => onNavigateTab(2), // Switch to Subscriptions tab
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.calendar_month_rounded, color: AppColors.textOnAccent, size: 26),
                  SizedBox(height: 12),
                  Text(
                    'Subscription',
                    style: TextStyle(color: AppColors.textOnAccent, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Daily / Alternate schedule',
                    style: TextStyle(color: Color(0xFF78350F), fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}