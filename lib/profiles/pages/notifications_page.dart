import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

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
                padding: const EdgeInsets.fromLTRB(30, 6, 30, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 28),
                    const _NotificationCard(
                      title: 'Your Order Is On The Way',
                      subtitle: '#12345 will arrive today',
                      time: '3 min ago',
                    ),
                    const SizedBox(height: 22),
                    _sectionLabel('Today'),
                    const SizedBox(height: 10),
                    const _NotificationCard(
                      title: 'Order Confirmed',
                      subtitle: 'Your order #12345 has been confirmed',
                      time: '30 min ago',
                    ),
                    const SizedBox(height: 20),
                    _sectionLabel('Yesterday'),
                    const SizedBox(height: 10),
                    const _NotificationCard(
                      title: 'Special Offer!',
                      subtitle: 'Get 20% off on our premium olive oil',
                      time: '8 hours ago',
                    ),
                    const SizedBox(height: 20),
                    _sectionLabel('Yesterday'),
                    const SizedBox(height: 10),
                    _NotificationCard(
                      title: 'Order Delivered',
                      subtitle: 'Your order #12344 has been delivered',
                      time: 'Yesterday',
                      leading: Container(
                        height: 38,
                        width: 38,
                        decoration: const BoxDecoration(
                          color: _olive,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const _NotificationCard(
                      title: 'Order Canceled',
                      subtitle: 'Your order #12343 has been canceled',
                      time: 'Yesterday',
                      leading: Icon(
                        Icons.close_rounded,
                        color: Colors.black,
                        size: 48,
                      ),
                    ),
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
      height: 78,
      color: _cream,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(
                width: 44,
                height: 44,
              ),
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.black,
                size: 34,
              ),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/alard_icon.png',
              height: 62,
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
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final Widget? leading;

  const _NotificationCard({
    required this.title,
    required this.subtitle,
    required this.time,
    this.leading,
  });

  static const Color _card = NotificationsPage._card;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Align(
            alignment: Alignment.topRight,
            child: Text(
              time,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
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