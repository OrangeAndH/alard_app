import 'package:flutter/material.dart';
import '../../app_setting.dart';
import '../widgets/app_page_scaffold.dart';
import '../widgets/list_card.dart';

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
          ListCard(
            title: isArabic ? 'طلب #1001' : 'Order #1001',
            subtitle: 'Virgin Olive Oil, Zaatar',
            trailing: isArabic ? 'تم التوصيل' : 'Delivered',
          ),
          const SizedBox(height: 12),
          ListCard(
            title: isArabic ? 'طلب #1002' : 'Order #1002',
            subtitle: 'Green Olives',
            trailing: isArabic ? 'في الطريق' : 'On the way',
          ),
          const SizedBox(height: 12),
          ListCard(
            title: isArabic ? 'طلب #1003' : 'Order #1003',
            subtitle: 'Dried Sage',
            trailing: isArabic ? 'قيد المعالجة' : 'Processing',
          ),
        ],
      ),
    );
  }
}