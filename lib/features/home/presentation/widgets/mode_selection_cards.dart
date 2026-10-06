import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../orders/data/order_service.dart';

class ModeSelectionCards extends StatefulWidget {
  final void Function(int tabIndex)? onNavigateTab;

  const ModeSelectionCards({super.key, this.onNavigateTab});

  @override
  State<ModeSelectionCards> createState() => _ModeSelectionCardsState();
}

class _ModeSelectionCardsState extends State<ModeSelectionCards> {
  int _selectedMode = 0;
  final OrderService _orderService = OrderService();

  void _triggerInstantSheet() {
    int count = 1;
    const int pricePerCan = 40;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
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
                      const Text(
                        'One-Time Instant Refill',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(bottomCtx),
                        icon: const Icon(Icons.close_rounded),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text('20L Purified Mineral Water Can', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  const SizedBox(height: 16),
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
                        const Text('Quantity', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (count > 1) {
                                  setModalState(() => count--);
                                }
                              },
                              icon: const Icon(Icons.remove_circle, color: AppColors.primary, size: 28),
                            ),
                            Text('$count', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                            IconButton(
                              onPressed: () => setModalState(() => count++),
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
                      const Text('Total Amount', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      Text(
                        'Rs ${count * pricePerCan}',
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(bottomCtx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Placing order to Shodasha database...')),
                        );
                        final id = await _orderService.placeOrder(
                          orderType: 'INSTANT',
                          productName: '20L Mineral Can',
                          quantity: count,
                          totalPrice: (count * pricePerCan).toDouble(),
                          deliveryAddress: 'Home Delivery, Bhopal',
                        );
                        if (id != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppColors.primaryDark,
                              content: Text('Order #${id.substring(0, 6)} Confirmed! Live in Firestore.'),
                            ),
                          );
                        }
                      },
                      child: const Text('CONFIRM INSTANT ORDER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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

  void _triggerBulkDialog() {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.corporate_fare_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Bulk / Daily Schedule', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('For events, offices, or large volume supply:'),
            SizedBox(height: 10),
            Text('• 10+ Cans special commercial discount'),
            Text('• Daily custom route allocation'),
            Text('• Priority morning dispatch'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('CLOSE'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogCtx);
              if (widget.onNavigateTab != null) {
                widget.onNavigateTab!(2);
              }
            },
            child: const Text('VIEW PLANS'),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required int index,
    required String title,
    required IconData icon,
    required String tagline,
    required String btnText,
    required bool isHighlight,
    required VoidCallback onTap,
  }) {
    final isSelected = _selectedMode == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() => _selectedMode = index);
          onTap();
        },
        child: Container(
          height: 195,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          decoration: BoxDecoration(
            color: isHighlight ? const Color(0xFFFEF9C3) : AppColors.surface,
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isHighlight ? const Color(0xFFFDE047) : AppColors.border),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.15,
                ),
              ),
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),
              Text(
                tagline,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 32,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _selectedMode = index);
                    onTap();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.textOnAccent,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
                    ),
                  ),
                  child: Text(
                    btnText,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ORDER WATER',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Choose Your Schedule',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildCard(
              index: 0,
              title: "One-Time\nInstant",
              icon: Icons.bolt_rounded,
              tagline: "Fast Refill",
              btnText: "ORDER NOW",
              isHighlight: false,
              onTap: _triggerInstantSheet,
            ),
            const SizedBox(width: 8),
            _buildCard(
              index: 1,
              title: "Regular\nSubscription",
              icon: Icons.autorenew_rounded,
              tagline: "Auto-Refill",
              btnText: "SETUP PLAN",
              isHighlight: true,
              onTap: () {
                if (widget.onNavigateTab != null) {
                  widget.onNavigateTab!(2);
                }
              },
            ),
            const SizedBox(width: 8),
            _buildCard(
              index: 2,
              title: "Daily Schedule\nBulk",
              icon: Icons.local_shipping_rounded,
              tagline: "Daily Delivery",
              btnText: "VIEW SCHEDULE",
              isHighlight: false,
              onTap: _triggerBulkDialog,
            ),
          ],
        ),
      ],
    );
  }
}
