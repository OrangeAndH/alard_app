import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'state/app_state.dart';
import 'state/app_setting.dart';
import 'state/app_state_scope.dart';
import 'screens/main_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
  late Locale _currentLocale;
  late ThemeMode _currentThemeMode;
  TextTheme? _cachedTextTheme;
  bool? _cachedIsArabic;
  
  // Use a NavigatorKey to keep the element tree stable during transitions
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _currentLocale = widget.appState.locale;
    _currentThemeMode = widget.settings.themeMode;
    
    widget.settings.addListener(_onSettingsChanged);
    widget.appState.addListener(_onStateChanged);

    // Initial load - safe because it's the very beginning
    widget.appState.loadProductsFromAssets();
  }

  @override
  void dispose() {
    widget.settings.removeListener(_onSettingsChanged);
    widget.appState.addListener(_onStateChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    // ONLY rebuild MaterialApp if theme changed
    if (_currentThemeMode != widget.settings.themeMode) {
      _currentThemeMode = widget.settings.themeMode;
      _cachedTextTheme = null;
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _onStateChanged() {
    // ONLY rebuild MaterialApp if locale changed
    if (_currentLocale != widget.appState.locale) {
      _currentLocale = widget.appState.locale;
      _cachedTextTheme = null;
      if (mounted) {
        setState(() {});
      }
    }
    
    // NOTE: All other changes (cart, products, navigation index)
    // are handled by InheritedNotifier rebuilds in the sub-widgets.
    // We do NOT call setState() here to avoid root collisions and lag.
  }

  TextTheme _getTextTheme(bool isArabic, Brightness brightness) {
    if (_cachedTextTheme != null && _cachedIsArabic == isArabic) {
      return _cachedTextTheme!;
    }

    final baseTheme = ThemeData(brightness: brightness).textTheme;
    TextTheme theme;

    if (isArabic) {
      theme = GoogleFonts.notoNaskhArabicTextTheme(baseTheme).copyWith(
        displayLarge: GoogleFonts.notoKufiArabic(textStyle: baseTheme.displayLarge),
        displayMedium: GoogleFonts.notoKufiArabic(textStyle: baseTheme.displayMedium),
        displaySmall: GoogleFonts.notoKufiArabic(textStyle: baseTheme.displaySmall),
        headlineLarge: GoogleFonts.notoKufiArabic(textStyle: baseTheme.headlineLarge),
        headlineMedium: GoogleFonts.notoKufiArabic(textStyle: baseTheme.headlineMedium),
        headlineSmall: GoogleFonts.notoKufiArabic(textStyle: baseTheme.headlineSmall),
        titleLarge: GoogleFonts.notoKufiArabic(textStyle: baseTheme.titleLarge, fontWeight: FontWeight.bold),
      );
    } else {
      theme = GoogleFonts.sourceSans3TextTheme(baseTheme).copyWith(
        displayLarge: GoogleFonts.bodoniModa(textStyle: baseTheme.displayLarge),
        displayMedium: GoogleFonts.bodoniModa(textStyle: baseTheme.displayMedium),
        displaySmall: GoogleFonts.bodoniModa(textStyle: baseTheme.displaySmall),
        headlineLarge: GoogleFonts.bodoniModa(textStyle: baseTheme.headlineLarge),
        headlineMedium: GoogleFonts.bodoniModa(textStyle: baseTheme.headlineMedium),
        headlineSmall: GoogleFonts.bodoniModa(textStyle: baseTheme.headlineSmall),
        titleLarge: GoogleFonts.bodoniModa(textStyle: baseTheme.titleLarge, fontWeight: FontWeight.bold),
      );
    }

    _cachedTextTheme = theme;
    _cachedIsArabic = isArabic;
    return theme;
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.appState.isArabic;
    final themeMode = widget.settings.themeMode;
    final brightness = themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light;
    
    final textTheme = _getTextTheme(isArabic, brightness);

    return AppSettingsScope(
      settings: widget.settings,
      child: AppStateScope(
        notifier: widget.appState,
        child: MaterialApp(
          navigatorKey: _navigatorKey,
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
          home: const MainScreen(),
        ),
      ),
    );
  }
}
