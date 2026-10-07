import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../data/order_service.dart';

class CartCheckoutSheet extends StatefulWidget {
  final VoidCallback onOrderSuccess;

  const CartCheckoutSheet({super.key, required this.onOrderSuccess});

  static void show(BuildContext context, {required VoidCallback onOrderSuccess}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => CartCheckoutSheet(onOrderSuccess: onOrderSuccess),
    );
  }

  @override
  State<CartCheckoutSheet> createState() => _CartCheckoutSheetState();
}

class _CartCheckoutSheetState extends State<CartCheckoutSheet> {
  int _canQty = 2;
  int _pumpQty = 0;
  final double _canPrice = 65.0;
  final double _pumpPrice = 249.0;
  final double _depositPerCan = 150.0;
  bool _isNewCansNeeded = false;

  double get _itemsTotal => (_canQty * _canPrice) + (_pumpQty * _pumpPrice);
  double get _depositTotal => _isNewCansNeeded ? (_canQty * _depositPerCan) : 0.0;
  double get _finalPayable => _itemsTotal + _depositTotal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Your Water Cart',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const Divider(height: 16),

            // Item 1: 20L Water Can
            _buildCartItem(
              title: '20L Chilled Mineral Water Can',
              unitPrice: 'Rs 65.00',
              quantity: _canQty,
              onMinus: () => setState(() { if (_canQty > 1) _canQty--; }),
              onPlus: () => setState(() => _canQty++),
            ),
            const SizedBox(height: 10),

            // Item 2: Pump Dispenser
            _buildCartItem(
              title: 'Manual Water Dispenser Pump',
              unitPrice: 'Rs 249.00',
              quantity: _pumpQty,
              onMinus: () => setState(() { if (_pumpQty > 0) _pumpQty--; }),
              onPlus: () => setState(() => _pumpQty++),
            ),
            const SizedBox(height: 14),

            // Can Exchange Toggle
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: !_isNewCansNeeded,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() {
                        _isNewCansNeeded = !(val ?? true);
                      });
                    },
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'I will return empty cans on delivery',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'No bottle security deposit charged if returning cans',
                          style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Bill Breakdown
            const Text(
              'PAYMENT BREAKDOWN',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.textSecondary, letterSpacing: 0.8),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildPriceRow('Items Subtotal', 'Rs ${_itemsTotal.toStringAsFixed(2)}'),
                  const SizedBox(height: 6),
                  if (_isNewCansNeeded) ...[
                    _buildPriceRow('New Bottle Deposit (Refundable)', 'Rs ${_depositTotal.toStringAsFixed(2)}'),
                    const SizedBox(height: 6),
                  ],
                  _buildPriceRow('Express Hub Delivery', 'FREE', isGreen: true),
                  const Divider(height: 18),
                  _buildPriceRow('Final Total Payable', 'Rs ${_finalPayable.toStringAsFixed(2)}', isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Checkout Button
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
                  final String orderTitle = '$_canQty x 20L Water Can' + (_pumpQty > 0 ? ' + $_pumpQty Dispenser' : '');
                  OrderStateNotifier.instance.placeNewOrder(
                    itemName: orderTitle,
                    address: 'Flat 402, Arera Colony, Bhopal',
                    slot: 'Morning (8:00 AM - 3:00 PM)',
                    price: 'Rs ${_finalPayable.toStringAsFixed(2)}',
                    cansCount: _canQty,
                  );

                  Navigator.pop(context);
                  widget.onOrderSuccess();
                },
                child: const Text('PROCEED TO PLACE ORDER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem({
    required String title,
    required String unitPrice,
    required int quantity,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                Text(unitPrice, style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: quantity > 0 ? onMinus : null,
                icon: const Icon(Icons.remove_circle_outline, size: 20, color: AppColors.primary),
              ),
              Text('$quantity', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onPlus,
                icon: const Icon(Icons.add_circle_outline, size: 20, color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isBold = false, bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 13 : 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 14 : 12,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
            color: isGreen ? const Color(0xFF16A34A) : (isBold ? AppColors.primary : AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}