import 'package:flutter/material.dart';

import '../../state/app_state_scope.dart';
import '../../theme/app_colors.dart';
import '../../widgets/feedback_card.dart';
import '../checkout/cart_screen.dart';

/// Full feedback screen with add-feedback form and community reviews list.
/// Estimated lines: ~290
class FeedbackScreen extends StatefulWidget {
  final VoidCallback? onGoHome;
  const FeedbackScreen({super.key, this.onGoHome});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _commentController = TextEditingController();
  int _selectedStars = 5;
  String _selectedCountry = 'Palestine';
  String _filterCountry = 'All';

  static const List<Map<String, String>> _countries = [
    {'name': 'Palestine', 'flag': '🇵🇸'},
    {'name': 'Germany', 'flag': '🇩🇪'},
    {'name': 'United Kingdom', 'flag': '🇬🇧'},
    {'name': 'United States', 'flag': '🇺🇸'},
    {'name': 'United Arab Emirates', 'flag': '🇦🇪'},
    {'name': 'Saudi Arabia', 'flag': '🇸🇦'},
    {'name': 'France', 'flag': '🇫🇷'},
    {'name': 'Canada', 'flag': '🇨🇦'},
  ];

  final List<FeedbackItem> _feedbacks = const [
    FeedbackItem(flag: '🇬🇧', name: 'Louis', country: 'United Kingdom',
        text: 'The gift set is perfect for any special occasion.', stars: 5),
    FeedbackItem(flag: '🇩🇪', name: 'Jasmin', country: 'Germany',
        text: "The Za'atar is incredibly aromatic and tasty.", stars: 5),
    FeedbackItem(flag: '🇵🇸', name: 'Sarah', country: 'Palestine',
        text: 'Amazing products!', stars: 5),
    FeedbackItem(flag: '🇺🇸', name: 'Ahmed', country: 'United States',
        text: 'Rich flavor and authentic Palestinian quality.', stars: 5),
    FeedbackItem(flag: '🇦🇪', name: 'Lina', country: 'UAE',
        text: 'Fast delivery and the olive oil quality is excellent.', stars: 5),
    FeedbackItem(flag: '🇸🇦', name: 'Omar', country: 'Saudi Arabia',
        text: 'The products feel authentic and very premium.', stars: 5),
    FeedbackItem(flag: '🇫🇷', name: 'Marie', country: 'France',
        text: 'Loved the soap and the packaging was beautiful.', stars: 4),
    FeedbackItem(flag: '🇨🇦', name: 'Adam', country: 'Canada',
        text: 'Great service and excellent Palestinian flavors.', stars: 5),
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _goBack() {
    if (widget.onGoHome != null) {
      widget.onGoHome!();
    } else if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  String _flagForCountry(String country) {
    final lower = country.toLowerCase();
    if (lower.contains('palestine')) return '🇵🇸';
    if (lower.contains('germany')) return '🇩🇪';
    if (lower.contains('united states') || lower.contains('usa')) return '🇺🇸';
    if (lower.contains('united kingdom') || lower.contains('uk')) return '🇬🇧';
    if (lower.contains('emirates') || lower.contains('uae')) return '🇦🇪';
    if (lower.contains('saudi') || lower.contains('ksa')) return '🇸🇦';
    if (lower.contains('france')) return '🇫🇷';
    if (lower.contains('canada')) return '🇨🇦';
    return '🌍';
  }

  void _addFeedback() {
    final state = AppStateScope.of(context);
    final comment = _commentController.text.trim();
    if (comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.t('feedback_write_hint')),
              duration: const Duration(seconds: 1)));
      return;
    }
    final user = state.currentUser;
    final name = (user != null && user.name.trim().isNotEmpty)
        ? user.name.trim()
        : state.t('customer');

