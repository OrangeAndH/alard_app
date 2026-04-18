import 'package:flutter/material.dart';
import '../../app_setting.dart';
import '../widgets/app_page_scaffold.dart';
import '../widgets/info_card_list.dart';
import '../widgets/info_row.dart';

class PersonalDetailsPage extends StatelessWidget {
  const PersonalDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final isArabic = settings.language == 'Arabic';

    return AppPageScaffold(
      title: isArabic ? 'البيانات الشخصية' : 'Personal Details',
      child: InfoCardList(
        children: [
          InfoRow(
            label: isArabic ? 'الاسم الكامل' : 'Full Name',
            value: 'Mohammed',
          ),
          InfoRow(
            label: isArabic ? 'البريد الإلكتروني' : 'Email',
            value: 'Mohammed@gmail.com',
          ),
          InfoRow(
            label: isArabic ? 'الدولة' : 'Country',
            value: isArabic ? 'فلسطين' : 'Palestine',
          ),
          InfoRow(
            label: isArabic ? 'رقم الهاتف' : 'Phone',
            value: '+970 23456789',
          ),
        ],
      ),
    );
  }
}