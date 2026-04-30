import 'package:flutter/material.dart';

class WhyAlardScreen extends StatelessWidget {
  const WhyAlardScreen({super.key});

  static const Color _background = Color(0xFFF7F3EE);
  static const Color _cream = Color(0xFFF2EDE6);
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
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleRow(context),
                    const SizedBox(height: 28),

                    _buildWhyCard(
                      icon: Icons.eco_outlined,
                      title: '100% Natural',
                      text:
                          'All products are made from natural Palestinian ingredients without artificial additives.',
                    ),

                    const SizedBox(height: 30),

                    _buildWhyCard(
                      icon: Icons.opacity_outlined,
                      title: 'Premium Olive Oil',
                      text:
                          'High-quality extra virgin olive oil sourced from traditional Palestinian olive trees.',
                    ),

                    const SizedBox(height: 30),

                    _buildWhyCard(
                      icon: Icons.agriculture_outlined,
                      title: 'Support Palestinian Farmers',
                      text:
                          'Every purchase helps support local farmers and strengthens the Palestinian agricultural community.',
                    ),

                    const SizedBox(height: 30),

                    _buildWhyCard(
                      icon: Icons.restaurant_menu_outlined,
                      title: 'Authentic Palestinian Taste.',
                      text:
                          "Traditional recipes like za'atar, sumac, and olive oil that represent the rich heritage of Palestine.",
                    ),

                    const SizedBox(height: 30),

                    _buildWhyCard(
                      icon: Icons.public_outlined,
                      title: 'Eco-Friendly Production',
                      text:
                          'Products are produced using sustainable and environmentally friendly practices.',
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

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 84,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: const BoxDecoration(
        color: _cream,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE2DAD0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(
              width: 42,
              height: 42,
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
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(
              width: 42,
              height: 42,
            ),
            icon: const Icon(
              Icons.search_rounded,
              size: 38,
              color: Colors.black,
            ),
          ),

          IconButton(
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(
              width: 42,
              height: 42,
            ),
            icon: const Icon(
              Icons.public_outlined,
              size: 36,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(
            width: 40,
            height: 40,
          ),
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 38,
            color: Colors.black,
          ),
        ),

        const SizedBox(width: 12),

        const Expanded(
          child: Text(
            "Why Al ‘Ard Product ?",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'serif',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWhyCard({
    required IconData icon,
    required String title,
    required String text,
  }) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 72,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF0E6DC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: const BoxDecoration(
              color: Color(0xFFF8F3EA),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: _olive,
              size: 32,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _olive,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    height: 1.05,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}