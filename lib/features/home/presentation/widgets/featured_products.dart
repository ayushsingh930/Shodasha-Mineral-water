import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../orders/data/order_service.dart';

class FeaturedProductsShowcase extends StatefulWidget {
  const FeaturedProductsShowcase({super.key});

  @override
  State<FeaturedProductsShowcase> createState() => _FeaturedProductsShowcaseState();
}

class _FeaturedProductsShowcaseState extends State<FeaturedProductsShowcase> {
  final OrderService _orderService = OrderService();

  final List<Map<String, dynamic>> _products = [
    {
      'title': '20L Mineral Water Can',
      'subtitle': 'Purified Natural Mineral Water',
      'price': 40,
      'icon': Icons.water_drop_rounded,
      'badge': 'MOST POPULAR',
    },
    {
      'title': '1L Premium Glass Jar',
      'subtitle': 'Natural Mineral Water (Pack of 1)',
      'price': 30,
      'icon': Icons.wine_bar_rounded,
      'badge': 'ECO-FRIENDLY',
    },
    {
      'title': '20L Dispenser Combo',
      'subtitle': 'Can + Heavy Duty Manual Tap',
      'price': 180,
      'icon': Icons.countertops_rounded,
      'badge': 'STARTER KIT',
    },
  ];

  void _openAddToCartSheet(Map<String, dynamic> product) {
    int qty = 1;
    final int unitPrice = product['price'] as int;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(sheetCtx),
                        icon: const Icon(Icons.close_rounded),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  Text(
                    product['subtitle'],
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Select Quantity', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (qty > 1) {
                                  setSheetState(() => qty--);
                                }
                              },
                              icon: const Icon(Icons.remove_circle_outline, color: AppColors.primary, size: 28),
                            ),
                            Text('$qty', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                            IconButton(
                              onPressed: () => setSheetState(() => qty++),
                              icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 28),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Price', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      Text(
                        'Rs ${qty * unitPrice}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary),
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
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () async {
                        Navigator.pop(sheetCtx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Adding to orders...')),
                        );
                        final id = await _orderService.placeOrder(
                          orderType: 'PRODUCT_PURCHASE',
                          productName: product['title'],
                          quantity: qty,
                          totalPrice: (qty * unitPrice).toDouble(),
                          deliveryAddress: 'Flat 402, Arera Colony, Bhopal',
                        );
                        if (id != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppColors.primaryDark,
                              content: Text('${product['title']} ordered successfully! Check My Orders.'),
                            ),
                          );
                        }
                      },
                      child: const Text('CONFIRM & ORDER NOW', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Featured Products',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _products.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = _products[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(item['icon'] as IconData, color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item['badge'] != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item['badge'],
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textOnAccent,
                              ),
                            ),
                          ),
                        Text(
                          item['title'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${item['subtitle']} • Rs ${item['price']}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _openAddToCartSheet(item),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'ADD TO CART',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
