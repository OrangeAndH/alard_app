import 'package:flutter/material.dart';

import 'app_setting.dart';
import 'app_state.dart';
import 'app_state_scope.dart';
import 'login_screen.dart';

void main() {
  runApp(
    AlardApp(
      settings: AppSettings(),
      appState: AppState(),
    ),
  );
}

class AlardApp extends StatelessWidget {
  final AppSettings settings;
  final AppState appState;

  const AlardApp({
    super.key,
    required this.settings,
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settings,
      builder: (context, _) {
        return AppSettingsScope(
          settings: settings,
          child: AppStateScope(
            state: appState,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: settings.locale,
              themeMode: settings.themeMode,
              theme: ThemeData(
                brightness: Brightness.light,
                scaffoldBackgroundColor: const Color(0xFFF7F3EE),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF7A8D2F),
                  brightness: Brightness.light,
                ),
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF7A8D2F),
                  brightness: Brightness.dark,
                ),
              ),
              home: const LoginScreen(),
            ),
          ),
        );
      },
    );
  }
}