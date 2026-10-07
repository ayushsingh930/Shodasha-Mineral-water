import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../orders/data/order_service.dart';

class FeaturedProductsShowcase extends StatelessWidget {
  const FeaturedProductsShowcase({super.key});

  void _bookOrder(BuildContext context, String productName, String price) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
                      Text(productName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(sheetCtx)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('Price: $price | Fast delivery to Arera Colony, Bhopal', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Select Cans Quantity:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
                        // Real Order Placement
                        OrderStateNotifier.instance.placeNewOrder(
                          itemName: productName,
                          address: 'Flat 402, Arera Colony, Bhopal',
                          slot: 'Morning (8:00 AM - 3:00 PM)',
                          price: price,
                          cansCount: cans,
                        );

                        Navigator.pop(sheetCtx);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFF15803D),
                            content: Text('$cans x $productName booked! Added to My Orders tab.'),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      },
                      child: const Text('CONFIRM & BOOK DELIVERY', style: TextStyle(fontWeight: FontWeight.bold)),
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
    final products = [
      {'title': '20L Chilled Water Can', 'price': 'Rs 65.00', 'tag': 'Bestseller', 'icon': Icons.water_drop},
      {'title': '20L Normal RO Water Can', 'price': 'Rs 60.00', 'tag': 'Daily Pick', 'icon': Icons.local_drink},
      {'title': 'Manual Can Water Pump', 'price': 'Rs 249.00', 'tag': 'Accessory', 'icon': Icons.hardware},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('FEATURED WATER CANS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.textSecondary)),
            Text('Pure RO + UV', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        ...products.map((p) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(p['icon'] as IconData, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                    const SizedBox(height: 2),
                    Text(p['price'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary)),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _bookOrder(context, p['title'] as String, p['price'] as String),
                child: const Text('Order Now', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }
}