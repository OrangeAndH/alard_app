import 'dart:typed_data';

import 'package:flutter/material.dart';

class AppUser {
  final String name;
  final String email;
  final String phone;
  final String location;
  final bool isTrader;

  const AppUser({
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.isTrader,
  });

  String get role => isTrader ? 'Trader' : 'Regular user';
}

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
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get lineTotal => product.price * quantity;
}

class OrderLine {
  final String productName;
  final String subtitle;
  final String image;
  final double price;
  final int quantity;

  const OrderLine({
    required this.productName,
    required this.subtitle,
    required this.image,
    required this.price,
    required this.quantity,
  });

  double get lineTotal => price * quantity;
}

class AppOrder {
  final String id;
  final DateTime date;
  final List<OrderLine> items;
  final String customerName;
  final String phone;
  final String deliveryAddress;
  final String mailboxAddress;
  final String note;
  final String paymentMethod;
  final String status;
  final double subtotal;
  final double delivery;
  final double total;

  const AppOrder({
    required this.id,
    required this.date,
    required this.items,
    required this.customerName,
    required this.phone,
    required this.deliveryAddress,
    required this.mailboxAddress,
    required this.note,
    required this.paymentMethod,
    required this.status,
    required this.subtotal,
    required this.delivery,
    required this.total,
  });
}

class ShippingAddress {
  final String id;
  final String title;
  final String details;
  final String mailboxAddress;
  final bool isDefault;

  const ShippingAddress({
    required this.id,
    required this.title,
    required this.details,
    required this.mailboxAddress,
    this.isDefault = false,
  });

