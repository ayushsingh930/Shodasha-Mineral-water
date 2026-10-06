import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> placeOrder({
    required String orderType,
    required String productName,
    required int quantity,
    required double totalPrice,
    required String deliveryAddress,
  }) async {
    try {
      final docRef = await _firestore.collection('orders').add({
        'orderType': orderType,
        'productName': productName,
        'quantity': quantity,
        'totalPrice': totalPrice,
        'deliveryAddress': deliveryAddress,
        'status': 'PENDING_VENDOR_ALLOCATION',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      return null;
    }
  }
}
