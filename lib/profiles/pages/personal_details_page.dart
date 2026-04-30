import 'package:flutter/material.dart';

import '../../app_state_scope.dart';

class PersonalDetailsPage extends StatefulWidget {
  const PersonalDetailsPage({super.key});

  @override
  State<PersonalDetailsPage> createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
  final TextEditingController _phoneController = TextEditingController();
  String? _lastLoadedPhone;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _loadPhone(String phone) {
    if (_lastLoadedPhone == phone) return;

    _lastLoadedPhone = phone;
    _phoneController.text = phone;
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final user = state.currentUser;

    _loadPhone(user?.phone ?? '');

    final accountType = state.userType.toLowerCase() == 'trader'
        ? state.t('trader')
        : state.t('customer');

    return Directionality(
      textDirection: state.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F3EE),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF7F3EE),
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(
            state.t('personalDetails'),
            style: const TextStyle(
              color: Color(0xFF5D6B1F),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _InfoTile(
                label: state.t('name'),
                value: user?.name ?? state.userName,
              ),
              const SizedBox(height: 12),
              _InfoTile(
                label: state.t('accountType'),
                value: accountType,
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1EDE6),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.t('phoneNumber'),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: state.t('noPhoneAdded'),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5D6B1F),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    state.updatePhone(_phoneController.text);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.t('save')),
                      ),
                    );
                  },
                  child: Text(
                    state.t('save'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonalDetailsScreen extends StatelessWidget {
  const PersonalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PersonalDetailsPage();
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final cleanValue = value.trim().isEmpty ? '-' : value;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EDE6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            cleanValue,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}