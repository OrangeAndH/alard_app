import 'package:flutter/material.dart';

import '../l10n/app_translations.dart';

/// Owns locale, language selection, and translation lookups.
/// Estimated lines: ~75
class LocaleState {
  Locale _locale = const Locale('en');

  final Map<String, String> supportedLanguages = const {
    'en': 'English',
    'ar': 'العربية',
  };

  Locale get locale => _locale;
  String get languageCode => _locale.languageCode;
  bool get isArabic => languageCode == 'ar';

  void setLocale(String languageCode, VoidCallback notify) {
    if (_locale.languageCode != languageCode) {
      _locale = Locale(languageCode);
      notify();
    }
  }

  /// Translates [key] using the current locale.
  /// Falls back to a humanised key string if not found.
  String t(String key) {
    final translation =
        AppTranslations.translations[_locale.languageCode]?[key];
    if (translation != null) return translation;

    // Fallback: strip common prefixes and convert underscores to spaces.
    String result = key;
    const prefixes = [
      'home_', 'shop_', 'menu_', 'profile_', 'ui_',
      'product_', 'checkout_', 'step_', 'pay_', 'addr_',
    ];
    for (final prefix in prefixes) {
      if (result.startsWith(prefix)) {
        result = result.substring(prefix.length);
        break;
      }
    }
    return result.replaceAll('_', ' ');
  }
}
