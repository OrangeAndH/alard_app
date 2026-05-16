import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'state/app_state.dart';
import 'state/app_setting.dart';
import 'state/app_state_scope.dart';
import 'screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  final appState = AppState();
  final settings = AppSettings();

  runApp(AlardApp(settings: settings, appState: appState));
}

class AlardApp extends StatefulWidget {
  final AppSettings settings;
  final AppState appState;

  const AlardApp({super.key, required this.settings, required this.appState});

  @override
  State<AlardApp> createState() => _AlardAppState();
}

class _AlardAppState extends State<AlardApp> {
  TextTheme? _cachedTextTheme;
  bool? _cachedIsArabic;

  @override
  void initState() {
    super.initState();
    widget.appState.loadProductsFromAssets();
  }

  TextTheme _getTextTheme(bool isArabic, Brightness brightness) {
    if (_cachedTextTheme != null && _cachedIsArabic == isArabic) {
      return _cachedTextTheme!;
    }

    final baseTheme = ThemeData(brightness: brightness).textTheme;
    TextTheme theme;

    if (isArabic) {
      theme = GoogleFonts.notoNaskhArabicTextTheme(baseTheme).copyWith(
        displayLarge: GoogleFonts.notoKufiArabic(
          textStyle: baseTheme.displayLarge,
        ),
        displayMedium: GoogleFonts.notoKufiArabic(
          textStyle: baseTheme.displayMedium,
        ),
        displaySmall: GoogleFonts.notoKufiArabic(
          textStyle: baseTheme.displaySmall,
        ),
        headlineLarge: GoogleFonts.notoKufiArabic(
          textStyle: baseTheme.headlineLarge,
        ),
        headlineMedium: GoogleFonts.notoKufiArabic(
          textStyle: baseTheme.headlineMedium,
        ),
        headlineSmall: GoogleFonts.notoKufiArabic(
          textStyle: baseTheme.headlineSmall,
        ),
        titleLarge: GoogleFonts.notoKufiArabic(
          textStyle: baseTheme.titleLarge,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      theme = GoogleFonts.sourceSans3TextTheme(baseTheme).copyWith(
        displayLarge: GoogleFonts.bodoniModa(textStyle: baseTheme.displayLarge),
        displayMedium: GoogleFonts.bodoniModa(
          textStyle: baseTheme.displayMedium,
        ),
        displaySmall: GoogleFonts.bodoniModa(textStyle: baseTheme.displaySmall),
        headlineLarge: GoogleFonts.bodoniModa(
          textStyle: baseTheme.headlineLarge,
        ),
        headlineMedium: GoogleFonts.bodoniModa(
          textStyle: baseTheme.headlineMedium,
        ),
        headlineSmall: GoogleFonts.bodoniModa(
          textStyle: baseTheme.headlineSmall,
        ),
        titleLarge: GoogleFonts.bodoniModa(
          textStyle: baseTheme.titleLarge,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    _cachedTextTheme = theme;
    _cachedIsArabic = isArabic;
    return theme;
  }

  @override
  Widget build(BuildContext context) {
    return AppSettingsScope(
      settings: widget.settings,
      child: AppStateScope(
        notifier: widget.appState,
        child: Builder(
          builder: (context) {
            final state = AppStateScope.of(context);
            final settings = AppSettingsScope.of(context);

            final isArabic = state.isArabic;
            final themeMode = settings.themeMode;
            final brightness = themeMode == ThemeMode.dark
                ? Brightness.dark
                : Brightness.light;
            final textTheme = _getTextTheme(isArabic, brightness);

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: state.locale,
              supportedLocales: state.supportedLanguages.keys
                  .map((code) => Locale(code))
                  .toList(),
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              themeMode: themeMode,
              theme: ThemeData(
                useMaterial3: true,
                brightness: Brightness.light,
                textTheme: textTheme,
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
                textTheme: textTheme,
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
              // الشاشة الرئيسية المراقبة لحالة الأدمن والمستخدمين تلقائياً
              home: const MainScreen(),
            );
          },
        ),
      ),
    );
  }
}
