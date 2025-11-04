import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:a5tmy/core/api_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _currentReciterId = 'Alafasy_128kbps';
  double _playbackSpeed = 1.0;
  bool _isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentReciterId = prefs.getString('currentReciter') ?? 'Alafasy_128kbps';
      _playbackSpeed = prefs.getDouble('playbackSpeed') ?? 1.0;
      _isDarkMode = prefs.getBool('isDarkMode') ?? true;
    });
  }

  Future<void> _clearProgress() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF132539),
        title: const Text(
          'مسح التقدم',
          style: TextStyle(
            fontFamily: 'Cairo',
            color: Colors.white,
          ),
        ),
        content: const Text(
          'هل أنت متأكد من مسح كل التقدم والبدء من جديد؟',
          style: TextStyle(
            fontFamily: 'Cairo',
            color: Colors.white70,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'إلغاء',
              style: TextStyle(
                fontFamily: 'Cairo',
                color: Colors.white70,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'مسح',
              style: TextStyle(
                fontFamily: 'Cairo',
                color: Color(0xFFE8C16B),
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('currentPage', 1);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تم مسح التقدم بنجاح',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = const Color(0xFF0B1A2A);
    final gold = const Color(0xFFE8C16B);
    final cardDark = const Color(0xFF132539);

    final currentReciter = Reciters.byId(_currentReciterId);

    return Scaffold(
      backgroundColor: dark,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 20),
            
            // العنوان
            const Text(
              'الإعدادات',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 30),
            
            // القارئ الحالي
            _buildSection(
              title: 'القارئ الحالي',
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        currentReciter.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        currentReciter.name,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(Icons.check_circle, color: gold),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // سرعة التشغيل
            _buildSection(
              title: 'سرعة التشغيل',
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'السرعة الحالية',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          '${_playbackSpeed}x',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: gold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'يمكنك تغيير السرعة من شريط التحكم السفلي',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // المظهر
            _buildSection(
              title: 'المظهر',
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: cardDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: gold,
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'الوضع الداكن',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Switch(
                      value: _isDarkMode,
                      activeColor: gold,
                      onChanged: (value) async {
                        setState(() => _isDarkMode = value);
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isDarkMode', value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // إدارة البيانات
            _buildSection(
              title: 'إدارة البيانات',
              child: Column(
                children: [
                  _buildActionButton(
                    icon: Icons.refresh_rounded,
                    title: 'مسح التقدم والبدء من جديد',
                    color: Colors.redAccent,
                    onTap: _clearProgress,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // معلومات التطبيق
            _buildSection(
              title: 'عن التطبيق',
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'الختمة السمعية',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'النسخة 1.0.0',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'تطبيق بسيط للاستماع إلى القرآن الكريم صفحة بصفحة',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        color: Colors.white54,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 100), // مساحة للبلاير السفلي
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12, right: 4),
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
        ),
        child,
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF132539),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 15,
                  color: color,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 16),
          ],
        ),
      ),
    );
  }
}
