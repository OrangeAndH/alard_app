import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../app_state.dart';
import '../app_state_scope.dart';
import '../login_screen.dart';
import 'pages/favorites_page.dart';
import 'pages/help_support_page.dart';
import 'pages/notifications_page.dart';
import 'pages/order_history_page.dart';
import 'pages/payment_methods_page.dart';
import 'pages/personal_details_page.dart';
import 'pages/settings_page.dart';
import 'pages/shipping_addresses_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickProfileImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      final Uint8List imageBytes = await pickedFile.readAsBytes();

      if (!mounted) return;

      AppStateScope.of(context).setProfileImageBytes(imageBytes);
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not pick image')),
      );
    }
  }

  void _logout() {
    AppStateScope.of(context).logout();

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
    final appState = AppStateScope.of(context);
    final user = appState.currentUser ??
        const AppUser(
          name: 'Guest User',
          email: 'guest@alard.com',
          phone: 'No phone added',
          location: 'No location added',
          isTrader: false,
        );

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildCoverPhoto(isDark),
              const SizedBox(height: 14),
              _buildProfileHeader(
                user: user,
                imageBytes: appState.profileImageBytes,
                isDark: isDark,
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildOptionTile(
                      icon: Icons.person,
                      title: 'Personal Details',
                      onTap: () => _openPage(const PersonalDetailsPage()),
                    ),
                    _buildOptionTile(
                      icon: Icons.location_on,
                      title: 'Shipping Addresses',
                      onTap: () => _openPage(const ShippingAddressesPage()),
                    ),
                    _buildOptionTile(
                      icon: Icons.receipt_long,
                      title: 'Order History',
                      onTap: () => _openPage(const OrderHistoryPage()),
                    ),
                    _buildOptionTile(
                      icon: Icons.favorite,
                      title: 'My Favorites',
                      onTap: () => _openPage(const FavoritesPage()),
                    ),
                    _buildOptionTile(
                      icon: Icons.credit_card,
                      title: 'Payment Methods',
                      onTap: () => _openPage(const PaymentMethodsPage()),
                    ),
                    _buildOptionTile(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      onTap: () => _openPage(const NotificationsPage()),
                    ),
                    _buildOptionTile(
                      icon: Icons.support_agent,
                      title: 'Help & Support',
                      onTap: () => _openPage(const HelpSupportPage()),
                    ),
                    _buildOptionTile(
                      icon: Icons.settings,
                      title: 'Settings',
                      onTap: () => _openPage(const SettingsPage()),
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

  Widget _buildCoverPhoto(bool isDark) {
    return SizedBox(
      width: double.infinity,
      height: 170,
      child: Image.asset(
        'assets/photo2.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFD8D2C8),
            child: const Center(
              child: Icon(Icons.image_not_supported_outlined, size: 42),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader({
    required AppUser user,
    required Uint8List? imageBytes,
    required bool isDark,
  }) {
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor:
                  isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE4EAD0),
              backgroundImage:
                  imageBytes == null ? null : MemoryImage(imageBytes),
              child: imageBytes == null
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
                    border: Border.all(
                      color: isDark ? Colors.black : Colors.white,
                      width: 2,
                    ),
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
        Text(
          user.name,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(user.email, style: TextStyle(fontSize: 14, color: subTextColor)),
        const SizedBox(height: 4),
        Text(user.location, style: TextStyle(fontSize: 14, color: subTextColor)),
        const SizedBox(height: 4),
        Text(user.phone, style: TextStyle(fontSize: 14, color: subTextColor)),
        const SizedBox(height: 4),
        Text(user.role, style: TextStyle(fontSize: 13, color: subTextColor)),
      ],
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDark ? Colors.white : Colors.black,
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: isDark ? Colors.white70 : Colors.black,
        ),
        onTap: onTap,
      ),
    );
  }
}