  ShippingAddress copyWith({
    String? title,
    String? details,
    String? mailboxAddress,
    bool? isDefault,
  }) {
    return ShippingAddress(
      id: id,
      title: title ?? this.title,
      details: details ?? this.details,
      mailboxAddress: mailboxAddress ?? this.mailboxAddress,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class PaymentMethod {
  final String id;
  final String title;
  final String subtitle;
  final bool isDefault;
  final bool isCashOnDelivery;

  final String? cardHolderName;
  final String? cardNumber;
  final String? expiryMonth;
  final String? expiryYear;
  final String? cvv;

  const PaymentMethod({
    required this.id,
    required this.title,
    required this.subtitle,
    this.isDefault = false,
    this.isCashOnDelivery = false,
    this.cardHolderName,
    this.cardNumber,
    this.expiryMonth,
    this.expiryYear,
    this.cvv,
  });

  PaymentMethod copyWith({
    String? title,
    String? subtitle,
    bool? isDefault,
    bool? isCashOnDelivery,
    String? cardHolderName,
    String? cardNumber,
    String? expiryMonth,
    String? expiryYear,
    String? cvv,
  }) {
    return PaymentMethod(
      id: id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      isDefault: isDefault ?? this.isDefault,
      isCashOnDelivery: isCashOnDelivery ?? this.isCashOnDelivery,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      cvv: cvv ?? this.cvv,
    );
  }
}

class AppState extends ChangeNotifier {
  static const double deliveryFee = 3.0;

  AppUser? _currentUser;
  Uint8List? _profileImageBytes;

  Locale _locale = const Locale('en');

  AppUser? get currentUser => _currentUser;
  Uint8List? get profileImageBytes => _profileImageBytes;
  bool get isLoggedIn => _currentUser != null;

  Locale get locale => _locale;

  final Map<String, String> _supportedLanguages = const {
    'en': 'English',
    'ar': 'العربية',
    'fr': 'Français',
    'es': 'Español',
    'de': 'Deutsch',
    'tr': 'Türkçe',
  };

  Map<String, String> get supportedLanguages {
    return Map.unmodifiable(_supportedLanguages);
  }

  void setLocale(String languageCode) {
    _locale = Locale(languageCode);
    notifyListeners();
  }

  void setCurrentUser(AppUser user) {
    _currentUser = user;
    notifyListeners();
  }

  void setProfileImageBytes(Uint8List bytes) {
    _profileImageBytes = bytes;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _profileImageBytes = null;
    clearCart();
    notifyListeners();
  }

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
  final Set<String> _favoriteProductIds = {};
  final List<AppOrder> _orders = [];

  final List<ShippingAddress> _shippingAddresses = [
    const ShippingAddress(
      id: 'home',
      title: 'Home',
      details: 'Nablus, Palestine\nStreet 1, Building 2',
      mailboxAddress: 'Home mailbox - near main door',
      isDefault: true,
    ),
    const ShippingAddress(
      id: 'work',
      title: 'Work',
      details: 'Ramallah, Palestine\nMain Street, Office 5',
      mailboxAddress: 'Office reception mailbox',
    ),
  ];

  final List<PaymentMethod> _paymentMethods = [
    const PaymentMethod(
      id: 'cash',
      title: 'Cash on Delivery',
      subtitle: 'Pay when your order arrives',
      isDefault: true,
      isCashOnDelivery: true,
    ),
    const PaymentMethod(
      id: 'visa-4242',
      title: 'Visa **** 4242',
      subtitle: 'Expires 12/2028',
      cardHolderName: 'Alard User',
      cardNumber: '4242424242424242',
      expiryMonth: '12',
      expiryYear: '2028',
      cvv: '123',
    ),
  ];

  List<Product> get products => List.unmodifiable(_products);

  List<CartItem> get cartItems => List.unmodifiable(_cart.values);

  List<AppOrder> get orders => List.unmodifiable(_orders.reversed);

  List<ShippingAddress> get shippingAddresses {
    return List.unmodifiable(_shippingAddresses);
  }

  List<PaymentMethod> get paymentMethods {
    return List.unmodifiable(_paymentMethods);
  }

  List<Product> get favoriteProducts {
    return _products
        .where((product) => _favoriteProductIds.contains(product.id))
        .toList();
  }

  PaymentMethod get defaultPaymentMethod {
    return _paymentMethods.firstWhere(
      (method) => method.isDefault,
      orElse: () => _paymentMethods.first,
    );
  }

  ShippingAddress get defaultShippingAddress {
    return _shippingAddresses.firstWhere(
      (address) => address.isDefault,
      orElse: () => _shippingAddresses.first,
    );
  }

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

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  bool isFavorite(String productId) {
    return _favoriteProductIds.contains(productId);
  }

  void toggleFavorite(Product product) {
    if (_favoriteProductIds.contains(product.id)) {
      _favoriteProductIds.remove(product.id);
    } else {
      _favoriteProductIds.add(product.id);
    }

    notifyListeners();
  }

  void setDefaultShippingAddress(String id) {
    for (int i = 0; i < _shippingAddresses.length; i++) {
      final address = _shippingAddresses[i];

      _shippingAddresses[i] = address.copyWith(
        isDefault: address.id == id,
      );
    }

    notifyListeners();
  }

  void addShippingAddress({
    required String title,
    required String details,
    required String mailboxAddress,
  }) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final shouldBeDefault = _shippingAddresses.isEmpty;

    _shippingAddresses.add(
      ShippingAddress(
        id: id,
        title: title,
        details: details,
        mailboxAddress: mailboxAddress,
        isDefault: shouldBeDefault,
      ),
    );

    notifyListeners();
  }

  void removeShippingAddress(String id) {
    if (_shippingAddresses.length <= 1) return;

    final wasDefault = _shippingAddresses.any(
      (address) => address.id == id && address.isDefault,
    );

    _shippingAddresses.removeWhere((address) => address.id == id);

    if (_shippingAddresses.isNotEmpty && wasDefault) {
      final first = _shippingAddresses.first;
      _shippingAddresses[0] = first.copyWith(isDefault: true);
    }

    notifyListeners();
  }

  void setDefaultPaymentMethod(String id) {
    for (int i = 0; i < _paymentMethods.length; i++) {
      final method = _paymentMethods[i];

      _paymentMethods[i] = method.copyWith(
        isDefault: method.id == id,
      );
    }

    notifyListeners();
  }

  void addVisaPaymentMethod({
    required String cardHolderName,
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
  }) {
    final cleanNumber = cardNumber.replaceAll(' ', '');
    final last4 = cleanNumber.length >= 4
        ? cleanNumber.substring(cleanNumber.length - 4)
        : cleanNumber;

    final id = DateTime.now().millisecondsSinceEpoch.toString();

    _paymentMethods.add(
      PaymentMethod(
        id: id,
        title: 'Visa **** $last4',
        subtitle: 'Expires $expiryMonth/$expiryYear',
        cardHolderName: cardHolderName,
        cardNumber: cleanNumber,
        expiryMonth: expiryMonth,
        expiryYear: expiryYear,
        cvv: cvv,
      ),
    );

    notifyListeners();
  }

  void updateVisaPaymentMethod({
    required String id,
    required String cardHolderName,
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
  }) {
    final index = _paymentMethods.indexWhere((method) => method.id == id);
    if (index == -1) return;

    final oldMethod = _paymentMethods[index];

    if (oldMethod.isCashOnDelivery) return;

    final cleanNumber = cardNumber.replaceAll(' ', '');
    final last4 = cleanNumber.length >= 4
        ? cleanNumber.substring(cleanNumber.length - 4)
        : cleanNumber;

    _paymentMethods[index] = oldMethod.copyWith(
      title: 'Visa **** $last4',
      subtitle: 'Expires $expiryMonth/$expiryYear',
      cardHolderName: cardHolderName,
      cardNumber: cleanNumber,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      cvv: cvv,
    );

    notifyListeners();
  }

  void removePaymentMethod(String id) {
    final index = _paymentMethods.indexWhere((method) => method.id == id);
    if (index == -1) return;

    final method = _paymentMethods[index];

    if (method.isCashOnDelivery) return;

    final wasDefault = method.isDefault;

    _paymentMethods.removeAt(index);

    if (_paymentMethods.isNotEmpty && wasDefault) {
      final cashIndex = _paymentMethods.indexWhere(
        (method) => method.isCashOnDelivery,
      );

      if (cashIndex != -1) {
        final cash = _paymentMethods[cashIndex];
        _paymentMethods[cashIndex] = cash.copyWith(isDefault: true);
      } else {
        final first = _paymentMethods.first;
        _paymentMethods[0] = first.copyWith(isDefault: true);
      }
    }

    notifyListeners();
  }

  AppOrder placeOrder({
    required String customerName,
    required String phone,
    required String deliveryAddress,
    required String mailboxAddress,
    required String note,
    required String paymentMethod,
  }) {
    final order = AppOrder(
      id: '#${1000 + _orders.length + 1}',
      date: DateTime.now(),
      items: _cart.values
          .map(
            (item) => OrderLine(
              productName: item.product.name,
              subtitle: item.product.subtitle,
              image: item.product.image,
              price: item.product.price,
              quantity: item.quantity,
            ),
          )
          .toList(),
      customerName: customerName,
      phone: phone,
      deliveryAddress: deliveryAddress,
      mailboxAddress: mailboxAddress,
      note: note,
      paymentMethod: paymentMethod,
      status: 'Processing',
      subtotal: subtotal,
      delivery: delivery,
      total: total,
    );

    _orders.add(order);
    clearCart();

    return order;
  }
}