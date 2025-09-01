import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/breathe_screen.dart';
import 'screens/stats_screen.dart';

class BreatheBoxApp extends StatelessWidget {
  const BreatheBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BreatheBox',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (_) => const HomeScreen(),
        '/breathe': (_) => const BreatheScreen(),
        '/stats': (_) => const StatsScreen(),
      },
    );
  }
}
