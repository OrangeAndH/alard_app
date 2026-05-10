import 'package:flutter/material.dart';
import '../checkout/cart_screen.dart';
import '../../state/app_state_scope.dart';

class DiscoverOurStory extends StatelessWidget {
  const DiscoverOurStory({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: const Color(0xFFEFE8DF),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(context),
                _buildHeroImage(),
                _buildWhoWeAreSection(state),
                _buildOurStorySection(state),
                _buildBottomInfo(state),
              ],
            ),
          ),
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: buttonSize,
                  height: buttonSize,
                  alignment: Alignment.centerLeft,
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 30,
                    color: Color(0xFF27304B),
                  ),
                ),
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/321.png',
                    height: 38,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text(
                        "AL'ARD",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Container(
                    width: buttonSize,
                    height: buttonSize,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.search,
                      size: 28,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: buttonSize,
                      height: buttonSize,
                      alignment: Alignment.centerRight,
                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        size: 28,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeroImage() {
    return ClipRRect(
      child: Image.asset(
        'assets/dis_photo4.png',
        width: double.infinity,
        height: 205,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 205,
            color: Colors.brown.shade200,
          );
        },
      ),
    );
  }

  Widget _buildWhoWeAreSection(dynamic state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/dis_photo1.png',
                width: 34,
                height: 34,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) =>
                    const Icon(Icons.eco, size: 24, color: Color(0xFF6B7A2B)),
              ),
              const SizedBox(width: 8),
              Text(
                state.t('story_who_we_are'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            state.t('story_who_we_are_desc'),

            style: const TextStyle(
              fontSize: 15,
              height: 1.45,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOurStorySection(dynamic state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/dis_photo2.png',
                width: 34,
                height: 34,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) =>
                    const Icon(Icons.eco, size: 24, color: Color(0xFF6B7A2B)),
              ),
              const SizedBox(width: 8),
              Text(
                state.t('story_our_story'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  state.t('story_our_story_desc_1'),
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.45,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/dis_photo3.png',
                  width: 120,
                  height: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 120,
                      height: 160,
                      color: Colors.brown.shade200,
                      child: const Icon(Icons.image, size: 40),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            state.t('story_our_story_desc_2'),
            style: const TextStyle(
              fontSize: 15,
              height: 1.45,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildBottomInfo(dynamic state) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 6, 16, 30),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _InfoItem(
            icon: Icons.handshake_outlined,
            text: state.t('story_fair_trade'),
          ),
        ),
        Expanded(
          child: _InfoItem(
            icon: Icons.eco_outlined,
            text: state.t('story_palestinian_products'),
          ),
        ),
        Expanded(
          child: _InfoItem(
            icon: Icons.agriculture_outlined,
            text: state.t('story_supporting_farmers'),
          ),
        ),
      ],
    ),
  );
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 34, color: const Color(0xFF6B7A2F)),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D2D2D),
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
