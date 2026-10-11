import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../data/order_service.dart';
import 'order_card.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'MY WATER ORDERS',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white, letterSpacing: 1.1),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: OrderStateNotifier.instance,
        builder: (context, _) {
          final activeOrders = OrderStateNotifier.instance.activeOrders;
          return ListView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            children: [
              const Text(
                'LIVE DELIVERIES',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.textSecondary, letterSpacing: 0.8),
              ),
              const SizedBox(height: 10),
              if (activeOrders.isEmpty)
                const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('No active deliveries right now.')))
              else
                ...activeOrders.map((order) => OrderCard(order: order)),
            ],
          );
        },
      ),
    );
  }
}