    setState(() {
      _feedbacks.insert(0, FeedbackItem(
        flag: _flagForCountry(_selectedCountry),
        name: name,
        country: _selectedCountry,
        text: comment,
        stars: _selectedStars,
      ));
      _commentController.clear();
      _selectedStars = 5;
      _selectedCountry = 'Palestine';
    });

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.t('feedback_success')),
            duration: const Duration(seconds: 1)));
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final user = state.currentUser;
    final profileName = (user != null && user.name.trim().isNotEmpty)
        ? user.name.trim()
        : state.t('customer');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 22),
                children: [
                  _addFeedbackBox(profileName, state),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          state.t('feedback_customer_feedback'),
                          style: const TextStyle(
                            color: AppColors.olive,
                            fontSize: 20,
                            fontFamily: 'serif',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      DropdownButton<String>(
                        value: _filterCountry,
                        icon: const Icon(Icons.filter_list, color: AppColors.olive),
                        underline: const SizedBox(),
                        style: const TextStyle(
                            color: AppColors.olive,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                        dropdownColor: AppColors.cream,
                        items: [
                          DropdownMenuItem(
                              value: 'All',
                              child: Text(state.t('feedback_all_countries'))),
                          ..._countries.map((c) => DropdownMenuItem(
                                value: c['name'],
                                child: Text('${c['flag']} ${c['name']}'),
                              )),
                        ],
                        onChanged: (v) {
                          if (v != null) setState(() => _filterCountry = v);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._feedbacks
                      .where((f) =>
                          _filterCountry == 'All' ||
                          f.country
                              .toLowerCase()
                              .contains(_filterCountry.toLowerCase()) ||
                          (f.country == 'UAE' &&
                              _filterCountry == 'United Arab Emirates'))
                      .map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: FeedbackCard(
                              flag: item.flag,
                              name: item.name,
                              country: item.country,
                              text: item.text,
                              stars: item.stars,
                            ),
                          )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;
      final h = (w * 0.16).clamp(56.0, 70.0);
      final s = (w * 0.11).clamp(38.0, 46.0);
      return Container(
        height: h,
        color: AppColors.cream,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Image.asset('assets/321.png', height: 38,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const Text("AL'ARD",
                      style: TextStyle(
                          color: AppColors.olive,
                          fontSize: 20,
                          fontWeight: FontWeight.bold))),
            ),
            PositionedDirectional(
              start: 6,
              child: IconButton(
                onPressed: _goBack,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints.tightFor(width: s, height: s),
                icon: Icon(Icons.adaptive.arrow_back, color: Colors.black, size: 30),
              ),
            ),
            PositionedDirectional(
              end: 6,
              child: IconButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const CartScreen())),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints.tightFor(width: s, height: s),
                icon: const Icon(Icons.shopping_cart_outlined,
                    color: Colors.black, size: 28),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _addFeedbackBox(String profileName, dynamic state) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: AppColors.olive.withValues(alpha: 0.35), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(state.t('feedback_add_title'),
              style: const TextStyle(
                  color: AppColors.olive,
                  fontSize: 18,
                  fontFamily: 'serif',
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          // Profile name row
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: AppColors.checkoutBorder, width: 0.9),
            ),
            child: Row(
              children: [
                const Icon(Icons.person_outline, color: AppColors.olive, size: 20),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(profileName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: AppColors.olive, fontWeight: FontWeight.w600))),
                Text(state.t('feedback_from_profile'),
                    style: const TextStyle(color: Colors.black45, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Country dropdown
          SizedBox(
            height: 46,
            child: DropdownButtonFormField<String>(
              initialValue: _selectedCountry,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.olive),
              dropdownColor: AppColors.cream,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: const BorderSide(color: AppColors.checkoutBorder, width: 0.9)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: const BorderSide(color: AppColors.checkoutBorder, width: 1.2)),
              ),
              items: _countries.map((c) => DropdownMenuItem<String>(
                    value: c['name'],
                    child: Row(children: [
                      Text(c['flag']!, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(c['name']!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: AppColors.olive, fontSize: 14))),
                    ]),
                  )).toList(),
              onChanged: (v) { if (v != null) setState(() => _selectedCountry = v); },
            ),
          ),
          const SizedBox(height: 10),
          // Comment field
          TextField(
            controller: _commentController,
            maxLines: 3,
            style: const TextStyle(color: AppColors.olive, fontSize: 14),
            decoration: InputDecoration(
              hintText: state.t('feedback_write_hint'),
              hintStyle: TextStyle(color: AppColors.olive.withValues(alpha: 0.65), fontSize: 14),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                  borderSide: const BorderSide(color: AppColors.checkoutBorder, width: 0.9)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                  borderSide: const BorderSide(color: AppColors.checkoutBorder, width: 1.2)),
            ),
          ),
          const SizedBox(height: 10),
          // Stars + submit
          Row(
            children: [
              Text(state.t('feedback_rating_label'),
                  style: const TextStyle(color: AppColors.olive, fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              ...List.generate(5, (i) {
                final n = i + 1;
                return InkWell(
                  onTap: () => setState(() => _selectedStars = n),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: Icon(
                        n <= _selectedStars ? Icons.star : Icons.star_border,
                        color: AppColors.gold, size: 23),
                  ),
                );
              }),
              const Spacer(),
              SizedBox(
                height: 32,
                width: 118,
                child: ElevatedButton(
                  onPressed: _addFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.olive,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(state.t('feedback_add_button'),
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
