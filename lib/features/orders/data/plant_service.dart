import 'package:flutter/material.dart';

class PlantTelemetryNotifier extends ChangeNotifier {
  PlantTelemetryNotifier._();
  static final PlantTelemetryNotifier instance = PlantTelemetryNotifier._();

  // Real editable vendor/plant values
  int basePlantStock = 450;
  String batchNumber = 'BHP-X4-2026';
  int tdsValue = 85;
  double phValue = 7.2;
  String ozonationStatus = 'Active (9-Stage RO + UV)';

  void updatePlantData({
    required int newStock,
    required String newBatch,
    required int newTds,
    required double newPh,
  }) {
    basePlantStock = newStock;
    batchNumber = newBatch;
    tdsValue = newTds;
    phValue = newPh;
    notifyListeners();
  }
}