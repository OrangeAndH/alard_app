import 'package:flutter/material.dart';

import 'app_state_scope.dart';

class WhyAlardScreen extends StatelessWidget {
  const WhyAlardScreen({super.key});

  static const Color _background = Color(0xFFF7F3EE);
  static const Color _cream = Color(0xFFF2EDE6);
  static const Color _olive = Color(0xFF55682A);
  static const Color _darkBlue = Color(0xFF0E1A39);

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);

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
                      title: state.t('why_natural_title'),
                      text: state.t('why_natural_desc'),
                    ),

                    const SizedBox(height: 30),

                    _buildWhyCard(
                      icon: Icons.opacity_outlined,
                      title: state.t('why_premium_title'),
                      text: state.t('why_premium_desc'),
                    ),

                    const SizedBox(height: 30),

                    _buildWhyCard(
                      icon: Icons.agriculture_outlined,
                      title: state.t('why_farmers_title'),
                      text: state.t('why_farmers_desc'),
                    ),

                    const SizedBox(height: 30),

                    _buildWhyCard(
                      icon: Icons.restaurant_menu_outlined,
                      title: state.t('why_taste_title'),
                      text: state.t('why_taste_desc'),
                    ),

                    const SizedBox(height: 30),

                    _buildWhyCard(
                      icon: Icons.public_outlined,
                      title: state.t('why_eco_title'),
                      text: state.t('why_eco_desc'),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final barHeight = (width * 0.16).clamp(56.0, 70.0);
        final buttonSize = (width * 0.11).clamp(38.0, 46.0);

        return Container(
          height: barHeight,
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
              SizedBox(
                width: 84,
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: IconButton(
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints.tightFor(
                      width: buttonSize,
                      height: buttonSize,
                    ),
                    icon: const Icon(
                      Icons.menu_rounded,
                      size: 30,
                      color: _darkBlue,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Image.asset(
                'assets/321.png',
                height: 38,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) {
                  return const Text(
                    "AL'ARD",
                    style: TextStyle(
                      fontSize: 16,
                      color: _olive,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const Spacer(),
              SizedBox(
                width: 84,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints.tightFor(
                        width: buttonSize,
                        height: buttonSize,
                      ),
                      icon: const Icon(
                        Icons.search_rounded,
                        size: 28,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints.tightFor(
                        width: buttonSize,
                        height: buttonSize,
                      ),
                      icon: const Icon(
                        Icons.public_outlined,
                        size: 28,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
          icon: Icon(
            Icons.adaptive.arrow_back,
            size: 30,
            color: Colors.black,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            AppStateScope.of(context).t('why_title'),
            style: const TextStyle(
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