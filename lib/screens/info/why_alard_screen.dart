import 'package:flutter/material.dart';

import '../../state/app_state_scope.dart';

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
                      icon: Icons.restaurant_rounded,
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

  void _showNavMenu(BuildContext context) {
    final state = AppStateScope.of(context);
    final menuItems = [
      {'title': state.t('nav_home'), 'index': 0, 'icon': Icons.home_rounded},
      {'title': state.t('nav_shop'), 'index': 1, 'icon': Icons.shopping_bag_rounded},
      {'title': state.t('nav_recipes'), 'index': 2, 'icon': Icons.restaurant_rounded},
      {'title': state.t('nav_feedback'), 'index': 3, 'icon': Icons.feedback_rounded},
      {'title': state.t('nav_profile'), 'index': 4, 'icon': Icons.person_rounded},
    ];

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'NavMenu',
      barrierColor: Colors.black.withValues(alpha: 0.15),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Align(
          alignment: AlignmentDirectional.centerStart,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.82,
              height: double.infinity,
              color: _background,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 64,
                      width: double.infinity,
                      color: _cream,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        'Menu',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _olive,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: menuItems.length,
                        itemBuilder: (context, index) {
                          final item = menuItems[index];
                          return ListTile(
                            leading: Icon(item['icon'] as IconData, color: _olive),
                            title: Text(
                              item['title'] as String,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(dialogContext);
                              state.setSelectedIndex(item['index'] as int);
                              Navigator.popUntil(context, (route) => route.isFirst);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
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
                    onPressed: () {
                      _showNavMenu(context);
                    },
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
              const SizedBox(width: 84),
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