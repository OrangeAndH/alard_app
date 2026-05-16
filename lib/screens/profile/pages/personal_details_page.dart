import 'package:flutter/material.dart';

import '../../../state/app_state_scope.dart';
import 'notifications_page.dart';
import '../../../widgets/store_dialog.dart';

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

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final user = AppStateScope.of(context).currentUser;
      if (user != null) {
        _nameController.text = user.name;
        _emailController.text = user.email;
        _phoneController.text = user.phone;
        
      }
      _initialized = true;
    }
  }

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
                    Text(
                      AppStateScope.of(context).t('profile_personal_details'),
                      style: const TextStyle(
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final barHeight = (width * 0.16).clamp(56.0, 70.0);
        final buttonSize = (width * 0.11).clamp(38.0, 46.0);

        return Container(
          height: barHeight,
          color: _cream,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                padding: EdgeInsets.zero,
                constraints: BoxConstraints.tightFor(
                  width: buttonSize,
                  height: buttonSize,
                ),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.black,
                  size: 30,
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
                constraints: BoxConstraints.tightFor(
                  width: buttonSize,
                  height: buttonSize,
                ),
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeroImage() {
    return SizedBox(
      height: 112,
      width: double.infinity,
      child: Image.asset(
        'assets/photo2.png',
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return Container(
            color: const Color(0xFFD8CDBE),
            child: const Center(
              child: Icon(Icons.landscape_outlined, color: _olive, size: 48),
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm() {
    final state = AppStateScope.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(state.t('personal_full_name')),
          _textField(_nameController),
          const SizedBox(height: 13),
          _label(state.t('personal_email_address')),
          _textField(_emailController),
          const SizedBox(height: 13),
          _label(state.t('personal_phone_number')),
          _textField(_phoneController),
          const SizedBox(height: 13),
          _label(state.t('personal_country')),
          _countryDropDown(),
          const SizedBox(height: 13),
          _label(state.t('personal_city')),
          _textField(_cityController),
          const SizedBox(height: 22),
          Center(
            child: SizedBox(
              width: 156,
              height: 38,
              child: ElevatedButton(
                onPressed: () {
                  final name = _nameController.text.trim();
                  final email = _emailController.text.trim();
                  final phone = _phoneController.text.trim();

                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.t('personal_error_name'))),
                    );
                    return;
                  }

                  if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.t('personal_error_email'))),
                    );
                    return;
                  }

                  if (phone.isEmpty || phone.length < 8) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.t('personal_error_phone'))),
                    );
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.t('personal_success_saved')),
                      duration: const Duration(milliseconds: 900),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: _fieldColor,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    state.t('personal_save_changes'),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
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
        style: const TextStyle(color: Colors.black87, fontSize: 13),
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
    final state = AppStateScope.of(context);
    return InkWell(
      onTap: () => showStoreDialog(context),
      child: Container(
        height: 31,
        padding: const EdgeInsets.symmetric(horizontal: 9),
        decoration: BoxDecoration(
          color: _fieldColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Text(
              state.currentStore,
              style: const TextStyle(color: Colors.black87, fontSize: 13),
            ),
            const Spacer(),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.black,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
