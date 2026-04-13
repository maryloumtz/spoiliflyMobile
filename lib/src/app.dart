import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/core/session_controller.dart';
import 'package:flutter_application_1/src/pages/auth_page.dart';
import 'package:flutter_application_1/src/pages/shell_page.dart';

class SpoiliflyMobileApp extends StatefulWidget {
  const SpoiliflyMobileApp({super.key});

  @override
  State<SpoiliflyMobileApp> createState() => _SpoiliflyMobileAppState();
}

class _SpoiliflyMobileAppState extends State<SpoiliflyMobileApp> {
  final SessionController _sessionController = SessionController();

  @override
  void dispose() {
    _sessionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFF2BF75);
    const secondary = Color(0xFF8ED8C3);
    const background = Color(0xFF040B13);
    const surface = Color(0xFF0F1823);
    const surfaceContainer = Color(0xFF172332);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spoilifly Mobile',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        colorScheme: const ColorScheme.dark(
          primary: accent,
          secondary: secondary,
          surface: surface,
          surfaceContainerHighest: surfaceContainer,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xCC0F1823),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF13202F),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.38)),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.white.withValues(alpha: 0.06),
          selectedColor: accent.withValues(alpha: 0.18),
          disabledColor: Colors.white.withValues(alpha: 0.04),
          labelStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xE6111820),
          elevation: 0,
          indicatorColor: accent.withValues(alpha: 0.18),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            return TextStyle(
              fontWeight: FontWeight.w700,
              color: states.contains(WidgetState.selected)
                  ? accent
                  : Colors.white.withValues(alpha: 0.72),
            );
          }),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: accent,
            foregroundColor: const Color(0xFF111827),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: BorderSide(color: Colors.white.withValues(alpha: 0.14)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
      home: AnimatedBuilder(
        animation: _sessionController,
        builder: (context, _) {
          if (_sessionController.isAuthenticated) {
            return ShellPage(sessionController: _sessionController);
          }

          return AuthPage(sessionController: _sessionController);
        },
      ),
    );
  }
}
