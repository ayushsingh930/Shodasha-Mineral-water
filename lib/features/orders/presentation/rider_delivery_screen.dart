import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../data/order_service.dart';

class RiderDeliveryScreen extends StatefulWidget {
  final OrderItem order;

  const RiderDeliveryScreen({super.key, required this.order});

  @override
  State<RiderDeliveryScreen> createState() => _RiderDeliveryScreenState();
}

class _RiderDeliveryScreenState extends State<RiderDeliveryScreen> {
  final _pinController = TextEditingController();
  int _collectedEmptyCans = 0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _collectedEmptyCans = widget.order.emptyCansToReturn;
  }

  void _verifyAndDeliver() {
    final enteredPin = _pinController.text.trim();

    if (enteredPin != widget.order.deliveryPin) {
      setState(() {
        _errorMessage = 'Wrong PIN! Please ask customer for PIN: ${widget.order.deliveryPin}';
      });
      return;
    }

    OrderStateNotifier.instance.markOrderDelivered(
      widget.order,
      actualCollectedCans: _collectedEmptyCans,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF16A34A),
        content: Text('Order ${widget.order.orderId} successfully delivered! $_collectedEmptyCans empty can(s) collected.'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'VERIFY DELIVERY HANDSHAKE',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.white, letterSpacing: 1),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.order.orderId, style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.primary, fontSize: 14)),
                    Text(widget.order.amount, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppColors.textPrimary)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(widget.order.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(widget.order.address, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // EMPTY CAN COLLECTION SELECTOR
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ACTUAL EMPTY CANS COLLECTED', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: AppColors.textSecondary, letterSpacing: 0.6)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Empty 20L Bottles taken back:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _collectedEmptyCans > 0 ? () => setState(() => _collectedEmptyCans--) : null,
                          icon: const Icon(Icons.remove_circle_outline, color: AppColors.primary),
                        ),
                        Text('$_collectedEmptyCans', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.textPrimary)),
                        IconButton(
                          onPressed: () => setState(() => _collectedEmptyCans++),
                          icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // PIN VERIFICATION INPUT
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ENTER 4-DIGIT CUSTOMER PIN', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: AppColors.textSecondary, letterSpacing: 0.6)),
                const SizedBox(height: 4),
                Text('Ask customer for the order PIN (Hint: ${widget.order.deliveryPin})', style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                TextField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 10, color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                  ),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(_errorMessage!, style: const TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16A34A),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _verifyAndDeliver,
              icon: const Icon(Icons.check_circle_outline, size: 20),
              label: const Text('CONFIRM HANDSHAKE & DELIVER', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}