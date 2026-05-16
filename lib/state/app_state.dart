import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_models.dart';
import '../l10n/app_translations.dart';

export '../models/app_models.dart';

class AppState extends ChangeNotifier {
  AppState() {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        _currentUser = null;
        notifyListeners();
      } else {
        // Fetch additional info from Firestore (like isTrader)
        try {
          final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
          if (doc.exists) {
            final data = doc.data()!;
            _currentUser = AppUser(
              name: data['name'] ?? user.displayName ?? 'User',
              email: user.email ?? '',
              phone: data['phone'] ?? user.phoneNumber ?? '',
              location: data['location'] ?? '',
              isTrader: data['isTrader'] ?? false,
            );
          } else {
            // Fallback for new social users
            _currentUser = AppUser(
              name: user.displayName ?? 'User',
              email: user.email ?? '',
              phone: user.phoneNumber ?? '',
              location: '',
              isTrader: false,
            );
          }
        } catch (e) {
          debugPrint('Error fetching user profile: $e');
        }
        notifyListeners();
      }
    });
  }
  static const double deliveryFee = 3.0;

  static const Map<String, StoreCurrency> _storeCurrencies = {
    'Palestine': StoreCurrency('Palestine', '₪', 1.0, flag: '🇵🇸'),
    'Germany': StoreCurrency('Germany', '€', 0.25, flag: '🇩🇪'),
    'USA': StoreCurrency('USA', '\$', 0.27, flag: '🇺🇸'),
    'UK': StoreCurrency('UK', '£', 0.21, flag: '🇬🇧'),
    'France': StoreCurrency('France', '€', 0.25, flag: '🇫🇷'),
    'Malaysia': StoreCurrency('Malaysia', 'RM', 1.25, flag: '🇲🇾'),
    'Europe': StoreCurrency('Europe', '€', 0.25, flag: '🇪🇺'),
    'UAE': StoreCurrency('UAE', 'AED', 0.98, flag: '🇦🇪'),
    'KSA': StoreCurrency('KSA', 'SAR', 1.0, flag: '🇸🇦'),
    'Canada': StoreCurrency('Canada', 'C\$', 0.37, flag: '🇨🇦'),
    'Chile': StoreCurrency('Chile', 'CLP', 255.0, flag: '🇨🇱'),
  };

  String get currentStoreFlag => _storeCurrencies[_currentStore]?.flag ?? '🇵🇸';

  AppUser? _currentUser;
  Uint8List? _profileImageBytes;

  Locale _locale = const Locale('en');
  String _currentStore = 'Palestine';
  int _selectedIndex = 0;
  String _shopCategory = 'All';
  String _shopQuery = '';

  AppUser? get currentUser => _currentUser;
  Uint8List? get profileImageBytes => _profileImageBytes;
  bool get isLoggedIn => _currentUser != null;
  bool get isTrader => _currentUser?.isTrader ?? false;
  static const double traderDiscount = 0.8; // 20% discount for traders

  int get selectedIndex => _selectedIndex;
  String get shopCategory => _shopCategory;
  String get shopQuery => _shopQuery;

  void setSelectedIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  void setShopFilters({String? category, String? query}) {
    bool changed = false;
    if (category != null && _shopCategory != category) {
      _shopCategory = category;
      changed = true;
    }
    if (query != null && _shopQuery != query) {
      _shopQuery = query;
      changed = true;
    }
    if (changed) notifyListeners();
  }

  String get currentStore => _currentStore;

  void setCurrentStore(String storeName) {
    if (_storeCurrencies.containsKey(storeName) && _currentStore != storeName) {
      _currentStore = storeName;
      
      // If the new store has no products, try to load/seed them
      final storeProducts = _allProducts.where((p) => p.store == _currentStore).toList();
      if (storeProducts.isEmpty) {
        loadProducts();
      }
      
      notifyListeners();
    }
  }

  double _getEffectivePrice(double basePrice) {
    if (isTrader) {
      return basePrice * traderDiscount;
    }
    return basePrice;
  }

  String getFormattedPrice(double basePrice) {
    if (basePrice <= 0) return t('ui_request_quote');
    
    final effectivePrice = _getEffectivePrice(basePrice);
    final currency = _storeCurrencies[_currentStore] ?? _storeCurrencies['Palestine']!;
    final converted = effectivePrice * currency.exchangeRate;
    
    if (converted % 1 == 0) {
      return '${converted.toStringAsFixed(0)} ${currency.symbol}';
    }
    return '${converted.toStringAsFixed(2)} ${currency.symbol}';
  }

  Locale get locale => _locale;
  String get languageCode => _locale.languageCode;
  bool get isArabic => languageCode == 'ar';

  String get userName => _currentUser?.name ?? t('ui_google_user');
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
    final translation = AppTranslations.translations[_locale.languageCode]?[key];
    if (translation != null) return translation;
    
    // Fallback: remove common prefixes and replace underscores with spaces
    String result = key;
    final prefixes = ['home_', 'shop_', 'menu_', 'profile_', 'ui_', 'product_'];
    for (final p in prefixes) {
      if (result.startsWith(p)) {
        result = result.substring(p.length);
        break;
      }
    }
    
    return result.replaceAll('_', ' ');
  }

  void setCurrentUser(AppUser user) {
    _currentUser = user;
    notifyListeners();
  }

  void setProfileImageBytes(Uint8List bytes) {
    _profileImageBytes = bytes;
    notifyListeners();
  }

  final List<CartItem> _cart = [];
  List<CartItem> get cart => List.unmodifiable(_cart);

  void addToCart(Product product, {ProductVariant? variant, int quantity = 1}) {
    final key = variant != null ? '${product.id}_${variant.id}' : product.id;
    final index = _cart.indexWhere((item) => item.cartKey == key);

    if (index != -1) {
      _cart[index].quantity += quantity;
    } else {
      _cart.add(CartItem(product: product, selectedVariant: variant, quantity: quantity));
    }
    notifyListeners();
  }

  void removeFromCart(String cartKey) {
    _cart.removeWhere((item) => item.cartKey == cartKey);
    notifyListeners();
  }

  void updateCartQuantity(String cartKey, int delta) {
    final index = _cart.indexWhere((item) => item.cartKey == cartKey);
    if (index != -1) {
      _cart[index].quantity += delta;
      if (_cart[index].quantity <= 0) {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  double get cartSubtotal {
    return _cart.fold(0.0, (total, item) {
      return total + (_getEffectivePrice(item.price) * item.quantity);
    });
  }

  double get cartTotal {
    if (cartSubtotal <= 0) return 0;
    return cartSubtotal + deliveryFee;
  }

  final List<AppOrder> _orders = [];
  List<AppOrder> get orders => List.unmodifiable(_orders);

  void placeOrder({
    required String name,
    required String phone,
    required String address,
    required String mailbox,
    required String note,
    required String paymentMethod,
  }) {
    final newOrder = AppOrder(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now(),
      items: _cart.map((item) => OrderLine(
        productName: item.product.name,
        subtitle: item.product.subtitle,
        image: item.product.image,
        price: item.price,
        quantity: item.quantity,
        variantSize: item.selectedVariant?.size,
      )).toList(),
      customerName: name,
      phone: phone,
      deliveryAddress: address,
      mailboxAddress: mailbox,
      note: note,
      paymentMethod: paymentMethod,
      status: 'Pending',
      subtotal: cartSubtotal,
      delivery: deliveryFee,
      total: cartTotal,
    );
    _orders.insert(0, newOrder);
    _cart.clear();
    notifyListeners();
  }

  List<ShippingAddress> _addresses = [
    const ShippingAddress(
      id: '1',
      title: 'Home',
      details: 'Nablus, Al-Makhfiya Street, Building 10, Flat 4',
      mailboxAddress: 'P.O. Box 1234, Nablus Central Post',
      isDefault: true,
    ),
  ];

  List<ShippingAddress> get addresses => List.unmodifiable(_addresses);

  void addAddress(ShippingAddress address) {
    if (address.isDefault) {
      _addresses = _addresses.map((a) => a.copyWith(isDefault: false)).toList();
    }
    _addresses.add(address);
    notifyListeners();
  }

  void deleteAddress(String id) {
    _addresses.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  void setDefaultAddress(String id) {
    _addresses = _addresses.map((a) => a.copyWith(isDefault: a.id == id)).toList();
    notifyListeners();
  }

  List<PaymentMethod> _paymentMethods = [
    const PaymentMethod(
      id: 'cod',
      title: 'Cash on Delivery',
      subtitle: 'Pay when your order arrives',
      isDefault: true,
      isCashOnDelivery: true,
    ),
  ];

  List<PaymentMethod> get paymentMethods => List.unmodifiable(_paymentMethods);

  List<PaymentMethod> get savedCards =>
      _paymentMethods.where((m) => !m.isCashOnDelivery).toList();
  
  List<Product> _allProducts = [];

  void addPaymentMethod(PaymentMethod method) {
    if (method.isDefault) {
      _paymentMethods = _paymentMethods.map((m) => m.copyWith(isDefault: false)).toList();
    }
    _paymentMethods.add(method);
    notifyListeners();
  }

  void deletePaymentMethod(String id) {
    _paymentMethods.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  void setDefaultPaymentMethod(String id) {
    _paymentMethods = _paymentMethods.map((m) => m.copyWith(isDefault: m.id == id)).toList();
    notifyListeners();
  }

  List<Product> get products {
    final storeProducts = _allProducts.where((p) => p.store == _currentStore).toList();
    // Fallback: If current store has no products yet, show Palestine products 
    // (they will still show correct local currency due to getFormattedPrice logic)
    if (storeProducts.isEmpty && _allProducts.isNotEmpty) {
      return _allProducts.where((p) => p.store == 'Palestine').toList();
    }
    return storeProducts;
  }
  bool _productsLoaded = false;
  bool get productsLoaded => _productsLoaded;

  List<String> get productCategories {
    final storeProducts = products;
    if (storeProducts.isEmpty) return ['All'];
    final cats = storeProducts.map((p) => p.category).toSet().toList();
    cats.sort();
    return ['All', ...cats];
  }

  Future<void> loadProducts() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final snapshot = await firestore.collection('products').get();

      if (snapshot.docs.isEmpty) {
        debugPrint('Firestore empty, seeding from local assets...');
        await _seedProductsFromAssets();
        return;
      }

      _allProducts = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Ensure ID from Firestore is used
        return Product.fromJson(data);
      }).toList();

      _productsLoaded = true;

      // If the current store is empty but we have products for other stores,
      // it means we need to re-seed to populate ALL stores.
      final storeProducts = _allProducts.where((p) => p.store == _currentStore).toList();
      if (storeProducts.isEmpty) {
        debugPrint('Store $_currentStore is empty. Seeding globally to ensure availability...');
        await _seedProductsFromAssets();
        return; 
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading products from Firestore: $e. Falling back to assets.');
      await _loadProductsFromAssets();
    }
  }

  Future<void> _loadProductsFromAssets() async {
    try {
      final String response = await rootBundle.loadString('assets/data/products.json');
      final data = await json.decode(response);
      final List<dynamic> productsJson = data;
      _allProducts = productsJson.map((json) => Product.fromJson(json)).toList();
      _productsLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading products from assets: $e');
    }
  }

  Future<void> _seedProductsFromAssets() async {
    try {
      final firestore = FirebaseFirestore.instance;
      
      // Clear existing products to ensure a fresh global seed
      final existing = await firestore.collection('products').get();
      if (existing.docs.isNotEmpty) {
        final batchDelete = firestore.batch();
        for (var doc in existing.docs) {
          batchDelete.delete(doc.reference);
        }
        await batchDelete.commit();
      }

      final List<String> stores = [
        'Palestine', 'Germany', 'USA', 'UK', 'UAE', 
        'KSA', 'France', 'Canada', 'Malaysia', 'Europe', 'Chile'
      ];

      final String response = await rootBundle.loadString('assets/data/products.json');
      final List<dynamic> productsJson = json.decode(response);

      // Prepare all operations
      final List<Map<String, dynamic>> allOps = [];
      for (int i = 0; i < productsJson.length; i++) {
        final pJson = Map<String, dynamic>.from(productsJson[i]);
        for (final store in stores) {
          final productCopy = Map<String, dynamic>.from(pJson);
          productCopy['store'] = store;
          final docId = '${pJson['id']}_${store.toLowerCase().replaceAll(' ', '_')}';
          allOps.add({'id': docId, 'data': productCopy});
        }
      }

      // Execute in chunks of 450 (Firestore limit is 500)
      for (var i = 0; i < allOps.length; i += 450) {
        final batch = firestore.batch();
        final chunk = allOps.sublist(i, i + 450 > allOps.length ? allOps.length : i + 450);
        for (var op in chunk) {
          final docRef = firestore.collection('products').doc(op['id']);
          batch.set(docRef, op['data']);
        }
        await batch.commit();
      }

      debugPrint('Global seeding complete for ${allOps.length} documents.');
      await loadProducts(); // Reload from Firestore
    } catch (e) {
      debugPrint('Error seeding products: $e');
    }
  }

  Future<void> loadProductsFromAssets() => _loadProductsFromAssets();

  List<Product> filteredProducts({String category = 'All', String query = ''}) {
    return products.where((p) {
      final matchesCat = category == 'All' || p.category == category;
      final matchesQuery = query.isEmpty ||
          p.name.toLowerCase().contains(query.toLowerCase()) ||
          p.subtitle.toLowerCase().contains(query.toLowerCase());
      return matchesCat && matchesQuery;
    }).toList();
  }

  final List<String> _favoriteIds = [];
  List<Product> get favoriteProducts {
    return _allProducts.where((p) => _favoriteIds.contains(p.id)).toList();
  }

  List<CartItem> get cartItems => _cart;
  int get cartCount => _cart.fold(0, (total, item) => total + item.quantity);
  double get subtotal => cartSubtotal;

  void decreaseQuantity(String cartKey) => updateCartQuantity(cartKey, -1);
  void increaseQuantity(String cartKey) => updateCartQuantity(cartKey, 1);

  void logout() {
    _currentUser = null;
    _profileImageBytes = null;
    _cart.clear();
    _favoriteIds.clear();
    notifyListeners();
  }

  List<ShippingAddress> get shippingAddresses => addresses;
  void setDefaultShippingAddress(String id) => setDefaultAddress(id);
  
  void addShippingAddress({
    required String title,
    required String details,
    required String mailboxAddress,
  }) {
    final newAddress = ShippingAddress(
      id: 'ADDR-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      details: details,
      mailboxAddress: mailboxAddress,
      isDefault: _addresses.isEmpty,
    );
    addAddress(newAddress);
  }

  void removeShippingAddress(String id) => deleteAddress(id);

  void updateVisaPaymentMethod({
    required String id,
    required String cardHolderName,
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
  }) {
    final index = _paymentMethods.indexWhere((m) => m.id == id);
    if (index != -1) {
      _paymentMethods[index] = _paymentMethods[index].copyWith(
        cardHolderName: cardHolderName,
        cardNumber: cardNumber,
        expiryMonth: expiryMonth,
        expiryYear: expiryYear,
        cvv: cvv,
      );
      notifyListeners();
    }
  }

  void addVisaPaymentMethod({
    required String cardHolderName,
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
  }) {
    final newMethod = PaymentMethod(
      id: 'VISA-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Visa Card',
      subtitle: '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}',
      cardHolderName: cardHolderName,
      cardNumber: cardNumber,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      cvv: cvv,
    );
    addPaymentMethod(newMethod);
  }

  void removePaymentMethod(String id) => deletePaymentMethod(id);

  bool isFavorite(String productId) => _favoriteIds.contains(productId);

  void toggleFavorite(Product product) {
    if (_favoriteIds.contains(product.id)) {
      _favoriteIds.remove(product.id);
    } else {
      _favoriteIds.add(product.id);
    }
    notifyListeners();
  }
}
