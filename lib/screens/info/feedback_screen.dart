import 'package:flutter/material.dart';

import '../../state/app_state_scope.dart';
import '../checkout/cart_screen.dart';

class FeedbackScreen extends StatefulWidget {
  final VoidCallback? onGoHome;

  const FeedbackScreen({
    super.key,
    this.onGoHome,
  });

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  static const Color _background = Color(0xFFF7F3EE);
  static const Color _cream = Color(0xFFF2EDE6);
  static const Color _olive = Color(0xFF55682A);
  static const Color _border = Color(0xFF6B7A35);
  static const Color _gold = Color(0xFFE0A323);

  final TextEditingController _commentController = TextEditingController();

  int _selectedStars = 5;
  String _selectedCountry = 'Palestine';
  String _filterCountry = 'All';

  final List<Map<String, String>> _countries = const [
    {'name': 'Palestine', 'flag': '🇵🇸'},
    {'name': 'Germany', 'flag': '🇩🇪'},
    {'name': 'United Kingdom', 'flag': '🇬🇧'},
    {'name': 'United States', 'flag': '🇺🇸'},
    {'name': 'United Arab Emirates', 'flag': '🇦🇪'},
    {'name': 'Saudi Arabia', 'flag': '🇸🇦'},
    {'name': 'France', 'flag': '🇫🇷'},
    {'name': 'Canada', 'flag': '🇨🇦'},
  ];

