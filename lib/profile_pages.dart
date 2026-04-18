import 'package:flutter/material.dart';
import 'app_setting.dart';
import 'main.dart';

class AppPageScaffold extends StatelessWidget {
  final String title;
  final Widget child;

  const AppPageScaffold({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final isDark = settings.isDarkMode;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F3EE),
      appBar: AppBar(
        backgroundColor:
            isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F3EE),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF4E5C1E),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}

class PersonalDetailsPage extends StatelessWidget {
  const PersonalDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final isArabic = settings.language == 'Arabic';

    return AppPageScaffold(
      title: isArabic ? 'البيانات الشخصية' : 'Personal Details',
      child: _InfoCardList(
        children: [
          _InfoRow(
            label: isArabic ? 'الاسم الكامل' : 'Full Name',
            value: 'Mohammed',
          ),
          _InfoRow(
            label: isArabic ? 'البريد الإلكتروني' : 'Email',
            value: 'Mohammed@gmail.com',
          ),
          _InfoRow(
            label: isArabic ? 'الدولة' : 'Country',
            value: isArabic ? 'فلسطين' : 'Palestine',
          ),
          _InfoRow(
            label: isArabic ? 'رقم الهاتف' : 'Phone',
            value: '+970 23456789',
          ),
        ],
      ),
    );
  }
}

class ShippingAddressesPage extends StatelessWidget {
  const ShippingAddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final isArabic = settings.language == 'Arabic';

