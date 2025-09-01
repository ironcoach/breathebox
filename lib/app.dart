// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen.dart';
import 'screens/breathe_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/settings_screen.dart';

class BreatheBoxApp extends ConsumerWidget {
  const BreatheBoxApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pick a seed color for a cohesive color scheme — tweak as you like
    const seedColor = Color(0xFF00695C);

    final light = ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor, brightness: Brightness.light),
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      textTheme: Typography.material2021().black.apply(
            bodyColor: Colors.black87,
            displayColor: Colors.black87,
          ),
    );

    final dark = ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor, brightness: Brightness.dark),
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      textTheme: Typography.material2021().white.apply(
            bodyColor: Colors.white70,
            displayColor: Colors.white70,
          ),
    );

    // TODO: If you add a boolean darkMode to your settings provider (e.g. settings.darkMode)
    // you can change the themeMode below to:
    // themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light
    //
    // For now we default to system theme
    return MaterialApp(
      title: 'BreatheBox',
      debugShowCheckedModeBanner: false,
      theme: light,
      darkTheme: dark,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (ctx) => const HomeScreen(),
        '/breathe': (ctx) => const BreatheScreen(),
        '/stats': (ctx) => const StatsScreen(),
        '/settings': (ctx) => const SettingsScreen(),
      },
    );
  }
}
