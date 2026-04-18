import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'app_setting.dart';

void main() {
  runApp(MyApp(settings: AppSettings()));
}

class MyApp extends StatelessWidget {
  final AppSettings settings;

  const MyApp({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settings,
      builder: (context, _) {
        return AppSettingsScope(
          settings: settings,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: settings.locale,
            themeMode: settings.themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: const Color(0xFFF7F3EE),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFFF7F3EE),
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.black),
              ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF7A8D2F),
                brightness: Brightness.light,
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF1E1E1E),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF1E1E1E),
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.white),
              ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF7A8D2F),
                brightness: Brightness.dark,
              ),
            ),
            home: const LoginScreen(),
          ),
        );
      },
    );
  }
}