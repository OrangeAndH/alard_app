import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_models.dart';
import 'locale_state.dart';
import 'currency_state.dart';
import 'product_state.dart';
import 'cart_state.dart';
import 'user_state.dart';

export '../models/app_models.dart';

/// Composition root for all app state.
///
/// Delegates to focused sub-states:
///   [LocaleState]    — locale, translations
///   [CurrencyState]  — store selection, price formatting
///   [ProductState]   — product loading, filtering, favorites
///   [CartState]      — cart mutations, order placement
///   [UserState]      — user profile, addresses, payment methods
///
/// All screens access state via AppStateScope.of(context) — no API change.
/// Estimated lines: ~230
class AppState extends ChangeNotifier {
  final LocaleState _locale = LocaleState();
  final CurrencyState _currency = CurrencyState();
  final ProductState _products = ProductState();
  final CartState _cart = CartState();
  final UserState _user = UserState();

  AppState() {
    _listenToAuthChanges();
    _loadPersistedData();
  }

  Future<void> _loadPersistedData() async {
    await Future.wait([
      _cart.loadPersistedCart(notify: notifyListeners),
      _products.loadPersistedFavorites(notify: notifyListeners),
    ]);
  }

  // ── Auth Stream ──────────────────────────────────────────────────

  void _listenToAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? firebaseUser) async {
      if (firebaseUser == null) {
        _user.clearUser();
        notifyListeners();
        return;
      }
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();
        if (doc.exists) {
          final data = doc.data()!;
          _user.setCurrentUser(
            AppUser(
              name: data['name'] ?? firebaseUser.displayName ?? 'User',
              email: firebaseUser.email ?? '',
              phone: data['phone'] ?? firebaseUser.phoneNumber ?? '',
              location: data['location'] ?? '',
              isTrader: data['isTrader'] ?? false,
              isAdmin: data['isAdmin'] ?? false,
            ),
            notifyListeners,
          );
        } else {
          _user.setCurrentUser(
            AppUser(
              name: firebaseUser.displayName ?? 'User',
              email: firebaseUser.email ?? '',
              phone: firebaseUser.phoneNumber ?? '',
              location: '',
              isTrader: false,
              isAdmin: false,
            ),
            notifyListeners,
          );
        }
        _user.startSync(notifyListeners);
      } catch (e) {
        debugPrint('Error fetching user profile: $e');
        notifyListeners();
      }
    });
  }

  // ── Navigation ───────────────────────────────────────────────────

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  // ── Shop Filters ─────────────────────────────────────────────────

  String _shopCategory = 'All';
  String _shopQuery = '';

  String get shopCategory => _shopCategory;
  String get shopQuery => _shopQuery;

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

  // ── Locale Delegation ────────────────────────────────────────────

  Locale get locale => _locale.locale;
  String get languageCode => _locale.languageCode;
  bool get isArabic => _locale.isArabic;
  Map<String, String> get supportedLanguages => _locale.supportedLanguages;

  void setLocale(String languageCode) =>
      _locale.setLocale(languageCode, notifyListeners);

  void setLanguage(String languageCode) => setLocale(languageCode);

  String t(String key) => _locale.t(key);

  // ── Currency Delegation ──────────────────────────────────────────

  static const double deliveryFee = CurrencyState.deliveryFee;
  static const double traderDiscount = CurrencyState.traderDiscount;

  String get currentStore => _currency.currentStore;
  String get currentStoreFlag => _currency.currentStoreFlag;

  void setCurrentStore(String storeName) {
    _currency.setCurrentStore(storeName, notifyListeners);
    // Trigger product load for the new store if needed.
    final storeProds = _products.products(currentStore: storeName);
    if (storeProds.isEmpty) {
      loadProducts();
    }
  }

  String getFormattedPrice(double basePrice) =>
      _currency.getFormattedPrice(
        basePrice,
        isTrader: isTrader,
        translate: t,
      );

  // ── User Delegation ──────────────────────────────────────────────

  AppUser? get currentUser => _user.currentUser;
  Uint8List? get profileImageBytes => _user.profileImageBytes;
  bool get isLoggedIn => _user.isLoggedIn;
  bool get isTrader => _user.isTrader;
  bool get isAdmin => _user.isAdmin;
  String get userName => _user.userName.isNotEmpty ? _user.userName : t('ui_google_user');
  String get userType => _user.userType;
  String get phone => _user.phone;

  void setCurrentUser(AppUser user) => _user.setCurrentUser(user, notifyListeners);
  void setProfileImageBytes(Uint8List bytes) =>
      _user.setProfileImageBytes(bytes, notifyListeners);
  void updatePhone(String newPhone) => _user.updatePhone(newPhone, notifyListeners);
  void updateUserName(String newName) => _user.updateUserName(newName, notifyListeners);
  void updateUserType(String newType) => _user.updateUserType(newType, notifyListeners);

  // Orders
  List<AppOrder> get orders => _user.orders;

  // Addresses
  List<ShippingAddress> get addresses => _user.addresses;
  List<ShippingAddress> get shippingAddresses => _user.shippingAddresses;
  void addAddress(ShippingAddress address) => _user.addAddress(address, notifyListeners);
  void deleteAddress(String id) => _user.deleteAddress(id, notifyListeners);
  void setDefaultAddress(String id) => _user.setDefaultAddress(id, notifyListeners);
  void setDefaultShippingAddress(String id) => _user.setDefaultShippingAddress(id, notifyListeners);
  void addShippingAddress({required String title, required String details, required String mailboxAddress}) =>
      _user.addShippingAddress(title: title, details: details, mailboxAddress: mailboxAddress, notify: notifyListeners);
  void removeShippingAddress(String id) => _user.removeShippingAddress(id, notifyListeners);

  // Payment Methods
  List<PaymentMethod> get paymentMethods => _user.paymentMethods;
  List<PaymentMethod> get savedCards => _user.savedCards;
  void addPaymentMethod(PaymentMethod method) => _user.addPaymentMethod(method, notifyListeners);
  void deletePaymentMethod(String id) => _user.deletePaymentMethod(id, notifyListeners);
  void removePaymentMethod(String id) => _user.removePaymentMethod(id, notifyListeners);
  void setDefaultPaymentMethod(String id) => _user.setDefaultPaymentMethod(id, notifyListeners);
  void addVisaPaymentMethod({required String cardHolderName, required String cardNumber, required String expiryMonth, required String expiryYear, required String cvv}) =>
      _user.addVisaPaymentMethod(cardHolderName: cardHolderName, cardNumber: cardNumber, expiryMonth: expiryMonth, expiryYear: expiryYear, cvv: cvv, notify: notifyListeners);
  void updateVisaPaymentMethod({required String id, required String cardHolderName, required String cardNumber, required String expiryMonth, required String expiryYear, required String cvv}) =>
      _user.updateVisaPaymentMethod(id: id, cardHolderName: cardHolderName, cardNumber: cardNumber, expiryMonth: expiryMonth, expiryYear: expiryYear, cvv: cvv, notify: notifyListeners);

  // ── Product Delegation ───────────────────────────────────────────

  bool get productsLoaded => _products.productsLoaded;

  List<Product> get products => _products.products(currentStore: currentStore);
  List<String> get productCategories => _products.productCategories(currentStore: currentStore);

  List<Product> filteredProducts({String category = 'All', String query = ''}) =>
      _products.filteredProducts(currentStore: currentStore, category: category, query: query);

  Future<void> loadProducts() =>
      _products.loadProducts(currentStore: currentStore, notify: notifyListeners);

  Future<void> loadProductsFromAssets() =>
      _products.loadProductsFromAssets(notify: notifyListeners);

  List<Product> get favoriteProducts => _products.favoriteProducts();
  bool isFavorite(String productId) => _products.isFavorite(productId);
  void toggleFavorite(Product product) =>
      _products.toggleFavorite(product, notifyListeners);

  // ── Cart Delegation ──────────────────────────────────────────────

  List<CartItem> get cart => _cart.cart;
  List<CartItem> get cartItems => _cart.cartItems;
  int get cartCount => _cart.cartCount;
  double get cartSubtotal => _cart.cartSubtotal(isTrader: isTrader);
  double get cartTotal => _cart.cartTotal(isTrader: isTrader);
  double get subtotal => cartSubtotal;

  void addToCart(Product product, {ProductVariant? variant, int quantity = 1}) =>
      _cart.addToCart(product, variant: variant, quantity: quantity, notify: notifyListeners);

  void removeFromCart(String cartKey) => _cart.removeFromCart(cartKey, notifyListeners);
  void updateCartQuantity(String cartKey, int delta) =>
      _cart.updateCartQuantity(cartKey, delta, notifyListeners);
  void decreaseQuantity(String cartKey) => _cart.decreaseQuantity(cartKey, notifyListeners);
  void increaseQuantity(String cartKey) => _cart.increaseQuantity(cartKey, notifyListeners);
  void clearCart() => _cart.clearCart(notifyListeners);

  Future<void> placeOrder({
    required String name,
    required String phone,
    required String address,
    required String mailbox,
    required String note,
    required String paymentMethod,
  }) async {
    final newOrder = await _cart.placeOrder(
      name: name,
      phone: phone,
      address: address,
      mailbox: mailbox,
      note: note,
      paymentMethod: paymentMethod,
      isTrader: isTrader,
    );
    if (newOrder != null) {
      _user.addOrder(newOrder, notifyListeners);
    }
    notifyListeners();
  }

  // ── Global Logout ────────────────────────────────────────────────

  void logout() {
    _user.clearUserData();
    _cart.clearCart(notifyListeners);
    _products.clearFavorites();
    notifyListeners();
  }
}
