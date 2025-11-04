import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  Future<void> _continueLastSession() async {
    final prefs = await SharedPreferences.getInstance();
    final lastPage = prefs.getInt('currentPage') ?? 1;
    final lastReciter = prefs.getString('currentReciter') ?? 'Alafasy_128kbps';

    Navigator.pushReplacementNamed(
      context,
      '/listen',
      arguments: {'page': lastPage, 'reciter': lastReciter},
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = const Color(0xFF0B1A2A);
    final gold = const Color(0xFFE8C16B);

    return Scaffold(
      backgroundColor: dark,
      body: Stack(
        children: [
          // 🔥 الخلفية البسيطة بدون صورة (عشان الخطأ يختفي)
          Container(color: dark),

          // المحتوى
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '🌙 الختمة السمعية',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'مرحباً بعودتك!\nهل ترغب بالاستمرار من آخر صفحة استمعت إليها؟',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: _continueLastSession,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gold,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.play_arrow, color: Colors.black),
                  label: const Text(
                    'استمرار من آخر صفحة',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
