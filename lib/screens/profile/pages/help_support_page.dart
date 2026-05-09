import 'package:flutter/material.dart';
import '../../../state/app_state_scope.dart';
import '../widgets/app_page_scaffold.dart';
import '../widgets/info_card_list.dart';
import '../widgets/info_row.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final isArabic = state.isArabic;

    return AppPageScaffold(
      title: isArabic ? 'المساعدة والدعم' : 'Help & Support',
      child: InfoCardList(
        children: [
          InfoRow(label: 'Email', value: 'support@alardapp.com'),
          InfoRow(label: 'Phone', value: '+970 59 000 0000'),
        ],
      ),
    );
  }
}