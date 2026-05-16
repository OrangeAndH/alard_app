import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/content_models.dart';

/// Manages dynamic content (Recipes, Feedback) fetched from Firestore.
class ContentState {
  final List<RecipeItem> _recipes = [];
  bool _recipesLoaded = false;

  List<RecipeItem> get recipes => List.unmodifiable(_recipes);
  bool get recipesLoaded => _recipesLoaded;

  Future<void> loadRecipes(VoidCallback notify) async {
    if (_recipesLoaded) return;
    try {
      final snap = await FirebaseFirestore.instance.collection('content').doc('recipes').collection('items').get();
      if (snap.docs.isNotEmpty) {
        _recipes.clear();
        _recipes.addAll(snap.docs.map((doc) => RecipeItem.fromJson({...doc.data(), 'id': doc.id})));
        _recipesLoaded = true;
        notify();
      }
    } catch (e) {
      debugPrint('Error loading recipes: $e');
    }
  }

  // --- Feedback ---
  final List<FeedbackItem> _feedback = [];
  bool _feedbackLoaded = false;

  List<FeedbackItem> get feedback => List.unmodifiable(_feedback);
  bool get feedbackLoaded => _feedbackLoaded;

  Future<void> loadFeedback(VoidCallback notify) async {
    if (_feedbackLoaded) return;
    try {
      final snap = await FirebaseFirestore.instance.collection('content').doc('feedback').collection('items').get();
      if (snap.docs.isNotEmpty) {
        _feedback.clear();
        _feedback.addAll(snap.docs.map((doc) => FeedbackItem.fromJson({...doc.data(), 'id': doc.id})));
        _feedbackLoaded = true;
        notify();
      }
    } catch (e) {
      debugPrint('Error loading feedback: $e');
    }
  }

  Future<void> addFeedback(FeedbackItem item, VoidCallback notify) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('content').doc('feedback').collection('items').doc();
      final data = item.toJson();
      data.remove('id');
      await docRef.set(data);
      
      _feedback.insert(0, FeedbackItem(
        id: docRef.id,
        flag: item.flag,
        name: item.name,
        country: item.country,
        text: item.text,
        stars: item.stars,
      ));
      notify();
    } catch (e) {
      debugPrint('Error adding feedback: $e');
    }
  }
}
