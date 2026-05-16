import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/app_models.dart';
import '../services/persistence_service.dart';

/// Owns product loading, Firestore seeding, filtering, and favorites.
/// Estimated lines: ~200
class ProductState {
  List<Product> _allProducts = [];
  final List<String> _favoriteIds = [];
  bool _productsLoaded = false;

  bool get productsLoaded => _productsLoaded;

  // ── Products ────────────────────────────────────────────────────

  /// Returns products for [currentStore], falling back to Palestine
  /// products if the store has no products yet.
  List<Product> products({required String currentStore}) {
    final storeProducts =
        _allProducts.where((p) => p.store == currentStore).toList();
    if (storeProducts.isEmpty && _allProducts.isNotEmpty) {
      return _allProducts.where((p) => p.store == 'Palestine').toList();
    }
    return storeProducts;
  }

  List<String> productCategories({required String currentStore}) {
    final storeProducts = products(currentStore: currentStore);
    if (storeProducts.isEmpty) return ['All'];
    final cats = storeProducts.map((p) => p.category).toSet().toList()..sort();
    return ['All', ...cats];
  }

  List<Product> filteredProducts({
    required String currentStore,
    String category = 'All',
    String query = '',
  }) {
    return products(currentStore: currentStore).where((p) {
      final matchesCat = category == 'All' || p.category == category;
      final matchesQuery =
          query.isEmpty ||
          p.name.toLowerCase().contains(query.toLowerCase()) ||
          p.subtitle.toLowerCase().contains(query.toLowerCase());
      return matchesCat && matchesQuery;
    }).toList();
  }

  // ── Firestore Load / Seed ────────────────────────────────────────

  Future<void> loadProducts({
    required String currentStore,
    required VoidCallback notify,
  }) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final snapshot = await firestore.collection('products').get();

      if (snapshot.docs.isEmpty) {
        debugPrint('Firestore empty — seeding from local assets...');
        await _seedProductsFromAssets(currentStore: currentStore, notify: notify);
        return;
      }

      _allProducts = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Product.fromJson(data);
      }).toList();

      _productsLoaded = true;

      final storeProducts =
          _allProducts.where((p) => p.store == currentStore).toList();
      if (storeProducts.isEmpty) {
        debugPrint(
          'Store $currentStore is empty — seeding globally...',
        );
        await _seedProductsFromAssets(
          currentStore: currentStore,
          notify: notify,
        );
        return;
      }

      notify();
    } catch (e) {
      debugPrint('Firestore error: $e — falling back to assets.');
      await _loadFromAssets(notify: notify);
    }
  }

  Future<void> _loadFromAssets({required VoidCallback notify}) async {
    try {
      final response =
          await rootBundle.loadString('assets/data/products.json');
      final List<dynamic> productsJson = json.decode(response);
      _allProducts = productsJson.map((j) => Product.fromJson(j)).toList();
      _productsLoaded = true;
      notify();
    } catch (e) {
      debugPrint('Asset load error: $e');
    }
  }

  Future<void> _seedProductsFromAssets({
    required String currentStore,
    required VoidCallback notify,
  }) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Clear existing products to ensure clean seed.
      final existing = await firestore.collection('products').get();
      if (existing.docs.isNotEmpty) {
        final batchDelete = firestore.batch();
        for (final doc in existing.docs) {
          batchDelete.delete(doc.reference);
        }
        await batchDelete.commit();
      }

      const List<String> stores = [
        'Palestine', 'Germany', 'USA', 'UK', 'UAE', 'KSA',
        'France', 'Canada', 'Malaysia', 'Europe', 'Chile',
      ];

      final response =
          await rootBundle.loadString('assets/data/products.json');
      final List<dynamic> productsJson = json.decode(response);

      final List<Map<String, dynamic>> allOps = [];
      for (final productJson in productsJson) {
        final pJson = Map<String, dynamic>.from(productJson);
        for (final store in stores) {
          final productCopy = Map<String, dynamic>.from(pJson);
          productCopy['store'] = store;
          final docId =
              '${pJson['id']}_${store.toLowerCase().replaceAll(' ', '_')}';
          allOps.add({'id': docId, 'data': productCopy});
        }
      }

      // Firestore batch writes are capped at 500 operations.
      for (var i = 0; i < allOps.length; i += 450) {
        final batch = firestore.batch();
        final end = (i + 450) > allOps.length ? allOps.length : i + 450;
        for (final op in allOps.sublist(i, end)) {
          final docRef = firestore.collection('products').doc(op['id']);
          batch.set(docRef, op['data']);
        }
        await batch.commit();
      }

      debugPrint('Seeding complete: ${allOps.length} documents.');
      await loadProducts(currentStore: currentStore, notify: notify);
    } catch (e) {
      debugPrint('Seeding error: $e');
    }
  }

  /// Public alias used by screens that call loadProductsFromAssets directly.
  Future<void> loadProductsFromAssets({required VoidCallback notify}) =>
      _loadFromAssets(notify: notify);

  // ── Favorites ────────────────────────────────────────────────────

  List<Product> favoriteProducts() =>
      _allProducts.where((p) => _favoriteIds.contains(p.id)).toList();

  bool isFavorite(String productId) => _favoriteIds.contains(productId);

  void toggleFavorite(Product product, VoidCallback notify) {
    if (_favoriteIds.contains(product.id)) {
      _favoriteIds.remove(product.id);
    } else {
      _favoriteIds.add(product.id);
    }
    PersistenceService.saveFavorites(List.unmodifiable(_favoriteIds));
    notify();
  }

  void clearFavorites() {
    _favoriteIds.clear();
    PersistenceService.saveFavorites([]);
  }

  /// Loads persisted favorites (Firestore for logged-in users, prefs for guests).
  Future<void> loadPersistedFavorites({required VoidCallback notify}) async {
    final ids = await PersistenceService.loadFavorites();
    if (ids.isNotEmpty) {
      _favoriteIds.clear();
      _favoriteIds.addAll(ids);
      notify();
    }
  }
}
