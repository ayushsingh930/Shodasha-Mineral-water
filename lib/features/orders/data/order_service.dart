import 'package:flutter/material.dart';

class OrderItem {
  final String orderId;
  final String title;
  final String address;
  final String date;
  final String timeSlot;
  final String amount;
  final String status;
  final String deliveryAgent;
  final String eta;
  final int emptyCansToReturn;

  OrderItem({
    required this.orderId,
    required this.title,
    required this.address,
    required this.date,
    required this.timeSlot,
    required this.amount,
    required this.status,
    required this.deliveryAgent,
    required this.eta,
    required this.emptyCansToReturn,
  });
}

class OrderStateNotifier extends ChangeNotifier {
  static final OrderStateNotifier instance = OrderStateNotifier._();
  OrderStateNotifier._();

  final List<OrderItem> _activeOrders = [
    OrderItem(
      orderId: 'ORDER #SHD-8942',
      title: '2x 20L Chilled Mineral Water Cans',
      address: 'Flat 402, Arera Colony, Bhopal',
      date: 'Today',
      timeSlot: 'Morning (8:00 AM - 3:00 PM)',
      amount: 'Rs 130.00',
      status: 'OUT FOR DELIVERY',
      deliveryAgent: 'Mahesh (Plant Van)',
      eta: '~25 mins',
      emptyCansToReturn: 2,
    ),
  ];

  final List<OrderItem> _pastOrders = [
    OrderItem(
      orderId: 'ORDER #SHD-8721',
      title: '2x 20L Mineral Water Cans',
      address: 'Flat 402, Arera Colony, Bhopal',
      date: '04-Oct-2026 • Morning Slot',
      timeSlot: 'Morning Slot',
      amount: 'Rs 130.00',
      status: 'DELIVERED',
      deliveryAgent: 'Suresh',
      eta: 'Completed',
      emptyCansToReturn: 2,
    ),
    OrderItem(
      orderId: 'ORDER #SHD-8510',
      title: '2x 20L Mineral Water Cans',
      address: 'Flat 402, Arera Colony, Bhopal',
      date: '01-Oct-2026 • Morning Slot',
      timeSlot: 'Morning Slot',
      amount: 'Rs 130.00',
      status: 'DELIVERED',
      deliveryAgent: 'Mahesh',
      eta: 'Completed',
      emptyCansToReturn: 2,
    ),
  ];

  List<OrderItem> get activeOrders => _activeOrders;
  List<OrderItem> get pastOrders => _pastOrders;

  void placeNewOrder({
    required String itemName,
    required String address,
    required String slot,
    required String price,
    int cansCount = 1,
  }) {
    final int nextNum = 8943 + _activeOrders.length;
    final newOrder = OrderItem(
      orderId: 'ORDER #SHD-$nextNum',
      title: '$cansCount x $itemName',
      address: address,
      date: 'Today',
      timeSlot: slot,
      amount: price,
      status: 'ORDER CONFIRMED & DISPATCHING',
      deliveryAgent: 'Assigned Soon (Hub Agent)',
      eta: '~35-40 mins',
      emptyCansToReturn: cansCount,
    );

    _activeOrders.insert(0, newOrder);
    notifyListeners();
  }
}