import 'package:flutter/material.dart';

import 'notifications_page.dart';

class PersonalDetailsPage extends StatefulWidget {
  const PersonalDetailsPage({super.key});

  @override
  State<PersonalDetailsPage> createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
  static const Color _background = Color(0xFFF7F3EE);
  static const Color _cream = Color(0xFFF2EDE6);
  static const Color _fieldColor = Color(0xFFF0E6DC);
  static const Color _olive = Color(0xFF55682A);

  final TextEditingController _nameController =
      TextEditingController(text: 'Mohammed');
  final TextEditingController _emailController =
      TextEditingController(text: 'Mohammed@gmail.com');
  final TextEditingController _phoneController =
      TextEditingController(text: '+970     593245879');
  final TextEditingController _cityController =
      TextEditingController(text: 'Nablus');

  String _country = 'Palestine';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      bottomNavigationBar: const _ProfileBottomNav(currentIndex: 4),
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
                    const SizedBox(height: 18),
                    const Text(
                      'Personal Details',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _buildForm(),
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
      color: _cream,
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
              Icons.arrow_back_rounded,
              color: Colors.black,
              size: 36,
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

  Widget _buildHeroImage() {
    return SizedBox(
      height: 112,
      width: double.infinity,
      child: Image.asset(
        'assets/photo2.png',
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            color: const Color(0xFFD8CDBE),
            child: const Center(
              child: Icon(
                Icons.landscape_outlined,
                color: _olive,
                size: 48,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Full Name'),
          _textField(_nameController),
          const SizedBox(height: 13),
          _label('Email Address'),
          _textField(_emailController),
          const SizedBox(height: 13),
          _label('Phone Number'),
          _textField(_phoneController),
          const SizedBox(height: 13),
          _label('Country'),
          _countryDropDown(),
          const SizedBox(height: 13),
          _label('City'),
          _textField(_cityController),
          const SizedBox(height: 22),
          Center(
            child: SizedBox(
              width: 132,
              height: 32,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Changes saved'),
                      duration: Duration(milliseconds: 900),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: _fieldColor,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _textField(TextEditingController controller) {
    return SizedBox(
      height: 31,
      child: TextField(
        controller: controller,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 13,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: _fieldColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _countryDropDown() {
    return Container(
      height: 31,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: _fieldColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _country,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.black,
          ),
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 13,
          ),
          items: const [
            DropdownMenuItem(
              value: 'Palestine',
              child: Text('Palestine'),
            ),
            DropdownMenuItem(
              value: 'Germany',
              child: Text('Germany'),
            ),
            DropdownMenuItem(
              value: 'USA',
              child: Text('USA'),
            ),
            DropdownMenuItem(
              value: 'UAE',
              child: Text('UAE'),
            ),
          ],
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              _country = value;
            });
          },
        ),
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
      decoration: const BoxDecoration(
        color: _cream,
      ),
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