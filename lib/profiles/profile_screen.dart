import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color _background = Color(0xFFF7F3EE);
  static const Color _cream = Color(0xFFF2EDE6);
  static const Color _rowColor = Color(0xFFF0E6DC);
  static const Color _olive = Color(0xFF55682A);
  static const Color _darkBlue = Color(0xFF0E1A39);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 22),
                child: Column(
                  children: [
                    _buildHeroImage(),
                    const SizedBox(height: 10),
                    _buildProfileInfo(),
                    const SizedBox(height: 16),
                    _buildMenuList(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: _cream,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Menu will open here'),
                  duration: Duration(milliseconds: 900),
                ),
              );
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(
              width: 44,
              height: 44,
            ),
            icon: const Icon(
              Icons.menu_rounded,
              size: 38,
              color: _darkBlue,
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
                  fontSize: 21,
                  color: _olive,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              _openSimplePage(
                context,
                title: 'Notifications',
                icon: Icons.notifications_none_rounded,
              );
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(
              width: 44,
              height: 44,
            ),
            icon: const Icon(
              Icons.notifications_none_rounded,
              size: 34,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return SizedBox(
      width: double.infinity,
      height: 136,
      child: Image.asset(
        'assets/photo2.png',
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            color: const Color(0xFFD8CDBE),
            alignment: Alignment.center,
            child: const Icon(
              Icons.landscape_outlined,
              size: 50,
              color: _olive,
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      children: [
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color: _background,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black,
              width: 4,
            ),
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            size: 39,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Mohammed',
          style: TextStyle(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Mohammed@gmail.com',
          style: TextStyle(
            color: Colors.black45,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Palestine',
          style: TextStyle(
            color: Colors.black45,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.phone_outlined,
              size: 12,
              color: Colors.black38,
            ),
            SizedBox(width: 5),
            Text(
              '+970 23456789',
              style: TextStyle(
                color: Colors.black38,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuList(BuildContext context) {
    final items = [
      _ProfileMenuItem(
        title: 'Personal Details',
        icon: Icons.person,
      ),
      _ProfileMenuItem(
        title: 'Shipping Addresses',
        icon: Icons.location_on,
      ),
      _ProfileMenuItem(
        title: 'Order History',
        icon: Icons.receipt_long,
      ),
      _ProfileMenuItem(
        title: 'My Favorites',
        icon: Icons.favorite,
      ),
      _ProfileMenuItem(
        title: 'Payment Methods',
        icon: Icons.credit_card,
      ),
      _ProfileMenuItem(
        title: 'Notifications',
        icon: Icons.notifications,
      ),
      _ProfileMenuItem(
        title: 'Help & Support',
        icon: Icons.support_agent,
      ),
      _ProfileMenuItem(
        title: 'Settings',
        icon: Icons.settings,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 44),
      child: Column(
        children: [
          for (final item in items) ...[
            _buildMenuRow(
              context,
              item: item,
            ),
            const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuRow(
    BuildContext context, {
    required _ProfileMenuItem item,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        _openSimplePage(
          context,
          title: item.title,
          icon: item.icon,
        );
      },
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 9),
        decoration: BoxDecoration(
          color: _rowColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: 23,
              color: Colors.black,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 34,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  void _openSimplePage(
    BuildContext context, {
    required String title,
    required IconData icon,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _ProfilePlaceholderPage(
          title: title,
          icon: icon,
        ),
      ),
    );
  }
}

class _ProfileMenuItem {
  final String title;
  final IconData icon;

  const _ProfileMenuItem({
    required this.title,
    required this.icon,
  });
}

class _ProfilePlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const _ProfilePlaceholderPage({
    required this.title,
    required this.icon,
  });

  static const Color _background = Color(0xFFF7F3EE);
  static const Color _olive = Color(0xFF55682A);
  static const Color _cream = Color(0xFFF2EDE6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 74,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              color: _cream,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      size: 32,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0E6DC),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 52,
                        color: _olive,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'This section is ready for backend connection later.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}