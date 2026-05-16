import 'package:flutter/material.dart';

import '../models/app_models.dart';

/// Owns store selection, currency conversion, and price formatting.
/// Estimated lines: ~85
class CurrencyState {
  static const double deliveryFee = 3.0;
  static const double traderDiscount = 0.8; // 20% off for traders

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

  String _currentStore = 'Palestine';

  String get currentStore => _currentStore;

  String get currentStoreFlag =>
      _storeCurrencies[_currentStore]?.flag ?? '🇵🇸';

  bool isValidStore(String storeName) =>
      _storeCurrencies.containsKey(storeName);

  /// Returns the list of all store names in order.
  List<String> get storeNames => _storeCurrencies.keys.toList();

  void setCurrentStore(String storeName, VoidCallback notify) {
    if (_storeCurrencies.containsKey(storeName) &&
        _currentStore != storeName) {
      _currentStore = storeName;
      notify();
    }
  }

  /// Applies the trader discount to [basePrice] when [isTrader] is true.
  double getEffectivePrice(double basePrice, {required bool isTrader}) {
    return isTrader ? basePrice * traderDiscount : basePrice;
  }

  /// Formats [basePrice] in the current store's currency.
  /// Returns a localised quote string if price is 0.
  String getFormattedPrice(
    double basePrice, {
    required bool isTrader,
    required String Function(String) translate,
  }) {
    if (basePrice <= 0) return translate('ui_request_quote');

    final effectivePrice = getEffectivePrice(basePrice, isTrader: isTrader);
    final currency =
        _storeCurrencies[_currentStore] ?? _storeCurrencies['Palestine']!;
    final converted = effectivePrice * currency.exchangeRate;

    if (converted % 1 == 0) {
      return '${converted.toStringAsFixed(0)} ${currency.symbol}';
    }
    return '${converted.toStringAsFixed(2)} ${currency.symbol}';
  }
}
