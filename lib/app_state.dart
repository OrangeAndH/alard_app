import 'package:flutter/foundation.dart';

class Product {
  final String id;
  final String name;
  final String subtitle;
  final double price;
  final double rating;
  final String category;
  final String image;
  final bool isBestSeller;

  const Product({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.rating,
    required this.category,
    required this.image,
    this.isBestSeller = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'subtitle': subtitle,
        'price': price,
        'rating': rating,
        'category': category,
        'image': image,
        'isBestSeller': isBestSeller,
      };
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get lineTotal => product.price * quantity;

  Map<String, dynamic> toJson() => {
        'productId': product.id,
        'quantity': quantity,
      };
}

class AppState extends ChangeNotifier {
  static const double deliveryFee = 3.0;

  final List<Product> _products = const [
    Product(
      id: 'olive-oil-1l',
      name: 'Virgin Olive Oil',
      subtitle: '1 liter plastic bottle',
      price: 15,
      rating: 4.9,
      category: 'Oil',
      image: 'assets/virgin_oil.png',
      isBestSeller: true,
    ),
    Product(
      id: 'zaatar-1kg',
      name: 'Palestinian Zaatar',
      subtitle: '1KG premium blend',
      price: 10,
      rating: 4.8,
      category: 'Herbs',
      image: 'assets/Zaata.png',
    ),
    Product(
      id: 'dried-sage-100g',
      name: 'Dried Sage',
      subtitle: '100g mountain-picked sage',
      price: 4,
      rating: 4.7,
      category: 'Herbs',
      image: 'assets/Dried_sage.png',
    ),
    Product(
      id: 'green-olives-220g',
      name: 'Green Olives',
      subtitle: '220g local Palestinian olives',
      price: 4,
      rating: 4.6,
      category: 'Olives',
      image: 'assets/green_olive.png',
      isBestSeller: true,
    ),
  ];

  final Map<String, CartItem> _cart = {};

  List<Product> get products => List.unmodifiable(_products);

  List<CartItem> get cartItems => List.unmodifiable(_cart.values);

  int get cartCount {
    return _cart.values.fold(0, (sum, item) => sum + item.quantity);
  }

  double get subtotal {
    return _cart.values.fold(0, (sum, item) => sum + item.lineTotal);
  }

  double get delivery {
    return _cart.isEmpty ? 0 : deliveryFee;
  }

  double get total {
    return subtotal + delivery;
  }

  List<Product> filteredProducts({
    String category = 'All',
    String query = '',
  }) {
    final search = query.trim().toLowerCase();

    return _products.where((product) {
      final matchesCategory = category == 'All' || product.category == category;

      final matchesSearch = search.isEmpty ||
          product.name.toLowerCase().contains(search) ||
          product.subtitle.toLowerCase().contains(search) ||
          product.category.toLowerCase().contains(search);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  void addToCart(Product product) {
    final existingItem = _cart[product.id];

    if (existingItem == null) {
      _cart[product.id] = CartItem(product: product);
    } else {
      existingItem.quantity++;
    }

    notifyListeners();
  }

  void increaseQuantity(String productId) {
    final item = _cart[productId];
    if (item == null) return;

    item.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(String productId) {
    final item = _cart[productId];
    if (item == null) return;

    if (item.quantity <= 1) {
      _cart.remove(productId);
    } else {
      item.quantity--;
    }

    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.remove(productId);
    notifyListeners();
  }

  Map<String, dynamic> createOrderJson({
    required String customerName,
    required String phone,
    required String address,
    String note = '',
  }) {
    return {
      'customerName': customerName,
      'phone': phone,
      'address': address,
      'note': note,
      'subtotal': subtotal,
      'delivery': delivery,
      'total': total,
      'items': cartItems.map((item) => item.toJson()).toList(),
    };
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}