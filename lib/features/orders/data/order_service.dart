import 'package:flutter/material.dart';

class OrderItem {
  final String orderId;
  final String title;
  String status;
  final String address;
  final String timeSlot;
  final String amount;
  final String deliveryAgent;
  int emptyCansToReturn;
  int orderedCansCount;
  String eta;
  final String date;

  OrderItem({
    required this.orderId,
    required this.title,
    required this.status,
    required this.address,
    required this.timeSlot,
    required this.amount,
    required this.deliveryAgent,
    required this.emptyCansToReturn,
    this.orderedCansCount = 2,
    required this.eta,
    required this.date,
  });
}

class OrderStateNotifier extends ChangeNotifier {
  OrderStateNotifier._();
  static final OrderStateNotifier instance = OrderStateNotifier._();

  final List<OrderItem> activeOrders = [
    OrderItem(
      orderId: '#SHD-8492',
      title: '2 x 20L Chilled Mineral Water Cans',
      status: 'ON ROUTE',
      address: 'Flat 402, Royal Palms, Arera Colony, Bhopal',
      timeSlot: 'Morning (08:00 AM - 10:00 AM)',
      amount: 'Rs 130.00',
      deliveryAgent: 'Mahesh (Delivery Van)',
      emptyCansToReturn: 2,
      orderedCansCount: 2,
      eta: '~12 mins',
      date: 'Today',
    ),
  ];

  final List<OrderItem> completedOrders = [
    OrderItem(
      orderId: '#SHD-7811',
      title: '1 x 20L Chilled Mineral Water Can',
      status: 'DELIVERED',
      address: 'Flat 402, Royal Palms, Arera Colony, Bhopal',
      timeSlot: 'Evening (05:00 PM - 07:00 PM)',
      amount: 'Rs 65.00',
      deliveryAgent: 'Ramesh Singh',
      emptyCansToReturn: 1,
      orderedCansCount: 1,
      eta: 'Delivered',
      date: 'Yesterday',
    ),
  ];

  void placeNewOrder({
    String? itemName,
    String? title,
    String? slot,
    String? timeSlot,
    dynamic price,
    dynamic amount,
    dynamic cansCount,
    dynamic cans,
    String? address,
    int emptyCansToReturn = 0,
  }) {
    final int count = int.tryParse((cansCount ?? cans ?? 1).toString()) ?? 1;
    final finalTitle = itemName ?? title ?? '$count x 20L Mineral Water Can';
    final finalSlot = slot ?? timeSlot ?? 'Morning (8:00 AM - 3:00 PM)';
    final finalPrice = price != null ? 'Rs $price' : (amount ?? 'Rs 65.00');
    final finalAddress = address ?? 'Flat 402, Royal Palms, Arera Colony, Bhopal';
    final newId = '#SHD-${(1000 + activeOrders.length + 1)}';

    activeOrders.insert(
      0,
      OrderItem(
        orderId: newId,
        title: finalTitle,
        status: 'BOOKED',
        address: finalAddress,
        timeSlot: finalSlot,
        amount: finalPrice.toString(),
        deliveryAgent: 'Mahesh (Delivery Van)',
        emptyCansToReturn: count,
        orderedCansCount: count,
        eta: '~25 mins',
        date: 'Today',
      ),
    );
    notifyListeners();
  }

  void markOrderDelivered(OrderItem item, {int actualCollectedCans = 0}) {
    item.status = 'DELIVERED';
    item.eta = 'Delivered Just Now';
    item.emptyCansToReturn = actualCollectedCans;
    notifyListeners();
  }

  // Exact Real Calculations for Fleet Cockpit
  int get totalVanStockRemaining {
    return activeOrders
        .where((o) => o.status != 'DELIVERED')
        .fold(0, (sum, o) => sum + o.orderedCansCount);
  }

  int get totalEmptyCansCollected {
    return activeOrders
        .where((o) => o.status == 'DELIVERED')
        .fold(0, (sum, o) => sum + o.emptyCansToReturn);
  }
}