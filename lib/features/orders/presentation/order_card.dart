import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../data/order_service.dart';
import 'rider_delivery_screen.dart';

class OrderCard extends StatelessWidget {
  final OrderItem order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDelivered = order.status == 'DELIVERED';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDelivered ? const Color(0xFFDCFCE7) : const Color(0xFFE2E8F0),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID and Status Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.orderId,
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppColors.primary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDelivered ? const Color(0xFFDCFCE7) : const Color(0xFFFEF9C3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: isDelivered ? const Color(0xFF15803D) : const Color(0xFF854D0E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Product Details & Quantity Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('💧', style: TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.title,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2FE),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'QTY: ${order.orderedCansCount} ${order.orderedCansCount > 1 ? "CANS" : "CAN"}',
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Color(0xFF0369A1)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Total: ${order.amount}',
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),

          // Delivery Address & Slot
          Row(
            children: [
              const Icon(Icons.schedule, size: 15, color: Color(0xFF64748B)),
              const SizedBox(width: 6),
              Text(
                order.timeSlot,
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on, size: 15, color: Color(0xFF64748B)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  order.address,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Action: Customer PIN Display / Rider Action
          if (!isDelivered)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.pin, color: AppColors.primary, size: 18),
                  const SizedBox(width: 8),
                  const Text('Delivery OTP/PIN: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const Text('5892', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 2)),
                  const Spacer(),
                  Text(
                    order.eta,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF0284C7)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}