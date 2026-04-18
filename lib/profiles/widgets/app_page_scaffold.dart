import 'package:flutter/material.dart';
import '../../app_setting.dart';

class AppPageScaffold extends StatelessWidget {
  final String title;
  final Widget child;

  const AppPageScaffold({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final isDark = settings.isDarkMode;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F3EE),
      appBar: AppBar(
        backgroundColor:
            isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F3EE),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF4E5C1E),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}