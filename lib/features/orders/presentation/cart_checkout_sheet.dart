import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../profile/presentation/saved_addresses_screen.dart';
import '../data/order_service.dart';

class CartCheckoutSheet extends StatefulWidget {
  final VoidCallback? onOrderSuccess;

  const CartCheckoutSheet({super.key, this.onOrderSuccess});

  static void show(BuildContext context, {VoidCallback? onOrderSuccess}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CartCheckoutSheet(onOrderSuccess: onOrderSuccess),
    );
  }

  @override
  State<CartCheckoutSheet> createState() => _CartCheckoutSheetState();
}

class _CartCheckoutSheetState extends State<CartCheckoutSheet> {
  int _canCount = 2;
  final AddressStateService _addressService = AddressStateService.instance;
  final int _pricePerCan = 65;

  @override
  Widget build(BuildContext context) {
    final activeAddress = _addressService.activeAddress;
    final totalAmount = _canCount * _pricePerCan;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Text('💧', style: TextStyle(fontSize: 22)),
                  SizedBox(width: 8),
                  Text(
                    'Order Water Can',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                  ),
                ],
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.close_rounded, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'DELIVERY TO:',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.textSecondary, letterSpacing: 0.8),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFBBF7D0), width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF16A34A),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.home_rounded, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${activeAddress.tag}: ${activeAddress.title}',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${activeAddress.landmark} • ${activeAddress.floor}',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 20),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('🧊', style: TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '20L Chilled Water Can',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                      ),
                      Text(
                        'Rs $_pricePerCan per can',
                        style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.remove_rounded, color: AppColors.textPrimary, size: 20),
                        onPressed: () {
                          if (_canCount > 1) {
                            setState(() => _canCount--);
                          }
                        },
                      ),
                      Text(
                        '$_canCount',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primary),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.add_rounded, color: AppColors.textPrimary, size: 20),
                        onPressed: () {
                          if (_canCount < 10) {
                            setState(() => _canCount++);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount to Pay:',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
              ),
              Text(
                'Rs $totalAmount.00',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF15803D)),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16A34A),
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                final newOrder = OrderItem(
                  orderId: '#SHD-${(1000 + DateTime.now().millisecond * 7).toString()}',
                  title: '$_canCount x 20L Chilled Mineral Water Cans',
                  status: 'DISPATCHED',
                  address: activeAddress.title,
                  timeSlot: 'Instant Van Delivery',
                  amount: 'Rs $totalAmount.00',
                  deliveryAgent: 'Mahesh (Plant Van)',
                  emptyCansToReturn: _canCount,
                  eta: '~20 mins',
                  date: 'Today',
                );

                final notifier = OrderStateNotifier.instance;
                notifier.activeOrders.insert(0, newOrder);
                // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                notifier.notifyListeners();

                if (widget.onOrderSuccess != null) {
                  widget.onOrderSuccess!();
                }

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color(0xFF15803D),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    content: Row(
                      children: const [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 10),
                        Text('Order Confirmed! Van is on the way 🚚', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.shopping_bag_outlined, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'PLACE ORDER NOW',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 0.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}