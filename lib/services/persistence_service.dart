import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_models.dart';

/// Handles persistence for cart (SharedPreferences) and
/// favorites (Firestore, keyed per authenticated user).
///
/// Usage in AppState:
///   await PersistenceService.saveCart(cartItems);
///   final items = await PersistenceService.loadCart();
///   await PersistenceService.saveFavorites(ids);
///   final ids = await PersistenceService.loadFavorites();
///
/// Estimated lines: ~100
class PersistenceService {
  PersistenceService._();

  static const String _cartKey = 'alard_cart_v1';
  static const String _favoritesKey = 'alard_favorites_v1';

  // ── Cart ─────────────────────────────────────────────────────────

  /// Serializes [items] to JSON and stores in SharedPreferences.
  static Future<void> saveCart(List<CartItem> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(items.map((i) => i.toJson()).toList());
      await prefs.setString(_cartKey, encoded);
    } catch (e) {
      debugPrint('PersistenceService.saveCart error: $e');
    }
  }

  /// Loads cart from SharedPreferences. Returns empty list on any error.
  static Future<List<CartItem>> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_cartKey);
      if (raw == null || raw.isEmpty) return [];
      final List<dynamic> decoded = jsonDecode(raw);
      return decoded
          .map((j) => CartItem.fromJson(j as Map<String, dynamic>))
          .whereType<CartItem>()
          .toList();
    } catch (e) {
      debugPrint('PersistenceService.loadCart error: $e');
      return [];
    }
  }

  /// Clears the persisted cart.
  static Future<void> clearCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cartKey);
    } catch (e) {
      debugPrint('PersistenceService.clearCart error: $e');
    }
  }

  // ── Favorites ────────────────────────────────────────────────────

  /// Saves [favoriteIds] to:
  /// - Firestore (keyed to authenticated user) when logged in.
  /// - SharedPreferences as a fallback for guest users.
  static Future<void> saveFavorites(List<String> favoriteIds) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({'favorites': favoriteIds}, SetOptions(merge: true));
      } catch (e) {
        debugPrint('PersistenceService.saveFavorites Firestore error: $e');
      }
    }
    // Always keep a local copy for offline/guest support.
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritesKey, favoriteIds);
    } catch (e) {
      debugPrint('PersistenceService.saveFavorites prefs error: $e');
    }
  }

  /// Loads favorites from Firestore if logged in, otherwise from SharedPreferences.
  static Future<List<String>> loadFavorites() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();
        if (doc.exists) {
          final data = doc.data();
          final raw = data?['favorites'];
          if (raw is List) {
            return List<String>.from(raw.whereType<String>());
          }
        }
      } catch (e) {
        debugPrint('PersistenceService.loadFavorites Firestore error: $e');
      }
    }
    // Fallback to local prefs.
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_favoritesKey) ?? [];
    } catch (e) {
      debugPrint('PersistenceService.loadFavorites prefs error: $e');
      return [];
    }
  }
}
