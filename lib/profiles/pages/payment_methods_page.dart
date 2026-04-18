import 'package:flutter/material.dart';
import '../../app_setting.dart';
import '../widgets/app_page_scaffold.dart';
import '../widgets/list_card.dart';

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
          ListCard(
            title: 'Visa **** 4242',
            subtitle: isArabic ? 'طريقة الدفع الافتراضية' : 'Default payment method',
            trailing: isArabic ? 'مفعل' : 'Active',
          ),
          const SizedBox(height: 12),
          ListCard(
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