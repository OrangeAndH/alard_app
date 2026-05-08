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
  int _selectedIndex = 0;

  AppUser? get currentUser => _currentUser;
  Uint8List? get profileImageBytes => _profileImageBytes;
  bool get isLoggedIn => _currentUser != null;
  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  String get currentStore => _currentStore;

  void setCurrentStore(String storeName) {
    if (_storeCurrencies.containsKey(storeName) && _currentStore != storeName) {
      _currentStore = storeName;
      notifyListeners();
    }
  }

  String getFormattedPrice(double basePrice) {
    if (basePrice <= 0) return t('ui_request_quote');
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
        'home_continue_shopping': 'Continue Shopping',
        'home_menu_barrier': 'Menu',
        'home_our_products': 'Our Products',
        'home_view_details': 'View details',
        'home_why_alard': 'Why Al\'Ard ?',
        'shop_catalog_loading_backup': 'Loading local catalog. Showing backup products for now.',
        // Stores
        'store_Palestine': 'Palestine',
        'store_Germany': 'Germany',
        'store_USA': 'United States',
        'store_UK': 'United Kingdom',
        'store_UAE': 'United Arab Emirates',
        'store_KSA': 'Saudi Arabia',
        'store_France': 'France',
        'store_Canada': 'Canada',
        'store_Malaysia': 'Malaysia',
        'store_Europe': 'Europe',
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
        // Login Screen
        'login_continue_as': 'Continue as:',
        'login_trader': 'Trader',
        'login_customer': 'Regular user',
        'login_welcome': "Welcome to Al'Ard!",
        'login_subtext': 'Log in or create an account to continue',
        'login_email': 'Email',
        'login_password': 'Password',
        'login_forgot_password': 'Forgot password?',
        'login_button': 'Log In',
        'login_create_account': 'Create New Account',
        'login_or_with': 'Or log in with',
        // Shop Screen
        'shop_heritage_subtitle': "Al'Ard: Pure Authentic Palestinian Heritage - Available Worldwide",
        'shop_filter_category': 'Filter by Product Category',
        'shop_no_products': 'No products found',
        'shop_show_all': 'Show all products',
        'shop_clear': 'Clear',
        'shop_add_to_cart': 'ADD TO CART',
        'shop_best': 'Best',
        'shop_regular_price': 'regular price',
        'shop_showing_results': 'Showing results for',
        // Feedback Screen
        'feedback_customer_feedback': 'Customer Feedback',
        'feedback_all_countries': 'All Countries',
        'feedback_add_title': 'Add your feedback',
        'feedback_from_profile': 'from profile',
        'feedback_write_hint': 'Write your feedback...',
        'feedback_rating_label': 'Rating:',
        'feedback_add_button': 'Add',
        'feedback_success': 'Feedback added successfully.',
        // Trader Shop Screen
        'shop_search_hint': 'search for products...',
        'shop_available_in': 'Available in Germany, United Kingdom, France, Canada, USA',
        'shop_trending_searches': 'Trending Searches',
        // General UI
        'ui_request_quote': 'Request quote',
        'ui_google_user': 'Google User',
        'ui_cancel': 'Cancel',
        'ui_add': 'Add',
        'ui_delete': 'Delete',
        // Address & Payment
        'addr_home': 'Home',
        'addr_work': 'Work',
        'addr_shipping_title': 'Shipping Addresses',
        'addr_save': 'Save this address',
        // Recipes
        'recipe_2_title': 'Palestinian Sumac Salad',
        'recipe_2_desc': 'A fresh Palestinian salad with chopped vegetables, herbs, olive oil, and sumac for a bright tangy flavor.',
        'recipe_2_ing_1': '2 cucumbers, chopped',
        'recipe_2_ing_2': '2 tomatoes, chopped',
        'recipe_2_ing_3': 'Fresh parsley',
        'recipe_2_ing_4': '2 tbsp Al’Ard Olive Oil',
        'recipe_2_ing_5': '1 tsp Palestinian sumac',
        'recipe_2_step_1': 'Chop all vegetables and place them in a bowl.',
        'recipe_2_step_2': 'Add parsley, salt, and sumac.',
        'recipe_2_step_3': 'Drizzle olive oil over the salad.',
        'recipe_2_step_4': 'Mix well and serve fresh.',

        'recipe_3_title': 'Zaatar Eggs Breakfast',
        'recipe_3_desc': 'A warm breakfast recipe using eggs, olive oil, and zaatar for a simple Palestinian-inspired morning dish.',
        'recipe_3_ing_1': '2 eggs',
        'recipe_3_ing_2': '1 tbsp Al’Ard Olive Oil',
        'recipe_3_ing_3': '1 tsp Palestinian Zaatar',
        'recipe_3_ing_4': 'Salt and pepper',
        'recipe_3_step_1': 'Heat olive oil in a small pan.',
        'recipe_3_step_2': 'Add the eggs and cook gently.',
        'recipe_3_step_3': 'Sprinkle zaatar, salt, and pepper.',
        'recipe_3_step_4': 'Serve hot with bread.',

        'recipe_4_title': 'Zaatar Roasted Chicken',
        'recipe_4_desc': 'A rich roasted chicken recipe flavored with olive oil, zaatar, lemon, and herbs.',
        'recipe_4_ing_1': 'Chicken pieces',
        'recipe_4_ing_2': '3 tbsp Al’Ard Olive Oil',
        'recipe_4_ing_3': '2 tbsp Palestinian Zaatar',
        'recipe_4_ing_4': 'Lemon juice',
        'recipe_4_step_1': 'Mix olive oil, zaatar, lemon juice, salt, and pepper.',
        'recipe_4_step_2': 'Coat the chicken well with the mixture.',
        'recipe_4_step_3': 'Place in a baking tray with potatoes.',
        'recipe_4_step_4': 'Bake until golden and fully cooked.',
        'addr_no_saved': 'No saved addresses yet.',
        'addr_tracking': 'Product Delivery Tracking',
        'addr_no_active': 'No active product deliveries yet.',
        'addr_default': 'Default',
        'addr_mailbox': 'Mailbox',
        'addr_set_default': 'Set default',
        'addr_delete_tooltip': 'Delete address',
        'addr_order_prefix': 'Order',
        'addr_status_prefix': 'Status',
        'addr_delivery_prefix': 'Delivery address',
        'addr_add_title': 'Add Address',
        'addr_label_title': 'Address title',
        'addr_hint_title': 'Example: Home',
        'addr_label_details': 'Full address',
        'addr_hint_details': 'Example: Nablus, Street 1, Building 2',
        'addr_label_mailbox': 'Mailbox address',
        'addr_hint_mailbox': 'Example: mailbox near main door',
        'addr_delete_confirm_title': 'Delete Address',
        'addr_delete_confirm_msg': 'Are you sure you want to delete',
        'addr_deleted_snack': 'Address deleted',
        'pay_cod': 'Cash on Delivery',
        'pay_cod_desc': 'Pay when your order arrives',
        'pay_visa': 'Visa',
        'pay_expires': 'Expires',
        'pay_title': 'Payment Methods',
        'pay_add_visa': 'Add Visa',
        'pay_holder': 'Holder',
        'pay_edit_visa_tooltip': 'Edit Visa',
        'pay_delete_visa_tooltip': 'Delete Visa',
        'pay_use': 'Use',
        'pay_edit_card_title': 'Edit Visa Card',
        'pay_add_card_title': 'Add Visa Card',
        'pay_label_holder': 'Card holder name',
        'pay_hint_holder': 'Example: Mohammed Ahmad',
        'pay_label_number': 'Card number',
        'pay_hint_number': '16 digits',
        'pay_label_month': 'Month',
        'pay_hint_month': 'MM',
        'pay_label_year': 'Year',
        'pay_hint_year': 'YYYY',
        'pay_label_cvv': 'CVV',
        'pay_hint_cvv': '3 or 4 digits',
        'pay_demo_warning': 'For this demo app, card information is stored only inside the app state. Do not use real card details.',
        'pay_save': 'Save',
        'pay_error_fill': 'Please fill all card information',
        'pay_error_number': 'Card number must be 16 digits',
        'pay_error_month': 'Expiry month must be between 01 and 12',
        'pay_error_year': 'Expiry year must be 4 digits',
        'pay_error_cvv': 'CVV must be 3 or 4 digits',
        'pay_delete_card_title': 'Delete Visa Card',
        'pay_deleted_snack': 'Visa card deleted',
        // Personal Details
        'personal_full_name': 'Full Name',
        'personal_email_address': 'Email Address',
        'personal_phone_number': 'Phone Number',
        'personal_country': 'Country',
        'personal_city': 'City',
        'personal_save_changes': 'Save Changes',
        'personal_error_name': 'Name cannot be empty',
        'personal_error_email': 'Please enter a valid email address',
        'personal_error_phone': 'Please enter a valid phone number',
        'personal_success_saved': 'Changes saved successfully',
        'country_palestine': 'Palestine',
        'country_germany': 'Germany',
        'country_usa': 'USA',
        'country_uae': 'UAE',
        // Menu Items
        'menu_home': 'Home page',
        'menu_gifts': 'Gifts',
        'menu_olive_oil': 'Palestinian olive oil',
        'menu_pickled_olives': 'Green pickled olives',
        'menu_cheese': 'Nabulsi Cheese',
        'menu_herbs': 'Mixed thyme and medicinal herbs',
        'menu_tahini': 'Premium tahini paste',
        'menu_hot_sauce': 'Palestinian hot sauce',
        'menu_grains': 'Freekeh and maftoul',
        'menu_black_seed': 'Black seed - Qizha',
        'menu_soap': 'Nabulsi soap',
        // Story Screen
        'story_who_we_are': 'Who We Are',
        'story_who_we_are_desc': 'Al’Ard Palestinian Agricultural Products is an innovative and dynamic company that offers a wide range of high-quality Palestinian agricultural products.\\nFounded in 2008, the company is a member of the International Fair Trade Association and strongly believes in the principles of social investment.\\nWe focus on supporting, empowering, and encouraging Palestinian farmers to benefit from the rich agricultural potential of Palestine.\\nWe provide them with the necessary tools, training, and knowledge to produce high-quality products that can compete in global markets.',
        'story_our_story': 'Our Story',
        'story_our_story_desc_1': 'Al’Ard was founded by Ziad Anabtawi to support poor Palestinian farmers who struggled to sell their olive oil at a fair price.\\n\\nHe helped them by providing modern facilities and connecting them with international markets.',
        'story_our_story_desc_2': 'Now, more than ten years later, his son Sobhi returned to Palestine after traveling across Europe to learn about organic farming and fair-trade practices. Today, the company continues to support farmers first by maintaining transparent and ethical business practices while helping farmers access tools, storage facilities, and internationally recognized certifications.',
        'story_fair_trade': 'Fair Trade',
        'story_palestinian_products': 'Palestinian\\nProducts',
        'story_supporting_farmers': 'Supporting\nFarmers',
        // Product Details
        'product_best_seller': 'Best Seller',
        'product_ratings_count': '(Ratings)',
        'product_about': 'About this product',
        'product_quantity': 'Quantity',
        'product_total_price': 'Total price',
        'product_add_more': 'Add More',
        'product_add_to_cart': 'Add to Cart',
        'product_added_to_cart': 'added to cart',
        'product_desc_oil': 'Cold-pressed from hand-picked Palestinian olives, this extra virgin olive oil carries centuries of tradition. Rich in polyphenols and with a robust, fruity flavor, it is the perfect companion for cooking, dipping, and dressing.',
        'product_desc_herbs': 'Sourced directly from the hills and mountains of Palestine, our herbs are sun-dried to preserve their natural aroma and medicinal properties. Each batch is carefully selected to bring you the finest quality.',
        'product_desc_olives': 'Traditionally cured Palestinian olives, harvested at peak ripeness for maximum flavor. These olives carry the authentic taste of the land, brined to perfection using time-honored methods.',
        'product_desc_default': 'Carefully sourced from Palestinian farmers and artisans, this product reflects our commitment to quality, authenticity, and supporting local communities. Every purchase helps sustain the heritage and livelihoods of Palestinian families.',
        // Categories
        'All': 'All',
        'Olive Oil': 'Olive Oil',
        'Herbs & Spices': 'Herbs & Spices',
        'Pickles': 'Pickles',
        'Dairy': 'Dairy',
        'Grains': 'Grains',
        'Tahini & Halawa': 'Tahini & Halawa',
        'Snacks': 'Snacks',
        'Gift Boxes': 'Gift Boxes',
        'Organic': 'Organic',
        'Zaatar': 'Zaatar',
        'home_palestinian_breakfast': 'Palestinian Breakfast',
        'home_olive_oil_dip': 'Olive Oil Dip',
        'home_100_percent': '100%',
        'home_natural': 'Natural',
        'home_premium': 'Premium',
        'home_olive_oil_tag': 'Olive Oil',
        'product_short_olives_220g': '220g Local Palestinian\\nGreen Olives',
        'prod_name_oil_1l': 'Virgin Olive Oil',
        'prod_sub_oil_1l': '1 liter plastic bottle',
        'prod_name_zaatar_1kg': 'Palestinian Zaatar',
        'prod_sub_zaatar_1kg': '1KG premium blend',
        'prod_name_sage_100g': 'Dried Sage',
        'prod_sub_sage_100g': '100g mountain-picked sage',
        'prod_name_olives_220g': 'Green Olives',
        'prod_sub_olives_220g': '220g local Palestinian olives',
        // Register Screen
        'register_title': 'Create New Account',
        'register_subtitle': 'Join Al\'Ard family today',
        'register_name': 'Full Name',
        'register_email': 'Email',
        'register_password': 'Password',
        'register_confirm_password': 'Confirm Password',
        'register_button': 'Create Account',
        'register_fill_fields': 'Please fill all fields',
        'register_password_mismatch': 'Passwords do not match',
        'register_already_have': 'Already have an account? Log In',
        // Recipes Screen
        'recipes_title': "Recipes using Al'Ard Products",
        'recipes_search_hint': 'Search recipes...',
        'recipes_view_button': 'View recipe',
        'recipes_ingredients': 'Ingredients',
        'recipes_steps': 'Steps',
        'recipes_no_results': 'No recipes found',
        'recipes_try_items': 'Try Olive Oil, Zaatar, Sumac, Tahini, or Freekeh.',
        'recipe_cat_all': 'All',
        'recipe_cat_olive_oil': 'Olive Oil',
        'recipe_cat_zaatar': 'Zaatar',
        'recipe_cat_sumac': 'Sumac',
        'recipe_cat_tahini': 'Tahini',
        'recipe_cat_freekeh': 'Freekeh',
        'recipe_cat_maftoul': 'Maftoul',
        'recipe_cat_black_seed': 'Black Seed',
        // Profile Screen
        'profile_shipping_addresses': 'Shipping Addresses',
        'profile_order_history': 'Order History',
        'profile_favorites': 'My Favorites',
        'profile_payment_methods': 'Payment Methods',
        'profile_notifications': 'Notifications',
        'profile_help_support': 'Help & Support',
        'profile_personal_details': 'Personal Details',
        'profile_logout': 'Logout',
        // Checkout Steps
        'step_cart': 'Cart',
        'step_shipping': 'Shipping',
        'step_payment': 'Payment',
        'step_review': 'Review',
        // Checkout Titles & Buttons
        'checkout_shipping': 'Shipping',
        'checkout_payment': 'Payment',
        'checkout_review': 'Review',
        'checkout_continue_payment': 'Continue To Payment',
        'checkout_continue_review': 'Continue To Review',
        'checkout_place_order': 'Place Order',
        'checkout_order_summary': 'Order Summary',
        'checkout_subtotal': 'Subtotal',
        'checkout_shipping_fee': 'Shipping',
        'checkout_vat': 'Vat',
        'checkout_total': 'Total',
        'checkout_delivery_method': 'Delivery Method',
        'checkout_billing_address': 'Billing Address',
        'checkout_delivering_to': 'Delivering to',
        'checkout_change_location': 'change location',
        'checkout_authentic': '100% Authentic',
        'checkout_secure_shipping': 'Secure Global Shipping',
        'checkout_sustainable': 'Sustainably Packed',
        // Recipe Details
        'recipe_details_title': 'Recipe details',
        // Recipe Data
        'recipe_1_title': 'Olive Oil & Zaatar Bread Dip',
        'recipe_1_desc': 'A quick Palestinian-style dip made with extra virgin olive oil and zaatar. It is simple, authentic, and perfect with fresh bread.',
        'recipe_1_ing_1': '4 tbsp Al’Ard Extra Virgin Olive Oil',
        'recipe_1_ing_2': '2 tbsp Palestinian Zaatar',
        'recipe_1_ing_3': 'Fresh bread for serving',
        'recipe_1_ing_4': 'Optional: sesame seeds',
        'recipe_1_step_1': 'Pour the olive oil into a shallow serving bowl.',
        'recipe_1_step_2': 'Add zaatar on top and mix lightly.',
        'recipe_1_step_3': 'Serve immediately with fresh bread.',
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
        'nav_home': 'الرئيسية',
        'nav_shop': 'المتجر',
        'nav_recipes': 'الوصفات',
        'nav_feedback': 'الملاحظات',
        'nav_profile': 'حسابي',
        'home_hero_text': 'من أشجار الزيتون الفلسطينية\nالقديمة، نقدم منتجات\nتكمل أطباقك',
        'home_discover_story': 'اكتشف قصتنا',
        'home_delivering_to': 'التوصيل إلى :',
        'home_change_location': 'تغيير الموقع',
        'home_continue_shopping': 'مواصلة التسوق',
        'home_menu_barrier': 'القائمة',
        'home_our_products': 'منتجاتنا',
        'home_view_details': 'التفاصيل',
        'home_why_alard': 'لماذا الأرض ؟',
        'shop_catalog_loading_backup': 'جاري تحميل الكتالوج المحلي. يتم عرض المنتجات الاحتياطية حالياً.',
        'store_Palestine': 'فلسطين',
        'store_Germany': 'ألمانيا',
        'store_USA': 'الولايات المتحدة',
        'store_UK': 'المملكة المتحدة',
        'store_UAE': 'الإمارات العربية المتحدة',
        'store_KSA': 'المملكة العربية السعودية',
        'store_France': 'فرنسا',
        'store_Canada': 'كندا',
        'store_Malaysia': 'ماليزيا',
        'store_Europe': 'أوروبا',
        'store_Chile': 'تشيلي',
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
        'login_continue_as': 'متابعة كـ:',
        'login_trader': 'تاجر',
        'login_customer': 'مستخدم عادي',
        'login_welcome': 'مرحباً بكم في الأرض!',
        'login_subtext': 'سجل الدخول أو أنشئ حساباً للمتابعة',
        'login_email': 'البريد الإلكتروني',
        'login_password': 'كلمة المرور',
        'login_forgot_password': 'هل نسيت كلمة المرور؟',
        'login_button': 'تسجيل الدخول',
        'login_create_account': 'إنشاء حساب جديد',
        'login_or_with': 'أو سجل الدخول بواسطة',
        'shop_heritage_subtitle': 'الأرض: تراث فلسطيني أصيل - متوفر في جميع أنحاء العالم',
        'shop_filter_category': 'تصفية حسب فئة المنتج',
        'shop_no_products': 'لم يتم العثور على منتجات',
        'shop_show_all': 'إظهار كل المنتجات',
        'shop_clear': 'مسح',
        'shop_add_to_cart': 'أضف إلى السلة',
        'shop_best': 'الأفضل',
        'shop_regular_price': 'السعر العادي',
        'shop_showing_results': 'عرض النتائج لـ',
        'feedback_customer_feedback': 'آراء العملاء',
        'feedback_all_countries': 'جميع الدول',
        'feedback_add_title': 'أضف ملاحظاتك',
        'feedback_from_profile': 'من الملف الشخصي',
        'feedback_write_hint': 'اكتب ملاحظاتك...',
        'feedback_rating_label': 'التقييم:',
        'feedback_add_button': 'إضافة',
        'feedback_success': 'تمت إضافة الملاحظات بنجاح.',
        'shop_search_hint': 'ابحث عن المنتجات...',
        'shop_available_in': 'متوفر في ألمانيا، المملكة المتحدة، فرنسا، كندا، الولايات المتحدة',
        'shop_trending_searches': 'عمليات البحث الشائعة',
        'ui_request_quote': 'طلب تسعيرة',
        'ui_google_user': 'مستخدم جوجل',
        'ui_cancel': 'إلغاء',
        'ui_add': 'إضافة',
        'ui_delete': 'حذف',
        'addr_home': 'المنزل',
        'addr_work': 'العمل',
        'addr_shipping_title': 'عناوين الشحن',
        'addr_saved': 'العناوين المحفوظة',
        'addr_no_saved': 'لا توجد عناوين محفوظة بعد.',
        'addr_tracking': 'تتبع توصيل المنتجات',
        'addr_no_active': 'لا توجد عمليات توصيل نشطة بعد.',
        'addr_default': 'الافتراضي',
        'addr_mailbox': 'صندوق البريد',
        'addr_set_default': 'تعيين كافتراضي',
        'addr_delete_tooltip': 'حذف العنوان',
        'addr_order_prefix': 'الطلب',
        'addr_status_prefix': 'الحالة',
        'addr_delivery_prefix': 'عنوان التوصيل',
        'addr_add_title': 'إضافة عنوان',
        'addr_label_title': 'عنوان العنوان',
        'addr_hint_title': 'مثال: المنزل',
        'addr_label_details': 'العنوان الكامل',
        'addr_hint_details': 'مثال: نابلس، شارع ١، بناية ٢',
        'addr_label_mailbox': 'عنوان صندوق البريد',
        'addr_hint_mailbox': 'مثال: الصندوق قرب الباب الرئيسي',
        'addr_delete_confirm_title': 'حذف العنوان',
        'addr_delete_confirm_msg': 'هل أنت متأكد أنك تريد حذف',
        'addr_deleted_snack': 'تم حذف العنوان',
        'pay_cod': 'الدفع عند الاستلام',
        'pay_cod_desc': 'ادفع عند استلام طلبك',
        'pay_visa': 'فيزا',
        'pay_expires': 'تنتهي في',
        'pay_title': 'طرق الدفع',
        'pay_add_visa': 'إضافة فيزا',
        'pay_holder': 'صاحب البطاقة',
        'pay_edit_visa_tooltip': 'تعديل الفيزا',
        'pay_delete_visa_tooltip': 'حذف الفيزا',
        'pay_use': 'استخدام',
        'pay_edit_card_title': 'تعديل بطاقة الفيزا',
        'pay_add_card_title': 'إضافة بطاقة فيزا',
        'pay_label_holder': 'اسم صاحب البطاقة',
        'pay_hint_holder': 'مثال: محمد أحمد',
        'pay_label_number': 'رقم البطاقة',
        'pay_hint_number': '١٦ رقماً',
        'pay_label_month': 'الشهر',
        'pay_hint_month': 'ش ش',
        'pay_label_year': 'السنة',
        'pay_hint_year': 'س س س س',
        'pay_label_cvv': 'الرمز السري',
        'pay_hint_cvv': '٣ أو ٤ أرقام',
        'pay_demo_warning': 'في هذا التطبيق التجريبي، تُخزن معلومات البطاقة داخل حالة التطبيق فقط. لا تستخدم تفاصيل بطاقة حقيقية.',
        'pay_save': 'حفظ',
        'pay_error_fill': 'يرجى ملء جميع معلومات البطاقة',
        'pay_error_number': 'يجب أن يتكون رقم البطاقة من ١٦ رقماً',
        'pay_error_month': 'يجب أن يكون شهر الانتهاء بين ٠١ و ١٢',
        'pay_error_year': 'يجب أن تكون سنة الانتهاء من ٤ أرقام',
        'pay_error_cvv': 'يجب أن يتكون الرمز السري من ٣ أو ٤ أرقام',
        'pay_delete_card_title': 'حذف بطاقة الفيزا',
        'pay_deleted_snack': 'تم حذف بطاقة الفيزا',
        'personal_full_name': 'الاسم الكامل',
        'personal_email_address': 'البريد الإلكتروني',
        'personal_phone_number': 'رقم الهاتف',
        'personal_country': 'الدولة',
        'personal_city': 'المدينة',
        'personal_save_changes': 'حفظ التغييرات',
        'personal_error_name': 'الاسم لا يمكن أن يكون فارغاً',
        'personal_error_email': 'يرجى إدخال بريد إلكتروني صحيح',
        'personal_error_phone': 'يرجى إدخال رقم هاتف صحيح',
        'personal_success_saved': 'تم حفظ التغييرات بنجاح',
        'country_palestine': 'فلسطين',
        'country_germany': 'ألمانيا',
        'country_usa': 'الولايات المتحدة',
        'country_uae': 'الإمارات',
        'menu_home': 'الصفحة الرئيسية',
        'menu_gifts': 'هدايا',
        'menu_olive_oil': 'زيت زيتون فلسطيني',
        'menu_pickled_olives': 'زيتون أخضر مكبوس',
        'menu_cheese': 'جبنة نابلسية',
        'menu_herbs': 'زعتر مخلوط وأعشاب طبية',
        'menu_tahini': 'طحينة فاخرة',
        'menu_hot_sauce': 'شطة فلسطينية',
        'menu_grains': 'فريكة ومفتول',
        'menu_black_seed': 'حبة البركة - قزحة',
        'menu_soap': 'صابون نابلسي',
        'story_who_we_are': 'من نحن',
        'story_who_we_are_desc': 'شركة الأرض للمنتجات الزراعية الفلسطينية هي شركة مبتكرة وديناميكية تقدم مجموعة واسعة من المنتجات الزراعية الفلسطينية عالية الجودة.\nتأسست الشركة في عام ٢٠٠٨، وهي عضو في الجمعية الدولية للتجارة العادلة وتؤمن بقوة بمبادئ الاستثمار الاجتماعي.\nنحن نركز على دعم وتمكين وتشجيع المزارعين الفلسطينيين للاستفادة من الإمكانات الزراعية الغنية لفلسطين.\nنحن نزودهم بالأدوات والتدريب والمعرفة اللازمة لإنتاج منتجات عالية الجودة يمكنها المنافسة في الأسواق العالمية.',
        'story_our_story': 'قصتنا',
        'story_our_story_desc_1': 'تأسست شركة الأرض على يد زياد عنبتاوي لدعم المزارعين الفلسطينيين الفقراء الذين كافحوا لبيع زيت زيتونهم بسعر عادل.\n\nلقد ساعدهم من خلال توفير مرافق حديثة وربطهم بالأسواق الدولية.',
        'story_our_story_desc_2': 'الآن، وبعد مرور أكثر من عشر سنوات، عاد ابنه صبحي إلى فلسطين بعد سفره عبر أوروبا للتعرف على ممارسات الزراعة العضوية والتجارة العادلة. واليوم، تواصل الشركة دعم المزارعين أولاً من خلال الحفاظ على ممارسات تجارية شفافة وأخلاقية مع مساعدة المزارعين في الوصول إلى الأدوات ومرافق التخزين والشهادات المعترف بها دولياً.',
        'story_fair_trade': 'تجارة عادلة',
        'story_palestinian_products': 'منتجات\nفلسطينية',
        'story_supporting_farmers': 'دعم\nالمزارعين',
        'product_best_seller': 'الأكثر مبيعاً',
        'product_ratings_count': '(تقييمات)',
        'product_about': 'عن هذا المنتج',
        'product_quantity': 'الكمية',
        'product_total_price': 'السعر الإجمالي',
        'product_add_more': 'إضافة المزيد',
        'product_add_to_cart': 'أضف إلى السلة',
        'product_added_to_cart': 'تمت إضافتها للسلة',
        'product_desc_oil': 'معصور على البارد من زيتون فلسطيني منتقى يدوياً، يحمل زيت الزيتون البكر الممتاز هذا قروناً من التقاليد. غني بالبوليفينول وبنكهة فاكهية قوية، وهو الرفيق المثالي للطهي والتغميس والتتبيل.',
        'product_desc_herbs': 'مستمدة مباشرة من تلال وجبال فلسطين، يتم تجفيف أعشابنا في الشمس للحفاظ على رائحتها الطبيعية وخصائصها الطبية. يتم اختيار كل دفعة بعناية لتقديم أجود أنواع الجودة لك.',
        'product_desc_olives': 'زيتون فلسطيني معالج تقليدياً، يتم حصاده في ذروة نضجه للحصول على أقصى نكهة. يحمل هذا الزيتون المذاق الأصيل للأرض، والمملح إلى حد الكمال باستخدام طرق عريقة.',
        'product_desc_default': 'تم الحصول عليه بعناية من المزارعين والحرفيين الفلسطينيين، يعكس هذا المنتج التزامنا بالجودة والأصالة ودعم المجتمعات المحلية. كل عملية شراء تساعد في استدامة التراث وسبل عيش العائلات الفلسطينية.',
        'step_cart': 'السلة',
        'step_shipping': 'الشحن',
        'step_payment': 'الدفع',
        'step_review': 'المراجعة',
        // Checkout Titles & Buttons
        'checkout_shipping': 'الشحن',
        'checkout_payment': 'الدفع',
        'checkout_review': 'المراجعة',
        'checkout_continue_payment': 'المتابعة للدفع',
        'checkout_continue_review': 'المتابعة للمراجعة',
        'checkout_place_order': 'إتمام الطلب',
        'checkout_order_summary': 'ملخص الطلب',
        'checkout_subtotal': 'المجموع الفرعي',
        'checkout_shipping_fee': 'الشحن',
        'checkout_vat': 'الضريبة',
        'checkout_total': 'الإجمالي',
        'checkout_delivery_method': 'طريقة التوصيل',
        'checkout_billing_address': 'عنوان الفاتورة',
        'checkout_delivering_to': 'التوصيل إلى',
        'checkout_change_location': 'تغيير الموقع',
        'checkout_authentic': 'أصلي ١٠٠٪',
        'checkout_secure_shipping': 'شحن عالمي آمن',
        'checkout_sustainable': 'تغليف مستدام',
        // Recipe Details
        'recipe_details_title': 'تفاصيل الوصفة',
        // Recipe Data
        'recipe_1_title': 'غمسة زيت الزيتون والزعتر',
        'recipe_1_desc': 'غمسة سريعة على الطريقة الفلسطينية مصنوعة من زيت الزيتون البكر الممتاز والزعتر. إنها بسيطة وأصيلة ومثالية مع الخبز الطازج.',
        'recipe_1_ing_1': '٤ ملاعق كبيرة زيت زيتون الأرض بكر ممتاز',
        'recipe_1_ing_2': 'ملعقتان كبيرتان زعتر فلسطيني',
        'recipe_1_ing_3': 'خبز طازج للتقديم',
        'recipe_1_ing_4': 'اختياري: سمسم',
        'recipe_1_step_1': 'صب زيت الزيتون في وعاء تقديم ضحل.',
        'recipe_1_step_2': 'أضف الزعتر في الأعلى واخلطه قليلاً.',
        'recipe_1_step_3': 'قدمه فوراً مع الخبز الطازج.',
        'addr_save': 'حفظ هذا العنوان',
        // Recipes 2, 3, 4
        'recipe_2_title': 'سلطة السماق الفلسطينية',
        'recipe_2_desc': 'سلطة فلسطينية طازجة مع خضروات مقطعة وأعشاب وزيت زيتون وسماق لنكهة منعشة ومميزة.',
        'recipe_2_ing_1': 'حبتان خيار مقطعتان',
        'recipe_2_ing_2': 'حبتان بندورة مقطعتان',
        'recipe_2_ing_3': 'بقدونس طازج',
        'recipe_2_ing_4': 'ملعقتان كبيرتان زيت زيتون الأرض',
        'recipe_2_ing_5': 'ملعقة صغيرة سماق فلسطيني',
        'recipe_2_step_1': 'قطع جميع الخضروات وضعها في وعاء.',
        'recipe_2_step_2': 'أضف البقدونس والملح والسماق.',
        'recipe_2_step_3': 'رش زيت الزيتون فوق السلطة.',
        'recipe_2_step_4': 'اخلط جيداً وقدمها طازجة.',

        'recipe_3_title': 'بيض بالزعتر للفطور',
        'recipe_3_desc': 'وصفة فطور دافئة باستخدام البيض وزيت الزيتون والزعتر لطبق صباحي فلسطيني بسيط.',
        'recipe_3_ing_1': 'بيضتان',
        'recipe_3_ing_2': 'ملعقة كبيرة زيت زيتون الأرض',
        'recipe_3_ing_3': 'ملعقة صغيرة زعتر فلسطيني',
        'recipe_3_ing_4': 'ملح وفلفل',
        'recipe_3_step_1': 'سخن زيت الزيتون في مقلاة صغيرة.',
        'recipe_3_step_2': 'أضف البيض واطبخه برفق.',
        'recipe_3_step_3': 'رش الزعتر والملح والفلفل.',
        'recipe_3_step_4': 'قدمه ساخناً مع الخبز.',

        'recipe_4_title': 'دجاج مشوي بالزعتر',
        'recipe_4_desc': 'وصفة دجاج مشوي غنية بنكهة زيت الزيتون والزعتر والليمون والأعشاب.',
        'recipe_4_ing_1': 'قطع دجاج',
        'recipe_4_ing_2': '٣ ملاعق كبيرة زيت زيتون الأرض',
        'recipe_4_ing_3': 'ملعقتان كبيرتان زعتر فلسطيني',
        'recipe_4_ing_4': 'عصير ليمون',
        'recipe_4_step_1': 'اخلط زيت الزيتون والزعتر وعصير الليمون والملح والفلفل.',
        'recipe_4_step_2': 'ادهن الدجاج جيداً بالخليط.',
        'recipe_4_step_3': 'ضعه في صينية الخبز مع البطاطس.',
        'recipe_4_step_4': 'اخبزه حتى ينضج ويصبح ذهبياً.',
        // Categories
        'All': 'الكل',
        'Olive Oil': 'زيت زيتون',
        'Herbs & Spices': 'أعشاب وتوابل',
        'Pickles': 'مخللات',
        'Dairy': 'ألبان',
        'Grains': 'حبوب',
        'Tahini & Halawa': 'طحينة وحلاوة',
        'Snacks': 'مسليات',
        'Gift Boxes': 'صناديق هدايا',
        'Organic': 'عضوي',
        'Zaatar': 'زعتر',
        'home_palestinian_breakfast': 'فطور فلسطيني',
        'home_olive_oil_dip': 'تغميسة زيت زيتون',
        'home_100_percent': '١٠٠٪',
        'home_natural': 'طبيعي',
        'home_premium': 'فاخر',
        'home_olive_oil_tag': 'زيت زيتون',
        'product_short_olives_220g': '٢٢٠ غم زيتون\\nأخضر بلدي',
        'prod_name_oil_1l': 'زيت زيتون بكر',
        'prod_sub_oil_1l': '١ لتر عبوة بلاستيكية',
        'prod_name_zaatar_1kg': 'زعتر فلسطيني',
        'prod_sub_zaatar_1kg': '١ كيلو خلطة فاخرة',
        'prod_name_sage_100g': 'مرمية مجففة',
        'prod_sub_sage_100g': '١٠٠ غم مرمية جبلية',
        'prod_name_olives_220g': 'زيتون أخضر',
        'prod_sub_olives_220g': '٢٢٠ غم زيتون بلدي',
        // Register Screen
        'register_title': 'إنشاء حساب جديد',
        'register_subtitle': 'انضم إلى عائلة الأرض اليوم',
        'register_name': 'الاسم الكامل',
        'register_email': 'البريد الإلكتروني',
        'register_password': 'كلمة المرور',
        'register_confirm_password': 'تأكيد كلمة المرور',
        'register_button': 'إنشاء حساب',
        'register_fill_fields': 'يرجى ملء جميع الحقول',
        'register_password_mismatch': 'كلمات المرور غير متطابقة',
        'register_already_have': 'لديك حساب بالفعل؟ سجل الدخول',
        // Recipes Screen
        'recipes_title': 'وصفات باستخدام منتجات الأرض',
        'recipes_search_hint': 'ابحث عن الوصفات...',
        'recipes_view_button': 'عرض الوصفة',
        'recipes_ingredients': 'المكونات',
        'recipes_steps': 'الخطوات',
        'recipes_no_results': 'لم يتم العثور على وصفات',
        'recipes_try_items': 'جرب زيت الزيتون، الزعتر، السماق، الطحينة، أو الفريكة.',
        'recipe_cat_all': 'الكل',
        'recipe_cat_olive_oil': 'زيت زيتون',
        'recipe_cat_zaatar': 'زعتر',
        'recipe_cat_sumac': 'سماق',
        'recipe_cat_tahini': 'طحينة',
        'recipe_cat_freekeh': 'فريكة',
        'recipe_cat_maftoul': 'مفتول',
        'recipe_cat_black_seed': 'حبة البركة',
        // Profile Screen
        'profile_shipping_addresses': 'عناوين الشحن',
        'profile_order_history': 'سجل الطلبات',
        'profile_favorites': 'مفضلاتي',
        'profile_payment_methods': 'طرق الدفع',
        'profile_notifications': 'التنبيهات',
        'profile_help_support': 'المساعدة والدعم',
        'profile_personal_details': 'البيانات الشخصية',
        'profile_logout': 'تسجيل الخروج',
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
      name: 'prod_name_oil_1l',
      subtitle: 'prod_sub_oil_1l',
      price: 15,
      rating: 4.9,
      category: 'Olive Oil',
      image: 'assets/virgin_oil.png',
      isBestSeller: true,
    ),
    Product(
      id: 'zaatar-1kg',
      name: 'prod_name_zaatar_1kg',
      subtitle: 'prod_sub_zaatar_1kg',
      price: 10,
      rating: 4.8,
      category: 'Herbs & Spices',
      image: 'assets/Zaata.png',
    ),
    Product(
      id: 'dried-sage-100g',
      name: 'prod_name_sage_100g',
      subtitle: 'prod_sub_sage_100g',
      price: 4,
      rating: 4.7,
      category: 'Herbs & Spices',
      image: 'assets/Dried_sage.png',
    ),
    Product(
      id: 'green-olives-220g',
      name: 'prod_name_olives_220g',
      subtitle: 'prod_sub_olives_220g',
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
      title: 'addr_home',
      details: 'Nablus, Palestine\nStreet 1, Building 2',
      mailboxAddress: 'Home mailbox - near main door',
      isDefault: true,
    ),
    const ShippingAddress(
      id: 'work',
      title: 'addr_work',
      details: 'Ramallah, Palestine\nMain Street, Office 5',
      mailboxAddress: 'Office reception mailbox',
    ),
  ];

  final List<PaymentMethod> _paymentMethods = [
    const PaymentMethod(
      id: 'cash',
      title: 'pay_cod',
      subtitle: 'pay_cod_desc',
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
        title: '${t('pay_visa')} **** $last4',
        subtitle: '${t('pay_expires')} $expiryMonth/$expiryYear',
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
      title: '${t('pay_visa')} **** $last4',
      subtitle: '${t('pay_expires')} $expiryMonth/$expiryYear',
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