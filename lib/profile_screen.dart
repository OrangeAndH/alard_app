import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileItems = [
      {
        'title': 'Personal Details',
        'icon': Icons.person,
      },
      {
        'title': 'Shipping Addresses',
        'icon': Icons.location_on,
      },
      {
        'title': 'Order History',
        'icon': Icons.receipt_long,
      },
      {
        'title': 'My Favorites',
        'icon': Icons.favorite,
      },
      {
        'title': 'Payment Methods',
        'icon': Icons.credit_card,
      },
      {
        'title': 'Notifications',
        'icon': Icons.notifications,
      },
      {
        'title': 'Help & Support',
        'icon': Icons.public,
      },
      {
        'title': 'Settings',
        'icon': Icons.settings,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              _buildTopBar(),
              const SizedBox(height: 8),
              _buildHeaderImage(),
              const SizedBox(height: 12),
              _buildProfileInfo(),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: profileItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildProfileTile(
                        title: item['title'] as String,
                        icon: item['icon'] as IconData,
                        onTap: () {},
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, size: 30),
          ),
          const Spacer(),
          Image.asset(
            'assets/alard_logo.png',
            height: 55,
            errorBuilder: (context, error, stackTrace) {
              return const Text(
                "AL'ARD",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D6B1F),
                ),
              );
            },
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, size: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: SizedBox(
          width: double.infinity,
          height: 145,
          child: Image.asset(
            'assets/123.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFFD8D2C8),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      children: const [
        CircleAvatar(
          radius: 34,
          backgroundColor: Colors.black,
          child: CircleAvatar(
            radius: 31,
            backgroundColor: Color(0xFFF7F3EE),
            child: Icon(
              Icons.person_outline,
              size: 42,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Mohammed',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 3),
        Text(
          'Mohammed@gmail.com',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Palestine',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.phone_enabled_outlined,
              size: 14,
              color: Colors.grey,
            ),
            SizedBox(width: 6),
            Text(
              '+970 23456789',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFFF0E8DF),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.black,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 22,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}