    return AppPageScaffold(
      title: isArabic ? 'عناوين الشحن' : 'Shipping Addresses',
      child: Column(
        children: [
          _addressCard(
            title: isArabic ? 'المنزل' : 'Home',
            details: isArabic
                ? 'نابلس، فلسطين\nالشارع 1، المبنى 2'
                : 'Nablus, Palestine\nStreet 1, Building 2',
          ),
          const SizedBox(height: 12),
          _addressCard(
            title: isArabic ? 'العمل' : 'Work',
            details: isArabic
                ? 'رام الله، فلسطين\nالشارع الرئيسي، مكتب 5'
                : 'Ramallah, Palestine\nMain Street, Office 5',
          ),
        ],
      ),
    );
  }

  Widget _addressCard({
    required String title,
    required String details,
  }) {
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
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            details,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final isArabic = settings.language == 'Arabic';

    return AppPageScaffold(
      title: isArabic ? 'سجل الطلبات' : 'Order History',
      child: ListView(
        children: [
          _ListCard(
            title: isArabic ? 'طلب #1001' : 'Order #1001',
            subtitle: 'Virgin Olive Oil, Zaatar',
            trailing: isArabic ? 'تم التوصيل' : 'Delivered',
          ),
          const SizedBox(height: 12),
          _ListCard(
            title: isArabic ? 'طلب #1002' : 'Order #1002',
            subtitle: 'Green Olives',
            trailing: isArabic ? 'في الطريق' : 'On the way',
          ),
          const SizedBox(height: 12),
          _ListCard(
            title: isArabic ? 'طلب #1003' : 'Order #1003',
            subtitle: 'Dried Sage',
            trailing: isArabic ? 'قيد المعالجة' : 'Processing',
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final isArabic = settings.language == 'Arabic';

    return AppPageScaffold(
      title: isArabic ? 'المفضلة' : 'My Favorites',
      child: ListView(
        children: const [
          _ListCard(
            title: 'Virgin Olive Oil',
            subtitle: '1 liter plastic bottle',
            trailing: '\$15',
          ),
          SizedBox(height: 12),
          _ListCard(
            title: 'Palestinian Zaatar',
            subtitle: '1KG premium blend',
            trailing: '\$10',
          ),
        ],
      ),
    );
  }
}

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final isArabic = settings.language == 'Arabic';

    return AppPageScaffold(
      title: isArabic ? 'طرق الدفع' : 'Payment Methods',
      child: ListView(
        children: [
          _ListCard(
            title: 'Visa **** 4242',
            subtitle: isArabic
                ? 'طريقة الدفع الافتراضية'
                : 'Default payment method',
            trailing: isArabic ? 'مفعل' : 'Active',
          ),
          const SizedBox(height: 12),
          _ListCard(
            title: isArabic ? 'الدفع عند الاستلام' : 'Cash on Delivery',
            subtitle: isArabic
                ? 'متاح للطلبات المحلية'
                : 'Available for local orders',
            trailing: isArabic ? 'مفعل' : 'Enabled',
          ),
        ],
      ),
    );
  }
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool orderUpdates = true;
  bool promos = false;
  bool appNews = true;

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final isArabic = settings.language == 'Arabic';

    return AppPageScaffold(
      title: isArabic ? 'الإشعارات' : 'Notifications',
      child: Column(
        children: [
          _switchTile(
            title: isArabic ? 'تحديثات الطلبات' : 'Order Updates',
            value: orderUpdates,
            onChanged: (value) => setState(() => orderUpdates = value),
          ),
          const SizedBox(height: 10),
          _switchTile(
            title: isArabic ? 'العروض' : 'Promotions',
            value: promos,
            onChanged: (value) => setState(() => promos = value),
          ),
          const SizedBox(height: 10),
          _switchTile(
            title: isArabic ? 'أخبار التطبيق' : 'App News',
            value: appNews,
            onChanged: (value) => setState(() => appNews = value),
          ),
        ],
      ),
    );
  }

  Widget _switchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1EDE6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        value: value,
        activeThumbColor: const Color(0xFF7A8D2F),
        onChanged: onChanged,
      ),
    );
  }
}

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final isArabic = settings.language == 'Arabic';

    return AppPageScaffold(
      title: isArabic ? 'المساعدة والدعم' : 'Help & Support',
      child: _InfoCardList(
        children: [
          _InfoRow(
            label: isArabic ? 'البريد الإلكتروني' : 'Email',
            value: 'support@alardapp.com',
          ),
          _InfoRow(
            label: isArabic ? 'الهاتف' : 'Phone',
            value: '+970 59 000 0000',
          ),
          _InfoRow(
            label: isArabic ? 'ساعات العمل' : 'Working Hours',
            value: isArabic ? '9 صباحاً - 5 مساءً' : '9 AM - 5 PM',
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final bool isDark = settings.isDarkMode;
    final bool isArabic = settings.language == 'Arabic';

    final Color pageBackground =
        isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F3EE);
    final Color cardColor =
        isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF1EDE6);
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color subTextColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: pageBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          isArabic ? 'الإعدادات' : 'Settings',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF4E5C1E),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _settingSwitch(
                title: isArabic ? 'الوضع الداكن' : 'Dark Mode',
                value: settings.isDarkMode,
                onChanged: settings.setDarkMode,
                cardColor: cardColor,
                textColor: textColor,
              ),
              const SizedBox(height: 10),
              _settingSwitch(
                title: isArabic ? 'تسجيل الدخول بالبصمة' : 'Biometric Login',
                value: false,
                onChanged: (_) {},
                cardColor: cardColor,
                textColor: textColor,
              ),
              const SizedBox(height: 10),
              _languageTile(
                settings: settings,
                cardColor: cardColor,
                textColor: textColor,
                subTextColor: subTextColor,
                isArabic: isArabic,
              ),
              const SizedBox(height: 10),
              _settingButton(
                title: isArabic ? 'إصدار التطبيق' : 'App Version',
                value: '1.0.0',
                cardColor: cardColor,
                textColor: textColor,
                valueColor: subTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingSwitch({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color cardColor,
    required Color textColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        value: value,
        activeThumbColor: const Color(0xFF7A8D2F),
        onChanged: onChanged,
      ),
    );
  }

  Widget _languageTile({
    required AppSettings settings,
    required Color cardColor,
    required Color textColor,
    required Color subTextColor,
    required bool isArabic,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: settings.language,
          dropdownColor: cardColor,
          iconEnabledColor: textColor,
          isExpanded: true,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          items: [
            DropdownMenuItem(
              value: 'English',
              child: Text(isArabic ? 'الإنجليزية' : 'English'),
            ),
            DropdownMenuItem(
              value: 'Arabic',
              child: Text(isArabic ? 'العربية' : 'Arabic'),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              settings.setLanguage(value);
            }
          },
          hint: Text(
            isArabic ? 'اللغة' : 'Language',
            style: TextStyle(color: subTextColor),
          ),
        ),
      ),
    );
  }

  Widget _settingButton({
    required String title,
    required String value,
    required Color cardColor,
    required Color textColor,
    required Color valueColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        trailing: Text(
          value,
          style: TextStyle(color: valueColor),
        ),
      ),
    );
  }
}

class _InfoCardList extends StatelessWidget {
  final List<Widget> children;

  const _InfoCardList({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EDE6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailing;

  const _ListCard({
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1EDE6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: Text(
          trailing,
          style: const TextStyle(
            color: Color(0xFF7A8D2F),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}