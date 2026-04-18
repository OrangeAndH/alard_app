import 'package:flutter/material.dart';
import '../../app_setting.dart';
import '../widgets/app_page_scaffold.dart';

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

  Widget _addressCard({required String title, required String details}) {
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
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          const SizedBox(height: 8),
          Text(details, style: const TextStyle(fontSize: 14, height: 1.4)),
        ],
      ),
    );
  }
}