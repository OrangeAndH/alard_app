import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  String get role => isTrader ? 'Trader' : 'Customer';

  AppUser copyWith({
    String? name,
    String? email,
    String? phone,
    String? location,
    bool? isTrader,
  }) {
    return AppUser(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      isTrader: isTrader ?? this.isTrader,
    );
  }
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
  final String description;
  final String weight;
  final String unitCase;
  final String caseLayer;
  final String upc;
  final int catalogPage;

  const Product({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.rating,
    required this.category,
    required this.image,
    this.isBestSeller = false,
    this.description = '',
    this.weight = '',
    this.unitCase = '',
    this.caseLayer = '',
    this.upc = '',
    this.catalogPage = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      price: (json['price'] as num? ?? 0).toDouble(),
      rating: (json['rating'] as num? ?? 4.7).toDouble(),
      category: json['category'] as String? ?? 'All',
      image: json['image'] as String? ?? '',
      isBestSeller: json['isBestSeller'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      weight: json['weight'] as String? ?? '',
      unitCase: json['unitCase'] as String? ?? '',
      caseLayer: json['caseLayer'] as String? ?? '',
      upc: json['upc'] as String? ?? '',
      catalogPage: (json['catalogPage'] as num? ?? 0).toInt(),
    );
  }

  bool get hasPrice => price > 0;
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

  bool get hasPrice => price > 0;
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

  bool get needsQuote {
    return items.any((item) => !item.hasPrice);
  }
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

class StoreCurrency {
  final String storeName;
  final String symbol;
  final double exchangeRate;

  const StoreCurrency(this.storeName, this.symbol, this.exchangeRate);
}

class AppState extends ChangeNotifier {
  static const double deliveryFee = 3.0;

  static const Map<String, StoreCurrency> _storeCurrencies = {
    'Palestine': StoreCurrency('Palestine', '₪', 1.0),
    'Malaysia': StoreCurrency('Malaysia', 'RM', 1.25),
    'Europe': StoreCurrency('Europe', '€', 0.25),
    'UAE': StoreCurrency('UAE', 'AED', 0.98),
    'KSA': StoreCurrency('KSA', 'SAR', 1.0),
    'Canada': StoreCurrency('Canada', 'C\$', 0.37),
    'Chile': StoreCurrency('Chile', 'CLP', 255.0),
  };

  AppUser? _currentUser;
  Uint8List? _profileImageBytes;

  Locale _locale = const Locale('en');
  String _currentStore = 'Palestine';

  AppUser? get currentUser => _currentUser;
  Uint8List? get profileImageBytes => _profileImageBytes;
  bool get isLoggedIn => _currentUser != null;

  String get currentStore => _currentStore;

  void setCurrentStore(String storeName) {
    if (_storeCurrencies.containsKey(storeName) && _currentStore != storeName) {
      _currentStore = storeName;
      notifyListeners();
    }
  }

  String getFormattedPrice(double basePrice) {
    if (basePrice <= 0) return 'Request quote';
    final currency = _storeCurrencies[_currentStore] ?? _storeCurrencies['Palestine']!;
    final converted = basePrice * currency.exchangeRate;
    
    if (converted % 1 == 0) {
      return '${converted.toStringAsFixed(0)} ${currency.symbol}';
    }
    return '${converted.toStringAsFixed(2)} ${currency.symbol}';
  }

  Locale get locale => _locale;
  String get languageCode => _locale.languageCode;
  bool get isArabic => languageCode == 'ar';

  String get userName => _currentUser?.name ?? 'Google User';
  String get userType => (_currentUser?.isTrader ?? true) ? 'Trader' : 'Customer';
  String get phone => _currentUser?.phone ?? '';

  final Map<String, String> _supportedLanguages = const {
    'en': 'English',
    'ar': 'العربية',
  };

  Map<String, String> get supportedLanguages {
    return Map.unmodifiable(_supportedLanguages);
  }

  void setLocale(String languageCode) {
    _locale = Locale(languageCode);
    notifyListeners();
  }

  void setLanguage(String languageCode) {
    setLocale(languageCode);
  }

  void updatePhone(String newPhone) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(phone: newPhone.trim());
    notifyListeners();
  }

  void updateUserName(String newName) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(name: newName.trim());
    notifyListeners();
  }

  void updateUserType(String newType) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(
      isTrader: newType.trim().toLowerCase() == 'trader',
    );
    notifyListeners();
  }

  String t(String key) {
    final translations = {
      'en': {
        'settings': 'Settings',
        'language': 'Language',
        'appLanguage': 'App Language',
        'chooseLanguage': 'Choose language',
        'english': 'English',
        'arabic': 'Arabic',
        'profile': 'Profile',
        'personalDetails': 'Personal Details',
        'phoneNumber': 'Phone Number',
        'save': 'Save',
        'trader': 'Trader',
        'customer': 'Customer',
        'name': 'Name',
        'accountType': 'Account Type',
        'noPhoneAdded': 'No phone added',
        // Bottom Nav
        'nav_home': 'Home',
        'nav_shop': 'Shop',
        'nav_recipes': 'Recipes',
        'nav_feedback': 'Feedback',
        'nav_profile': 'Profile',
        // Home Screen
        'home_hero_text': 'From Palestine\'s ancient\nolive trees, we offer products\nto complement your dishes',
        'home_discover_story': 'Discover our Story',
        'home_delivering_to': 'delivering to :',
        'home_change_location': 'Change location',
        'home_our_products': 'Our Products',
        'home_view_details': 'View details',
        'home_why_alard': 'Why Al\'Ard ?',
        // Stores
        'store_Palestine': 'Palestine',
        'store_Malaysia': 'Malaysia',
        'store_Europe': 'Europe',
        'store_UAE': 'UAE',
        'store_KSA': 'KSA',
        'store_Canada': 'Canada',
        'store_Chile': 'Chile',
        // Why Al Ard
        'why_title': 'Why Al ‘Ard Product ?',
        'why_natural_title': '100% Natural',
        'why_natural_desc': 'All products are made from natural Palestinian ingredients without artificial additives.',
        'why_premium_title': 'Premium Olive Oil',
        'why_premium_desc': 'High-quality extra virgin olive oil sourced from traditional Palestinian olive trees.',
        'why_farmers_title': 'Support Palestinian Farmers',
        'why_farmers_desc': 'Every purchase helps support local farmers and strengthens the Palestinian agricultural community.',
        'why_taste_title': 'Authentic Palestinian Taste.',
        'why_taste_desc': 'Traditional recipes like za\'atar, sumac, and olive oil that represent the rich heritage of Palestine.',
        'why_eco_title': 'Eco-Friendly Production',
        'why_eco_desc': 'Products are produced using sustainable and environmentally friendly practices.',
      },
      'ar': {
        'settings': 'الإعدادات',
        'language': 'اللغة',
        'appLanguage': 'لغة التطبيق',
        'chooseLanguage': 'اختر اللغة',
        'english': 'الإنجليزية',
        'arabic': 'العربية',
        'profile': 'الملف الشخصي',
        'personalDetails': 'البيانات الشخصية',
        'phoneNumber': 'رقم الهاتف',
        'save': 'حفظ',
        'trader': 'تاجر',
        'customer': 'زبون',
        'name': 'الاسم',
        'accountType': 'نوع الحساب',
        'noPhoneAdded': 'لا يوجد رقم هاتف',
        // Bottom Nav
        'nav_home': 'الرئيسية',
        'nav_shop': 'المتجر',
        'nav_recipes': 'الوصفات',
        'nav_feedback': 'الملاحظات',
        'nav_profile': 'حسابي',
        // Home Screen
        'home_hero_text': 'من أشجار الزيتون الفلسطينية\nالقديمة، نقدم منتجات\nتكمل أطباقك',
        'home_discover_story': 'اكتشف قصتنا',
        'home_delivering_to': 'التوصيل إلى :',
        'home_change_location': 'تغيير الموقع',
        'home_our_products': 'منتجاتنا',
        'home_view_details': 'التفاصيل',
        'home_why_alard': 'لماذا الأرض ؟',
        // Stores
        'store_Palestine': 'فلسطين',
        'store_Malaysia': 'ماليزيا',
        'store_Europe': 'أوروبا',
        'store_UAE': 'الإمارات',
        'store_KSA': 'السعودية',
        'store_Canada': 'كندا',
        'store_Chile': 'تشيلي',
        // Why Al Ard
        'why_title': 'لماذا منتجات الأرض ؟',
        'why_natural_title': 'طبيعي 100%',
        'why_natural_desc': 'جميع المنتجات مصنوعة من مكونات فلسطينية طبيعية بدون إضافات صناعية.',
        'why_premium_title': 'زيت زيتون بكر ممتاز',
        'why_premium_desc': 'زيت زيتون بكر ممتاز وعالي الجودة منتقى من أشجار الزيتون الفلسطينية الأصيلة.',
        'why_farmers_title': 'دعم المزارع الفلسطيني',
        'why_farmers_desc': 'كل عملية شراء تساهم في دعم المزارعين المحليين وتعزيز المجتمع الزراعي الفلسطيني.',
        'why_taste_title': 'مذاق فلسطيني أصيل',
        'why_taste_desc': 'وصفات تقليدية مثل الزعتر والسماق وزيت الزيتون تمثل التراث العريق لفلسطين.',
        'why_eco_title': 'إنتاج صديق للبيئة',
        'why_eco_desc': 'يتم إنتاج المنتجات باستخدام ممارسات مستدامة وصديقة للبيئة.',
      },
    };
    return translations[languageCode]?[key] ?? key;
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

  static const List<Product> _fallbackProducts = [
    Product(
      id: 'olive-oil-1l',
      name: 'Virgin Olive Oil',
      subtitle: '1 liter plastic bottle',
      price: 15,
      rating: 4.9,
      category: 'Olive Oil',
      image: 'assets/virgin_oil.png',
      isBestSeller: true,
    ),
    Product(
      id: 'zaatar-1kg',
      name: 'Palestinian Zaatar',
      subtitle: '1KG premium blend',
      price: 10,
      rating: 4.8,
      category: 'Herbs & Spices',
      image: 'assets/Zaata.png',
    ),
    Product(
      id: 'dried-sage-100g',
      name: 'Dried Sage',
      subtitle: '100g mountain-picked sage',
      price: 4,
      rating: 4.7,
      category: 'Herbs & Spices',
      image: 'assets/Dried_sage.png',
    ),
    Product(
      id: 'green-olives-220g',
      name: 'Green Olives',
      subtitle: '220g local Palestinian olives',
      price: 4,
      rating: 4.6,
      category: 'Pickles',
      image: 'assets/green_olive.png',
      isBestSeller: true,
    ),
  ];

  List<Product> _products = List<Product>.from(_fallbackProducts);
  bool _productsLoaded = false;

  bool get productsLoaded => _productsLoaded;

  Future<void> loadProductsFromAssets() async {
    try {
      final jsonText = await rootBundle.loadString('assets/data/products.json');
      final data = jsonDecode(jsonText) as List<dynamic>;
      _products = data
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList(growable: false);
      _productsLoaded = true;
      notifyListeners();
    } catch (_) {
      _products = List<Product>.from(_fallbackProducts);
      _productsLoaded = false;
      notifyListeners();
    }
  }

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

  List<String> get productCategories {
    final categories = _products.map((product) => product.category).toSet().toList()
      ..sort();
    return ['All', ...categories];
  }

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

  bool get cartNeedsQuote {
    return _cart.values.any((item) => !item.product.hasPrice);
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
          product.category.toLowerCase().contains(search) ||
          product.description.toLowerCase().contains(search) ||
          product.weight.toLowerCase().contains(search) ||
          product.unitCase.toLowerCase().contains(search) ||
          product.caseLayer.toLowerCase().contains(search);
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
      _shippingAddresses[i] = address.copyWith(isDefault: address.id == id);
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
      _paymentMethods[i] = method.copyWith(isDefault: method.id == id);
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