  final List<_FeedbackItem> _feedbacks = [
    const _FeedbackItem(
      flag: '🇬🇧',
      name: 'Louis',
      country: 'United Kingdom',
      text: 'The gift set is perfect for any special occasion.',
      stars: 5,
    ),
    const _FeedbackItem(
      flag: '🇩🇪',
      name: 'Jasmin',
      country: 'Germany',
      text: 'The Za’atar is incredibly aromatic and tasty.',
      stars: 5,
    ),
    const _FeedbackItem(
      flag: '🇵🇸',
      name: 'Sarah',
      country: 'Palestine',
      text: 'Amazing products!',
      stars: 5,
    ),
    const _FeedbackItem(
      flag: '🇺🇸',
      name: 'Ahmed',
      country: 'United States',
      text: 'Rich flavor and authentic Palestinian quality.',
      stars: 5,
    ),
    const _FeedbackItem(
      flag: '🇦🇪',
      name: 'Lina',
      country: 'UAE',
      text: 'Fast delivery and the olive oil quality is excellent.',
      stars: 5,
    ),
    const _FeedbackItem(
      flag: '🇸🇦',
      name: 'Omar',
      country: 'Saudi Arabia',
      text: 'The products feel authentic and very premium.',
      stars: 5,
    ),
    const _FeedbackItem(
      flag: '🇫🇷',
      name: 'Marie',
      country: 'France',
      text: 'Loved the soap and the packaging was beautiful.',
      stars: 4,
    ),
    const _FeedbackItem(
      flag: '🇨🇦',
      name: 'Adam',
      country: 'Canada',
      text: 'Great service and excellent Palestinian flavors.',
      stars: 5,
    ),
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _goBackToHome() {
    if (widget.onGoHome != null) {
      widget.onGoHome!();
      return;
    }

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  String _profileName(BuildContext context) {
    final state = AppStateScope.of(context);
    final user = state.currentUser;

    if (user != null && user.name.trim().isNotEmpty) {
      return user.name.trim();
    }

    return state.t('customer');
  }

  void _openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CartScreen(),
      ),
    );
  }

  void _addFeedback() {
    final profileName = _profileName(context);
    final comment = _commentController.text.trim();

    if (comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStateScope.of(context).t('feedback_write_hint')),
          duration: const Duration(seconds: 1),
        ),
      );
      return;
    }

    setState(() {
      _feedbacks.insert(
        0,
        _FeedbackItem(
          flag: _flagForCountry(_selectedCountry),
          name: profileName,
          country: _selectedCountry,
          text: comment,
          stars: _selectedStars,
        ),
      );

      _commentController.clear();
      _selectedStars = 5;
      _selectedCountry = 'Palestine';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStateScope.of(context).t('feedback_success')),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final profileName = _profileName(context);

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, pageConstraints) {
            final pageWidth = pageConstraints.maxWidth;
            final contentWidth = pageWidth > 430 ? 430.0 : pageWidth;
            final horizontalPadding = contentWidth < 360 ? 10.0 : 14.0;

            return Center(
              child: SizedBox(
                width: contentWidth,
                child: Column(
                  children: [
                    _buildTopBar(context),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          14,
                          horizontalPadding,
                          22,
                        ),
                        children: [
                          _addFeedbackBox(
                            contentWidth: contentWidth,
                            profileName: profileName,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  state.t('feedback_customer_feedback'),
                                  style: const TextStyle(
                                    color: _olive,
                                    fontSize: 20,
                                    fontFamily: 'serif',
                                    fontWeight: FontWeight.w700,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black26,
                                        blurRadius: 3,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              DropdownButton<String>(
                                value: _filterCountry,
                                icon: const Icon(Icons.filter_list, color: _olive),
                                underline: const SizedBox(),
                                style: const TextStyle(color: _olive, fontWeight: FontWeight.bold, fontSize: 13),
                                dropdownColor: _cream,
                                items: [
                                  DropdownMenuItem(value: 'All', child: Text(state.t('feedback_all_countries'))),
                                  ..._countries.map((c) => DropdownMenuItem(
                                        value: c['name'],
                                        child: Text('${c['flag']} ${c['name']}'),
                                      )),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _filterCountry = value;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ..._feedbacks.where((f) => _filterCountry == 'All' || f.country.toLowerCase().contains(_filterCountry.toLowerCase()) || (f.country == 'UAE' && _filterCountry == 'United Arab Emirates')).map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _BigFeedbackCard(
                                flag: item.flag,
                                name: item.name,
                                country: item.country,
                                text: item.text,
                                stars: item.stars,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final barHeight = (width * 0.16).clamp(56.0, 70.0);
        final buttonSize = (width * 0.11).clamp(38.0, 46.0);

        return Container(
          height: barHeight,
          width: double.infinity,
          color: _cream,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/321.png',
                  height: 38,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) {
                    return const Text(
                      "AL'ARD",
                      style: TextStyle(
                        color: _olive,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              PositionedDirectional(
                start: 6,
                child: IconButton(
                  onPressed: _goBackToHome,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tightFor(
                    width: buttonSize,
                    height: buttonSize,
                  ),
                  icon: Icon(
                    Icons.adaptive.arrow_back,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
              PositionedDirectional(
                end: 6,
                child: IconButton(
                  onPressed: _openCart,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tightFor(
                    width: buttonSize,
                    height: buttonSize,
                  ),
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _addFeedbackBox({
    required double contentWidth,
    required String profileName,
  }) {
    final isSmall = contentWidth < 360;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        isSmall ? 10 : 12,
        12,
        isSmall ? 10 : 12,
        14,
      ),
      decoration: BoxDecoration(
        color: _cream,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _olive.withValues(alpha: 0.35),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStateScope.of(context).t('feedback_add_title'),
            style: const TextStyle(
              color: _olive,
              fontSize: 18,
              fontFamily: 'serif',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          _profileNameBox(profileName),
          const SizedBox(height: 10),
          _countryDropdownField(),
          const SizedBox(height: 10),
          _field(
            controller: _commentController,
            hint: AppStateScope.of(context).t('feedback_write_hint'),
            maxLines: 3,
          ),
          const SizedBox(height: 10),
          _ratingAndAddButton(isSmall: isSmall),
        ],
      ),
    );
  }

  Widget _profileNameBox(String profileName) {
    return Container(
      height: 46,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: _border,
          width: 0.9,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.person_outline,
            color: _olive,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              profileName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _olive,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            AppStateScope.of(context).t('feedback_from_profile'),
            style: const TextStyle(
              color: Colors.black45,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _countryDropdownField() {
    return SizedBox(
      height: 46,
      child: DropdownButtonFormField<String>(
        initialValue: _selectedCountry,
        isExpanded: true,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: _olive,
        ),
        dropdownColor: _cream,
        decoration: InputDecoration(
          filled: true,
          fillColor: _background,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 11,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(
              color: _border,
              width: 0.9,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(
              color: _border,
              width: 1.2,
            ),
          ),
        ),
        items: _countries.map((country) {
          return DropdownMenuItem<String>(
            value: country['name'],
            child: Row(
              children: [
                Text(
                  country['flag']!,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    country['name']!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _olive,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value == null) return;

          setState(() {
            _selectedCountry = value;
          });
        },
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        color: _olive,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: _olive.withValues(alpha: 0.65),
          fontSize: 14,
        ),
        filled: true,
        fillColor: _background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 11,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(
            color: _border,
            width: 0.9,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(
            color: _border,
            width: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _ratingAndAddButton({
    required bool isSmall,
  }) {
    final stars = Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starNumber = index + 1;

        return InkWell(
          onTap: () {
            setState(() {
              _selectedStars = starNumber;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Icon(
              starNumber <= _selectedStars ? Icons.star : Icons.star_border,
              color: _gold,
              size: isSmall ? 21 : 23,
            ),
          ),
        );
      }),
    );

    final addButton = SizedBox(
      height: 32,
      width: isSmall ? 90 : 118,
      child: ElevatedButton(
        onPressed: _addFeedback,
        style: ElevatedButton.styleFrom(
          backgroundColor: _olive,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            AppStateScope.of(context).t('feedback_add_button'),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );

    if (isSmall) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStateScope.of(context).t('feedback_rating_label'),
            style: const TextStyle(
              color: _olive,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              stars,
              const Spacer(),
              addButton,
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Text(
          AppStateScope.of(context).t('feedback_rating_label'),
          style: const TextStyle(
            color: _olive,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        stars,
        const Spacer(),
        addButton,
      ],
    );
  }

  String _flagForCountry(String country) {
    final lower = country.toLowerCase();

    if (lower.contains('palestine')) return '🇵🇸';
    if (lower.contains('germany')) return '🇩🇪';
    if (lower.contains('usa') || lower.contains('united states')) return '🇺🇸';
    if (lower.contains('uk') || lower.contains('kingdom')) return '🇬🇧';
    if (lower.contains('uae') || lower.contains('emirates')) return '🇦🇪';
    if (lower.contains('saudi') || lower.contains('ksa')) return '🇸🇦';
    if (lower.contains('france')) return '🇫🇷';
    if (lower.contains('canada')) return '🇨🇦';

    return '🌍';
  }
}

class _FeedbackItem {
  final String flag;
  final String name;
  final String country;
  final String text;
  final int stars;

  const _FeedbackItem({
    required this.flag,
    required this.name,
    required this.country,
    required this.text,
    required this.stars,
  });
}

class _BigFeedbackCard extends StatelessWidget {
  final String flag;
  final String name;
  final String country;
  final String text;
  final int stars;

  const _BigFeedbackCard({
    required this.flag,
    required this.name,
    required this.country,
    required this.text,
    required this.stars,
  });

  static const Color _olive = Color(0xFF55682A);
  static const Color _gold = Color(0xFFE0A323);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final nameFont = width < 340 ? 15.0 : 17.0;
        final textFont = width < 340 ? 12.5 : 13.5;
        final countryFont = width < 340 ? 10.0 : 11.0;
        final flagFont = width < 340 ? 21.0 : 24.0;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            width < 340 ? 11 : 14,
            12,
            width < 340 ? 11 : 14,
            12,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    flag,
                    style: TextStyle(fontSize: flagFont),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _olive,
                        fontSize: nameFont,
                        fontFamily: 'serif',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      country,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: countryFont,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                '★' * stars,
                style: const TextStyle(
                  color: _gold,
                  fontSize: 15,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                text,
                style: TextStyle(
                  color: _olive,
                  fontSize: textFont,
                  height: 1.35,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
