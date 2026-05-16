
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

class ProductVariant {
  final String id;
  final String size;
  final double price;
  final String? weight;

  const ProductVariant({
    required this.id,
    required this.size,
    required this.price,
    this.weight,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'] as String,
      size: json['size'] as String,
      price: (json['price'] as num? ?? 0).toDouble(),
      weight: json['weight'] as String?,
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
  final bool isFeatured;
  final String description;
  final String weight;
  final String unitCase;
  final String caseLayer;
  final String upc;
  final int catalogPage;
  final int? ratingCount;
  final String store;
  final List<ProductVariant>? variants;

  const Product({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.rating,
    required this.category,
    required this.image,
    this.isBestSeller = false,
    this.isFeatured = false,
    this.description = '',
    this.weight = '',
    this.unitCase = '',
    this.caseLayer = '',
    this.upc = '',
    this.catalogPage = 0,
    this.ratingCount,
    this.store = 'Palestine',
    this.variants,
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
      isFeatured: json['isFeatured'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      weight: json['weight'] as String? ?? '',
      unitCase: json['unitCase'] as String? ?? '',
      caseLayer: json['caseLayer'] as String? ?? '',
      upc: json['upc'] as String? ?? '',
      catalogPage: (json['catalogPage'] as num? ?? 0).toInt(),
      ratingCount: json['ratingCount'] != null ? (json['ratingCount'] as num).toInt() : 120,
      store: json['store'] as String? ?? 'Palestine',
      variants: json['variants'] != null
          ? (json['variants'] as List<dynamic>)
              .map((v) => ProductVariant.fromJson(v as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  bool get hasPrice => price > 0 || (variants != null && variants!.isNotEmpty);
}

class CartItem {
  final Product product;
  final ProductVariant? selectedVariant;
  int quantity;

  CartItem({
    required this.product,
    this.selectedVariant,
    this.quantity = 1,
  });

  String get cartKey =>
      selectedVariant != null ? '${product.id}_${selectedVariant!.id}' : product.id;

  double get price => selectedVariant?.price ?? product.price;

  double get lineTotal => price * quantity;
}

class OrderLine {
  final String productName;
  final String subtitle;
  final String image;
  final double price;
  final int quantity;
  final String? variantSize;

  const OrderLine({
    required this.productName,
    required this.subtitle,
    required this.image,
    required this.price,
    required this.quantity,
    this.variantSize,
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
  final String flag;

  const StoreCurrency(this.storeName, this.symbol, this.exchangeRate, {required this.flag});
}
