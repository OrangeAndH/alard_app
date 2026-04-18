import 'package:flutter/material.dart';
import '../../app_setting.dart';
import '../widgets/app_page_scaffold.dart';
import '../widgets/list_card.dart';

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
          ListCard(
            title: 'Virgin Olive Oil',
            subtitle: '1 liter plastic bottle',
            trailing: '\$15',
          ),
          SizedBox(height: 12),
          ListCard(
            title: 'Palestinian Zaatar',
            subtitle: '1KG premium blend',
            trailing: '\$10',
          ),
        ],
      ),
    );
  }
}