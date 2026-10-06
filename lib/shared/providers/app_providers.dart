import 'package:flutter/foundation.dart';
import 'package:shodasha_mineral_water/shared/models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount => _items.fold(0, (sum, item) => sum + item.totalPrice);

  bool get isEmpty => _items.isEmpty;

  bool get isNotEmpty => _items.isNotEmpty;

  void addItem(Product product, {int quantity = 1}) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void incrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  CartItem? getItem(String productId) {
    try {
      return _items.firstWhere((item) => item.product.id == productId);
    } catch (_) {
      return null;
    }
  }
}

class LocationProvider extends ChangeNotifier {
  String _selectedLocation = 'Home';
  final List<String> _locations = ['Home', 'Office'];

  String get selectedLocation => _selectedLocation;
  List<String> get locations => List.unmodifiable(_locations);

  void setLocation(String location) {
    if (_locations.contains(location)) {
      _selectedLocation = location;
      notifyListeners();
    }
  }
}

class HomeProvider extends ChangeNotifier {
  OrderMode _selectedMode = OrderMode.instant;
  final Set<String> _selectedScheduleDays = {};

  OrderMode get selectedMode => _selectedMode;
  Set<String> get selectedScheduleDays => Set.unmodifiable(_selectedScheduleDays);

  void setMode(OrderMode mode) {
    _selectedMode = mode;
    notifyListeners();
  }

  void toggleScheduleDay(String day) {
    if (_selectedScheduleDays.contains(day)) {
      _selectedScheduleDays.remove(day);
    } else {
      _selectedScheduleDays.add(day);
    }
    notifyListeners();
  }

  void clearScheduleDays() {
    _selectedScheduleDays.clear();
    notifyListeners();
  }
}