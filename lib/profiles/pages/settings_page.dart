import 'package:flutter/material.dart';

import '../../app_setting.dart';
import '../../app_state_scope.dart';
import '../widgets/app_page_scaffold.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final settings = AppSettingsScope.of(context);
    final theme = Theme.of(context);

    return AppPageScaffold(
      title: 'Settings',
      child: ListView(
        children: [
          _sectionTitle(context, 'Appearance'),
          const SizedBox(height: 10),
          _settingsCard(
            context,
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: Icon(
                Icons.dark_mode_outlined,
                color: theme.colorScheme.primary,
              ),
              title: Text(
                'Dark Mode',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                'Apply dark colors to the whole app',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.65),
                ),
              ),
              value: settings.isDarkMode,
              onChanged: (value) {
                settings.setDarkMode(value);
              },
            ),
          ),
          const SizedBox(height: 22),
          _sectionTitle(context, 'Language'),
          const SizedBox(height: 10),
          _settingsCard(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.language,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'App Language',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: appState.locale.languageCode,
                  decoration: const InputDecoration(
                    labelText: 'Choose language',
                    prefixIcon: Icon(Icons.translate),
                  ),
                  items: appState.supportedLanguages.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    appState.setLocale(value);
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  'This changes the app locale. To translate every custom text, each screen text must be connected to a translation map.',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _sectionTitle(context, 'Account'),
          const SizedBox(height: 10),
          _settingsCard(
            context,
            child: Column(
              children: [
                _settingsTile(
                  context,
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Manage order and app notifications',
                  onTap: () {},
                ),
                const Divider(),
                _settingsTile(
                  context,
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy',
                  subtitle: 'Manage account privacy settings',
                  onTap: () {},
                ),
                const Divider(),
                _settingsTile(
                  context,
                  icon: Icons.info_outline,
                  title: 'About Al’Ard',
                  subtitle: 'App information and version',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _settingsCard(
    BuildContext context, {
    required Widget child,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }

  Widget _settingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: theme.colorScheme.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.65),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: theme.colorScheme.onSurface.withOpacity(0.6),
      ),
      onTap: onTap,
    );
  }
}