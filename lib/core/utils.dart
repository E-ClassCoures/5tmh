import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 🧩 أدوات مساعدة عامة للتطبيق
class Utils {
  /// 🔢 تنسيق الوقت من Duration إلى نص (مثل: 01:23)
  static String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  /// 💾 حفظ قيمة في SharedPreferences
  static Future<void> saveData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    }
  }

  /// 📥 قراءة قيمة من SharedPreferences
  static Future<dynamic> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  /// 🧹 حذف قيمة معينة من SharedPreferences
  static Future<void> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  /// ⚠️ عرض إشعار بسيط (SnackBar)
  static void showSnackBar(
    BuildContext context,
    String message, {
    Color color = Colors.teal,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Cairo')),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// 🔁 تنسيق رقم الصفحة (001 → Page001.mp3)
  static String padPageNumber(int page) {
    return page.toString().padLeft(3, '0');
  }

  /// 🌙 إظهار مربع حوار تأكيد (إعادة تعيين، حذف، الخ)
  static Future<bool> showConfirmDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF0E1A2A),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Cairo',
            fontSize: 18,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white70,
            fontFamily: 'Cairo',
            fontSize: 15,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'تأكيد',
              style: TextStyle(color: Color(0xFFE8C16B)),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
