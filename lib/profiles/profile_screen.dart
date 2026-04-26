import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../login_screen.dart';
import 'pages/personal_details_page.dart';
import 'pages/shipping_addresses_page.dart';
import 'pages/order_history_page.dart';
import 'pages/favorites_page.dart';
import 'pages/payment_methods_page.dart';
import 'pages/notifications_page.dart';
import 'pages/help_support_page.dart';
import 'pages/settings_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickProfileImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _openPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildCoverPhoto(),
              const SizedBox(height: 14),
              _buildProfileHeader(),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildOptionTile(
                      icon: Icons.person,
                      title: 'Personal Details',
                      onTap: () => _openPage(
                        const PersonalDetailsPage(),
                      ),
                    ),
                    _buildOptionTile(
                      icon: Icons.location_on,
                      title: 'Shipping Addresses',
                      onTap: () => _openPage(
                        const ShippingAddressesPage(),
                      ),
                    ),
                    _buildOptionTile(
                      icon: Icons.receipt_long,
                      title: 'Order History',
                      onTap: () => _openPage(
                        const OrderHistoryPage(),
                      ),
                    ),
                    _buildOptionTile(
                      icon: Icons.favorite,
                      title: 'My Favorites',
                      onTap: () => _openPage(
                        const FavoritesPage(),
                      ),
                    ),
                    _buildOptionTile(
                      icon: Icons.credit_card,
                      title: 'Payment Methods',
                      onTap: () => _openPage(
                        const PaymentMethodsPage(),
                      ),
                    ),
                    _buildOptionTile(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      onTap: () => _openPage(
                        const NotificationsPage(),
                      ),
                    ),
                    _buildOptionTile(
                      icon: Icons.support_agent,
                      title: 'Help & Support',
                      onTap: () => _openPage(
                        const HelpSupportPage(),
                      ),
                    ),
                    _buildOptionTile(
                      icon: Icons.settings,
                      title: 'Settings',
                      onTap: () => _openPage(
                        const SettingsPage(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7A8D2F),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        icon: const Icon(Icons.logout),
                        label: const Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoverPhoto() {
    return SizedBox(
      width: double.infinity,
      height: 170,
      child: Image.asset(
        'assets/photo2.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: const Color(0xFFD8D2C8),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: const Color(0xFFE4EAD0),
              backgroundImage:
                  _profileImage != null ? FileImage(_profileImage!) : null,
              child: _profileImage == null
                  ? const Icon(
                      Icons.person,
                      size: 52,
                      color: Color(0xFF7A8D2F),
                    )
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _pickProfileImage,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7A8D2F),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Mohammed',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Mohammed@gmail.com',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Palestine',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          '+970 23456789',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EDE6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black, size: 24),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Colors.black,
        ),
        onTap: onTap,
      ),
    );
  }
}