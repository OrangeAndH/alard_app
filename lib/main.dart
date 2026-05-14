import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'state/app_setting.dart';
import 'state/app_state.dart';
import 'state/app_state_scope.dart';
import 'screens/main_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final appState = AppState();
  final settings = AppSettings();

  runApp(AlardApp(settings: settings, appState: appState));

  appState.loadProductsFromAssets();
}

class AlardApp extends StatefulWidget {
  final AppSettings settings;
  final AppState appState;

  const AlardApp({super.key, required this.settings, required this.appState});

  @override
  State<AlardApp> createState() => _AlardAppState();
}

class _AlardAppState extends State<AlardApp> {
  @override
  void initState() {
    super.initState();
    widget.settings.addListener(_onStateChanged);
    widget.appState.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    widget.settings.removeListener(_onStateChanged);
    widget.appState.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.appState.isArabic;
    final baseTheme = ThemeData(
      brightness: widget.settings.themeMode == ThemeMode.dark
          ? Brightness.dark
          : Brightness.light,
    ).textTheme;

    TextTheme textTheme;
    if (isArabic) {
      textTheme = GoogleFonts.notoNaskhArabicTextTheme(baseTheme).copyWith(
        displayLarge:
            GoogleFonts.notoKufiArabic(textStyle: baseTheme.displayLarge),
        displayMedium:
            GoogleFonts.notoKufiArabic(textStyle: baseTheme.displayMedium),
        displaySmall:
            GoogleFonts.notoKufiArabic(textStyle: baseTheme.displaySmall),
        headlineLarge:
            GoogleFonts.notoKufiArabic(textStyle: baseTheme.headlineLarge),
        headlineMedium:
            GoogleFonts.notoKufiArabic(textStyle: baseTheme.headlineMedium),
        headlineSmall:
            GoogleFonts.notoKufiArabic(textStyle: baseTheme.headlineSmall),
        titleLarge: GoogleFonts.notoKufiArabic(
            textStyle: baseTheme.titleLarge, fontWeight: FontWeight.bold),
      );
    } else {
      textTheme = GoogleFonts.sourceSans3TextTheme(baseTheme).copyWith(
        displayLarge: GoogleFonts.bodoniModa(textStyle: baseTheme.displayLarge),
        displayMedium:
            GoogleFonts.bodoniModa(textStyle: baseTheme.displayMedium),
        displaySmall:
            GoogleFonts.bodoniModa(textStyle: baseTheme.displaySmall),
        headlineLarge:
            GoogleFonts.bodoniModa(textStyle: baseTheme.headlineLarge),
        headlineMedium:
            GoogleFonts.bodoniModa(textStyle: baseTheme.headlineMedium),
        headlineSmall:
            GoogleFonts.bodoniModa(textStyle: baseTheme.headlineSmall),
        titleLarge: GoogleFonts.bodoniModa(
            textStyle: baseTheme.titleLarge, fontWeight: FontWeight.bold),
      );
    }

    return AppSettingsScope(
      settings: widget.settings,
      child: AppStateScope(
        state: widget.appState,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: widget.appState.locale,
          supportedLocales: widget.appState.supportedLanguages.keys
              .map((code) => Locale(code))
              .toList(),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          themeMode: widget.settings.themeMode,
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
          home: const MainScreen(),
        ),
      ),
    );
  }
}
