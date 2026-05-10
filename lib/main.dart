import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'state/app_setting.dart';
import 'state/app_state.dart';
import 'state/app_state_scope.dart';
import 'screens/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final appState = AppState();
  final settings = AppSettings();

  runApp(AlardApp(settings: settings, appState: appState));

  appState.loadProductsFromAssets();
}

class AlardApp extends StatelessWidget {
  final AppSettings settings;
  final AppState appState;

  const AlardApp({super.key, required this.settings, required this.appState});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([settings, appState]),
      builder: (context, _) {
        return AppSettingsScope(
          settings: settings,
          child: AppStateScope(
            notifier: appState,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: appState.locale,
              supportedLocales: appState.supportedLanguages.keys
                  .map((code) => Locale(code))
                  .toList(),
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              themeMode: settings.themeMode,
              theme: ThemeData(
                useMaterial3: true,
                brightness: Brightness.light,
                scaffoldBackgroundColor: const Color(0xFFF7F3EE),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF7A8D2F),
                  brightness: Brightness.light,
                ),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xFFF7F3EE),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  centerTitle: true,
                ),
                cardColor: const Color(0xFFF1EDE6),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: const Color(0xFFF1EDE6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFF7A8D2F),
                      width: 1.4,
                    ),
                  ),
                ),
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                brightness: Brightness.dark,
                scaffoldBackgroundColor: const Color(0xFF121212),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF9CAF45),
                  brightness: Brightness.dark,
                ),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xFF121212),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  centerTitle: true,
                ),
                cardColor: const Color(0xFF1E1E1E),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFF9CAF45),
                      width: 1.4,
                    ),
                  ),
                ),
              ),
              home: const MainScreen(),
            ),
          ),
        );
      },
    );
  }
}
