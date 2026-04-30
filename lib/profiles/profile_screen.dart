import 'package:flutter/material.dart';

import '../app_state_scope.dart';
import '../login_screen.dart';

import 'pages/personal_details_page.dart';
import 'pages/order_history_page.dart';
import 'pages/shipping_addresses_page.dart';
import 'pages/payment_methods_page.dart';
import 'pages/favorites_page.dart';
import 'pages/notifications_page.dart';
import 'pages/help_support_page.dart';
import 'pages/settings_page.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);

    return Directionality(
      textDirection: state.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F3EE),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              children: [
                _buildHeader(state),
                const SizedBox(height: 20),
                _buildMenuCard(context, state),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic state) {
    final translatedUserType = state.userType.toLowerCase() == 'trader'
        ? _text(state, 'Trader', 'تاجر')
        : _text(state, 'Customer', 'زبون');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 58,
            backgroundColor: Color(0xFFD9DFC4),
            child: Icon(
              Icons.person,
              size: 60,
              color: Color(0xFF7A8D2F),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            state.userName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            translatedUserType,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, dynamic state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EDE6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _ProfileTile(
            icon: Icons.person_outline,
            title: _text(state, 'Personal Details', 'البيانات الشخصية'),
            isArabic: state.isArabic,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PersonalDetailsPage(),
                ),
              );
            },
          ),
          const Divider(height: 1),

          _ProfileTile(
            icon: Icons.receipt_long_outlined,
            title: _text(state, 'Order History', 'سجل الطلبات'),
            isArabic: state.isArabic,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const OrderHistoryPage(),
                ),
              );
            },
          ),
          const Divider(height: 1),

          _ProfileTile(
            icon: Icons.location_on_outlined,
            title: _text(state, 'Shipping Addresses', 'عناوين الشحن'),
            isArabic: state.isArabic,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ShippingAddressesPage(),
                ),
              );
            },
          ),
          const Divider(height: 1),

          _ProfileTile(
            icon: Icons.payment_outlined,
            title: _text(state, 'Payment Methods', 'طرق الدفع'),
            isArabic: state.isArabic,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PaymentMethodsPage(),
                ),
              );
            },
          ),
          const Divider(height: 1),

          _ProfileTile(
            icon: Icons.favorite_border,
            title: _text(state, 'Favorites', 'المفضلة'),
            isArabic: state.isArabic,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FavoritesPage(),
                ),
              );
            },
          ),
          const Divider(height: 1),

          _ProfileTile(
            icon: Icons.notifications_none,
            title: _text(state, 'Notifications', 'الإشعارات'),
            isArabic: state.isArabic,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationsPage(),
                ),
              );
            },
          ),
          const Divider(height: 1),

          _ProfileTile(
            icon: Icons.help_outline,
            title: _text(state, 'Help & Support', 'المساعدة والدعم'),
            isArabic: state.isArabic,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HelpSupportPage(),
                ),
              );
            },
          ),
          const Divider(height: 1),

          _ProfileTile(
            icon: Icons.settings_outlined,
            title: _text(state, 'Settings', 'الإعدادات'),
            isArabic: state.isArabic,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
          const Divider(height: 1),

          _ProfileTile(
            icon: Icons.logout,
            title: _text(state, 'Logout', 'تسجيل الخروج'),
            isArabic: state.isArabic,
            iconColor: Colors.red,
            textColor: Colors.red,
            showArrow: false,
            onTap: () {
              state.logout();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  String _text(dynamic state, String english, String arabic) {
    return state.isArabic ? arabic : english;
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isArabic;
  final VoidCallback onTap;
  final Color iconColor;
  final Color textColor;
  final bool showArrow;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.isArabic,
    required this.onTap,
    this.iconColor = const Color(0xFF5D6B1F),
    this.textColor = Colors.black87,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      trailing: showArrow
          ? Icon(
              isArabic ? Icons.chevron_left : Icons.chevron_right,
              color: Colors.black87,
            )
          : null,
      onTap: onTap,
    );
  }
}