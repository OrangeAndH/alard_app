import 'package:flutter/foundation.dart';

class LocalizedString {
  final String en;
  final String ar;

  const LocalizedString({required this.en, required this.ar});

  String get(String locale) => locale == 'ar' ? ar : en;

  factory LocalizedString.fromJson(dynamic json) {
    if (json is Map) {
      return LocalizedString(
        en: json['en']?.toString() ?? '',
        ar: json['ar']?.toString() ?? '',
      );
    }
    return const LocalizedString(en: '', ar: '');
  }

  Map<String, dynamic> toJson() => {'en': en, 'ar': ar};
}

class RecipeItem {
  final String id;
  final LocalizedString title;
  final String image;
  final String duration;
  final List<String> cookingItems; // internal keys for filtering
  final LocalizedString description;
  final List<LocalizedString> ingredients;
  final List<LocalizedString> steps;

  const RecipeItem({
    required this.id,
    required this.title,
    required this.image,
    required this.duration,
    required this.cookingItems,
    required this.description,
    required this.ingredients,
    required this.steps,
  });

  factory RecipeItem.fromJson(Map<String, dynamic> json) {
    return RecipeItem(
      id: json['id'] as String? ?? '',
      title: LocalizedString.fromJson(json['title']),
      image: json['image'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      cookingItems: json['cookingItems'] is List ? List<String>.from(json['cookingItems']) : [],
      description: LocalizedString.fromJson(json['description']),
      ingredients: json['ingredients'] is List
          ? (json['ingredients'] as List).map((e) => LocalizedString.fromJson(e)).toList()
          : [],
      steps: json['steps'] is List
          ? (json['steps'] as List).map((e) => LocalizedString.fromJson(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title.toJson(),
      'image': image,
      'duration': duration,
      'cookingItems': cookingItems,
      'description': description.toJson(),
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'steps': steps.map((e) => e.toJson()).toList(),
    };
  }
}

class FeedbackItem {
  final String id;
  final String flag;
  final String name;
  final LocalizedString country;
  final LocalizedString text;
  final int stars;

  const FeedbackItem({
    required this.id,
    required this.flag,
    required this.name,
    required this.country,
    required this.text,
    required this.stars,
  });

  factory FeedbackItem.fromJson(Map<String, dynamic> json) {
    return FeedbackItem(
      id: json['id'] as String? ?? '',
      flag: json['flag'] as String? ?? '',
      name: json['name'] as String? ?? '',
      country: LocalizedString.fromJson(json['country']),
      text: LocalizedString.fromJson(json['text']),
      stars: json['stars'] is num ? (json['stars'] as num).toInt() : 5,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'flag': flag,
      'name': name,
      'country': country.toJson(),
      'text': text.toJson(),
      'stars': stars,
    };
  }
}
