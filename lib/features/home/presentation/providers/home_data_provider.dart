import 'package:flutter/foundation.dart';
import 'package:shodasha_mineral_water/shared/models/product.dart';

class HomeDataProvider extends ChangeNotifier {
  final List<Product> _featuredProducts = [
    Product(
      id: 'jar_20l',
      name: '20L Mineral Jar',
      description: 'Standard mineral water jar for home & office dispensers',
      price: 80.0,
      type: ProductType.jar20L,
      imageUrl: 'assets/images/jar_20l.png',
      stock: 100,
    ),
    Product(
      id: 'bottle_1l',
      name: '1L Premium Bottle',
      description: 'Premium glass/PET bottle - perfect for on-the-go',
      price: 25.0,
      type: ProductType.bottle1L,
      imageUrl: 'assets/images/bottle_1l.png',
      stock: 200,
    ),
  ];

  List<Product> get featuredProducts => List.unmodifiable(_featuredProducts);

  Product? getProductById(String id) {
    try {
      return _featuredProducts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Product? get jar20L => getProductById('jar_20l');
  Product? get bottle1L => getProductById('bottle_1l');
}