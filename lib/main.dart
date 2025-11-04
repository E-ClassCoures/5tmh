import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // ✅ ضروري
import 'package:a5tmy/screens/listen/listen_page.dart';
import 'package:a5tmy/screens/progress/progress_page.dart';
import 'package:a5tmy/screens/settings/settings_page.dart';
import 'package:a5tmy/screens/startup/startup_page.dart';
import 'package:a5tmy/core/theme.dart';

void main() {
  runApp(const A5tmyApp());
}

class A5tmyApp extends StatelessWidget {
  const A5tmyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'الختمة السمعية',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,

      // ✅ دعم اللغة العربية
      locale: const Locale('ar', 'SA'),
      supportedLocales: const [
        Locale('ar', 'SA'),
        Locale('en', 'US'),
      ],

      // ✅ هذي السطور هي اللي كانت ناقصة
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: const StartupPage(),
      routes: {
        '/listen': (context) => const ListenPage(),
        '/progress': (context) => const ProgressPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
