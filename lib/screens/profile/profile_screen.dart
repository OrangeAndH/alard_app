import 'package:flutter/material.dart';
import '../auth/login_screen.dart';

import 'pages/favorites_page.dart';
import 'pages/help_support_page.dart';
import 'pages/notifications_page.dart';
import 'pages/order_history_page.dart';
import 'pages/payment_methods_page.dart';
import 'pages/personal_details_page.dart';
import 'pages/settings_page.dart';
import 'pages/shipping_addresses_page.dart';
import '../../state/app_state_scope.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback? onGoHome;
  const ProfileScreen({super.key, this.onGoHome});

  static const Color _background = Color(0xFFF7F3EE);
  static const Color _cream = Color(0xFFF2EDE6);
  static const Color _rowColor = Color(0xFFF0E6DC);
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
              child: state.isLoggedIn
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 22),
                      child: Column(
                        children: [
                          _buildHeroImage(),
                          const SizedBox(height: 10),
                          _buildProfileInfo(context),
                          const SizedBox(height: 16),
                          _buildMenuList(context),
                        ],
                      ),
                    )
                  : _buildGuestProfile(context),
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: _cream,
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  if (onGoHome != null) {
                    onGoHome!();
                  } else if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                padding: EdgeInsets.zero,
                constraints: BoxConstraints.tightFor(
                  width: buttonSize,
                  height: buttonSize,
                ),
                icon: Icon(
                  Icons.adaptive.arrow_back,
                  size: 30,
                  color: _darkBlue,
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
                      fontSize: 21,
                      color: _olive,
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
                  size: 30,
                  color: Colors.black,
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
      width: double.infinity,
      height: 136,
      child: Image.asset(
        'assets/profile_banner.jpg',
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return Container(
            color: const Color(0xFFD8CDBE),
            alignment: Alignment.center,
            child: const Icon(
              Icons.landscape_outlined,
              size: 50,
              color: _olive,
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context) {
    final user = AppStateScope.of(context).currentUser;
    final name = user?.name ?? 'Mohammed';
    final email = user?.email ?? 'Mohammed@gmail.com';
    final location = user?.location ?? 'Palestine';
    final phone = user?.phone ?? '+970 23456789';

    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            final picker = ImagePicker();
            final pickedFile = await picker.pickImage(
              source: ImageSource.gallery,
              maxWidth: 800,
              maxHeight: 800,
            );
            if (pickedFile != null) {
              final croppedFile = await ImageCropper().cropImage(
                sourcePath: pickedFile.path,
                uiSettings: [
                  AndroidUiSettings(
                    toolbarTitle: 'Crop Profile Picture',
                    toolbarColor: _olive,
                    toolbarWidgetColor: Colors.white,
                    initAspectRatio: CropAspectRatioPreset.square,
                    lockAspectRatio: true,
                    hideBottomControls: false,
                  ),
                  IOSUiSettings(
                    title: 'Crop Profile Picture',
                    aspectRatioLockEnabled: true,
                    resetAspectRatioEnabled: false,
                  ),
                ],
              );
              
              if (croppedFile != null) {
                final bytes = await croppedFile.readAsBytes();
                if (context.mounted) {
                  AppStateScope.of(context).setProfileImageBytes(bytes);
                }
              }
            }
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  color: _background,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 4,
                  ),
                  image: AppStateScope.of(context).profileImageBytes != null
                      ? DecorationImage(
                          image: MemoryImage(AppStateScope.of(context).profileImageBytes!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: AppStateScope.of(context).profileImageBytes == null
                    ? const Icon(
                        Icons.person_outline_rounded,
                        size: 44,
                        color: Colors.black,
                      )
                    : null,
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: _olive,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          email,
          style: const TextStyle(
            color: Colors.black45,
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          location,
          style: const TextStyle(
            color: Colors.black45,
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.phone_outlined,
              size: 12,
              color: Colors.black38,
            ),
            const SizedBox(width: 5),
            Text(
              phone,
              style: const TextStyle(
                color: Colors.black38,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuList(BuildContext context) {
    final state = AppStateScope.of(context);
    final items = [
      _ProfileMenuItem(
        title: state.t('profile_personal_details'),
        icon: Icons.person,
        originalTitle: 'Personal Details',
      ),
      _ProfileMenuItem(
        title: state.t('profile_shipping_addresses'),
        icon: Icons.location_on,
        originalTitle: 'Shipping Addresses',
      ),
      _ProfileMenuItem(
        title: state.t('profile_order_history'),
        icon: Icons.receipt_long,
        originalTitle: 'Order History',
      ),
      _ProfileMenuItem(
        title: state.t('profile_favorites'),
        icon: Icons.favorite,
        originalTitle: 'My Favorites',
      ),
      _ProfileMenuItem(
        title: state.t('profile_payment_methods'),
        icon: Icons.credit_card,
        originalTitle: 'Payment Methods',
      ),
      _ProfileMenuItem(
        title: state.t('profile_notifications'),
        icon: Icons.notifications,
        originalTitle: 'Notifications',
      ),
      _ProfileMenuItem(
        title: state.t('profile_help_support'),
        icon: Icons.support_agent,
        originalTitle: 'Help & Support',
      ),
      _ProfileMenuItem(
        title: state.t('settings'),
        icon: Icons.settings,
        originalTitle: 'Settings',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          for (final item in items) ...[
            _buildMenuRow(
              context,
              item: item,
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 12),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildMenuRow(
    BuildContext context, {
    required _ProfileMenuItem item,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        _openSimplePage(
          context,
          title: item.originalTitle,
          displayTitle: item.title,
          icon: item.icon,
        );
      },
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: _rowColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: 26,
              color: Colors.black,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 30,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  void _openSimplePage(
    BuildContext context, {
    required String title,
    required String displayTitle,
    required IconData icon,
  }) {
    Widget page;
    switch (title) {
      case 'Personal Details':
        page = const PersonalDetailsPage();
        break;
      case 'Shipping Addresses':
        page = const ShippingAddressesPage();
        break;
      case 'Order History':
        page = const OrderHistoryPage();
        break;
      case 'My Favorites':
        page = const FavoritesPage();
        break;
      case 'Payment Methods':
        page = const PaymentMethodsPage();
        break;
      case 'Notifications':
        page = const NotificationsPage();
        break;
      case 'Help & Support':
        page = const HelpSupportPage();
        break;
      case 'Settings':
        page = const SettingsPage();
        break;
      default:
        page = _ProfilePlaceholderPage(title: displayTitle, icon: icon);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Widget _buildGuestProfile(BuildContext context) {
    final state = AppStateScope.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle_outlined, size: 80, color: Colors.black26),
            const SizedBox(height: 24),
            Text(
              state.t('login_welcome'),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              state.t('profile_placeholder_msg'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _olive,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(state.t('login_button'), style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final state = AppStateScope.of(context);
    return SizedBox(
      width: 160,
      height: 44,
      child: ElevatedButton.icon(
        onPressed: () {
          state.logout();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.red.shade800,
          elevation: 0,
          side: BorderSide(color: Colors.red.shade800, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.logout_rounded, size: 20),
        label: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            state.t('profile_logout'),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileMenuItem {
  final String title;
  final String originalTitle;
  final IconData icon;

  const _ProfileMenuItem({
    required this.title,
    required this.originalTitle,
    required this.icon,
  });
}

class _ProfilePlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const _ProfilePlaceholderPage({
    required this.title,
    required this.icon,
  });

  static const Color _background = Color(0xFFF7F3EE);
  static const Color _olive = Color(0xFF55682A);
  static const Color _cream = Color(0xFFF2EDE6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 74,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              color: _cream,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0E6DC),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 52,
                        color: _olive,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}