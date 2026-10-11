import 'package:flutter/material.dart';

class WaterSubscription {
  final String id;
  final String planTitle;
  final String frequency; // 'Daily', 'Alternate Days', 'Weekdays Only'
  final String deliveryTime;
  final int cansPerDrop;
  bool isPaused;
  final double pricePerDrop;

  WaterSubscription({
    required this.id,
    required this.planTitle,
    required this.frequency,
    required this.deliveryTime,
    required this.cansPerDrop,
    this.isPaused = false,
    required this.pricePerDrop,
  });
}

class SubscriptionNotifier extends ChangeNotifier {
  SubscriptionNotifier._();
  static final SubscriptionNotifier instance = SubscriptionNotifier._();

  final List<WaterSubscription> activeSubscriptions = [
    WaterSubscription(
      id: '#SUB-9021',
      planTitle: 'Home Morning Pure Water (20L Chilled)',
      frequency: 'Daily (7:00 AM)',
      deliveryTime: 'Slot: 06:30 AM - 07:30 AM',
      cansPerDrop: 1,
      isPaused: false,
      pricePerDrop: 65.0,
    ),
  ];

  void togglePause(String subId) {
    final sub = activeSubscriptions.firstWhere((s) => s.id == subId);
    sub.isPaused = !sub.isPaused;
    notifyListeners();
  }

  void addNewSubscription({
    required String title,
    required String frequency,
    required int cans,
    required double price,
  }) {
    activeSubscriptions.add(
      WaterSubscription(
        id: '#SUB-${(1000 + activeSubscriptions.length + 1)}',
        planTitle: title,
        frequency: frequency,
        deliveryTime: 'Slot: 06:30 AM - 07:30 AM',
        cansPerDrop: cans,
        isPaused: false,
        pricePerDrop: price,
      ),
    );
    notifyListeners();
  }
}