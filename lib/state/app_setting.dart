import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {
  bool _isDarkMode = false;
  String _language = 'English';

  bool get isDarkMode => _isDarkMode;
  String get language => _language;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Locale get locale {
    return _language == 'Arabic'
        ? const Locale('ar')
        : const Locale('en');
  }

  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void setLanguage(String value) {
    _language = value;
    notifyListeners();
  }
}

class AppSettingsScope extends InheritedWidget {
  final AppSettings settings;

  const AppSettingsScope({
    super.key,
    required this.settings,
    required super.child,
  });

  static AppSettings of(BuildContext context) {
    final AppSettingsScope? scope =
        context.dependOnInheritedWidgetOfExactType<AppSettingsScope>();
    assert(scope != null, 'AppSettingsScope not found in context');
    return scope!.settings;
  }

  @override
  bool updateShouldNotify(AppSettingsScope oldWidget) => true;
}
