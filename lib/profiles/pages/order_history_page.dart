import 'package:flutter/material.dart';

import 'notifications_page.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  static const Color _background = Color(0xFFF7F3EE);
  static const Color _cream = Color(0xFFF2EDE6);
  static const Color _card = Color(0xFFF0E6DC);
  static const Color _olive = Color(0xFF55682A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      bottomNavigationBar: const _ProfileBottomNav(currentIndex: 4),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                child: Column(
                  children: [
                    _searchBox(),
                    const SizedBox(height: 28),
                    _orderCard(),
                    const SizedBox(height: 24),
                    _trackingUpdates(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Container(
      height: 84,
      color: _cream,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(
              width: 44,
              height: 44,
            ),
            icon: const Icon(
              Icons.menu_rounded,
              color: Colors.black,
              size: 38,
            ),
          ),
          const Spacer(),
          Image.asset(
            'assets/alard_icon.png',
            height: 62,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) {
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
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationsPage(),
                ),
              );
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(
              width: 44,
              height: 44,
            ),
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.black,
              size: 34,
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBox() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 42,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(18),
              ),
            ),
            child: const TextField(
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Colors.black,
                  size: 28,
                ),
                hintText: 'Enter your tracking number',
                hintStyle: TextStyle(
                  color: Colors.black26,
                  fontSize: 12,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        Container(
          height: 42,
          width: 62,
          decoration: const BoxDecoration(
            color: _olive,
            borderRadius: BorderRadius.horizontal(
              right: Radius.circular(18),
            ),
          ),
          child: const Icon(
            Icons.arrow_forward_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),
      ],
    );
  }

  Widget _orderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order #15321890',
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(
                child: SizedBox(
                  height: 88,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 13,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Est.Delivery:Aprile 27,2026',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'EXTRA VIRGIN OLIVE OIL',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '🇩🇪',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'shipping to Germany',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _productBox(),
            ],
          ),
          const SizedBox(height: 12),
          _progressLine(),
        ],
      ),
    );
  }

  Widget _productBox() {
    return Container(
      width: 62,
      height: 76,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(3),
      ),
      child: const Center(
        child: Text(
          "AL'ARD\nOLIVE\nOIL",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFD54A3B),
            fontSize: 9,
            fontWeight: FontWeight.w900,
            height: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _progressLine() {
    final steps = [
      'Order\nPlaced',
      'Order\nProcessed',
      'Shipped',
      'Out for\nDelivery',
    ];

    return Column(
      children: [
        Row(
          children: List.generate(steps.length, (index) {
            return Expanded(
              child: Row(
                children: [
                  Container(
                    height: 23,
                    width: 23,
                    decoration: const BoxDecoration(
                      color: _olive,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                  if (index != steps.length - 1)
                    Expanded(
                      child: Container(
                        height: 3,
                        color: _olive,
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Row(
          children: steps
              .map(
                (step) => Expanded(
                  child: Text(
                    step,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 7,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _trackingUpdates() {
    final updates = [
      _TrackingUpdate(
        title: 'Out for Delivery - Arriving Today',
        subtitle: '🇩🇪 Berlin, Germany',
      ),
      _TrackingUpdate(
        title: 'Shipped',
        subtitle: 'Apr 26, 2026 PM',
      ),
      _TrackingUpdate(
        title: 'Order Processed',
        subtitle: 'Apr 26, 10:00 AM',
      ),
      _TrackingUpdate(
        title: 'Order placed',
        subtitle: 'Apr 25, 9:31 PM',
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(13, 12, 13, 18),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Tracking Updates',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 34,
                color: Colors.black,
              ),
            ],
          ),
          const Divider(
            color: Colors.black45,
            height: 10,
            thickness: 1,
          ),
          const SizedBox(height: 8),
          ...List.generate(updates.length, (index) {
            final update = updates[index];

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      height: 18,
                      width: 18,
                      decoration: const BoxDecoration(
                        color: _olive,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                    if (index != updates.length - 1)
                      Container(
                        width: 2,
                        height: 35,
                        color: _olive.withOpacity(0.45),
                      ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          update.title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          update.subtitle,
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _TrackingUpdate {
  final String title;
  final String subtitle;

  const _TrackingUpdate({
    required this.title,
    required this.subtitle,
  });
}

class _ProfileBottomNav extends StatelessWidget {
  final int currentIndex;

  const _ProfileBottomNav({
    required this.currentIndex,
  });

  static const Color _cream = Color(0xFFF2EDE6);
  static const Color _olive = Color(0xFF55682A);

  @override
  Widget build(BuildContext context) {
    final items = [
      _BottomItem(Icons.home_outlined, 'Home'),
      _BottomItem(Icons.shopping_bag_outlined, 'Shop'),
      _BottomItem(Icons.receipt_long_outlined, 'Recipes', circular: true),
      _BottomItem(Icons.feedback_outlined, 'Feedback'),
      _BottomItem(Icons.person_outline, 'Profile'),
    ];

    return Container(
      height: 74,
      color: _cream,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final active = currentIndex == index;

          return InkWell(
            onTap: () {
              if (index == 4) Navigator.pop(context);
            },
            child: SizedBox(
              width: 58,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: item.circular ? 33 : 30,
                    width: item.circular ? 33 : 30,
                    decoration: item.circular
                        ? BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: active ? _olive : Colors.black,
                              width: 1.4,
                            ),
                          )
                        : null,
                    child: Icon(
                      item.icon,
                      size: item.circular ? 22 : 28,
                      color: active ? _olive : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: active ? _olive : Colors.black,
                      fontSize: 12,
                      fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _BottomItem {
  final IconData icon;
  final String label;
  final bool circular;

  const _BottomItem(
    this.icon,
    this.label, {
    this.circular = false,
  });
}