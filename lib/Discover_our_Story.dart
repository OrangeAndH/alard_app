import 'package:flutter/material.dart';
import 'cart_screen.dart';

class DiscoverOurStory extends StatelessWidget {
  const DiscoverOurStory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEFE8DF),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(context),
                _buildHeroImage(),
                _buildWhoWeAreSection(),
                _buildOurStorySection(),
                _buildBottomInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 30,
              color: Color(0xFF27304B),
            ),
          ),
          const Spacer(),
          Column(
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
              const Icon(Icons.search, size: 28, color: Colors.black),
              const SizedBox(width: 14),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartScreen(),
                    ),
                  );
                },
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 28,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return ClipRRect(
      child: Image.asset(
        'assets/dis_photo4.png',
        width: double.infinity,
        height: 205,
        fit: BoxFit.cover,
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

  Widget _buildWhoWeAreSection() {
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
                errorBuilder: (_, _, _) => const Icon(
                  Icons.eco,
                  size: 24,
                  color: Color(0xFF6B7A2B),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Who We Are',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Al’Ard Palestinian Agricultural Products is an innovative and dynamic company that offers a wide range of high-quality Palestinian agricultural products.\n"
            "Founded in 2008, the company is a member of the International Fair Trade Association and strongly believes in the principles of social investment.\n"
            "We focus on supporting, empowering, and encouraging Palestinian farmers to benefit from the rich agricultural potential of Palestine.\n"
            "We provide them with the necessary tools, training, and knowledge to produce high-quality products that can compete in global markets.",
            style: TextStyle(
              fontSize: 15,
              height: 1.45,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOurStorySection() {
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
                errorBuilder: (_, _, _) => const Icon(
                  Icons.eco,
                  size: 24,
                  color: Color(0xFF6B7A2B),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Our Story',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/dis_photo3.png',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.brown.shade200,
                  child: const Icon(Icons.image, size: 40),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Al’Ard was founded by Ziad Anabtawi to support poor Palestinian farmers who struggled to sell their olive oil at a fair price.\n"
            "He helped them by providing modern facilities and connecting them with international markets.\n"
            "Now, more than ten years later, his son Sobhi returned to Palestine after traveling across Europe to learn about organic farming and fair-trade practices. Today, the company continues to support farmers first by maintaining transparent and ethical business practices while helping farmers access tools, storage facilities, and internationally recognized certifications.",
            style: TextStyle(
              fontSize: 15,
              height: 1.45,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _InfoItem(
            icon: Icons.handshake_outlined,
            text: 'Fair Trade',
          ),
          _InfoItem(
            icon: Icons.eco_outlined,
            text: 'Palestinian\nProducts',
          ),
          _InfoItem(
            icon: Icons.agriculture_outlined,
            text: 'Supporting\nFarmers',
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 34,
          color: const Color(0xFF6B7A2F),
        ),
        const SizedBox(height: 6),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}