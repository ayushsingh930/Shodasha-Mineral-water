enum ProductType { jar20L, bottle1L }

enum OrderMode { instant, subscription, schedule }

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final ProductType type;
  final String imageUrl;
  final int stock;
  final bool isActive;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.type,
    required this.imageUrl,
    this.stock = 0,
    this.isActive = true,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    ProductType? type,
    String? imageUrl,
    int? stock,
    bool? isActive,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      stock: stock ?? this.stock,
      isActive: isActive ?? this.isActive,
    );
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

class DeliveryLocation {
  final String id;
  final String name;
  final String address;
  final bool isDefault;

  const DeliveryLocation({
    required this.id,
    required this.name,
    required this.address,
    this.isDefault = false,
  });
}

class SubscriptionPlan {
  final String id;
  final String name;
  final String interval;
  final Product product;
  final int quantity;
  final double discountPercent;
  final bool isActive;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.interval,
    required this.product,
    required this.quantity,
    this.discountPercent = 0,
    this.isActive = true,
  });

  double get discountedPrice => product.price * (1 - discountPercent / 100);
  double get totalPrice => discountedPrice * quantity;
}