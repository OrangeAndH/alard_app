import 'package:flutter/material.dart';
import '../../app_setting.dart';
import '../widgets/app_page_scaffold.dart';

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
          _tile('Order Updates', orderUpdates, (v) => setState(() => orderUpdates = v)),
          _tile('Promotions', promos, (v) => setState(() => promos = v)),
          _tile('App News', appNews, (v) => setState(() => appNews = v)),
        ],
      ),
    );
  }

  Widget _tile(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}