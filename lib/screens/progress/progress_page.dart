import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  int _currentPage = 1;
  int _totalPages = 604;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentPage = prefs.getInt('currentPage') ?? 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = const Color(0xFF0B1A2A);
    final gold = const Color(0xFFE8C16B);
    final cardDark = const Color(0xFF132539);

    final percentage = (_currentPage / _totalPages * 100).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: dark,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),

                // العنوان
                const Text(
                  'تقدّمك في الختمة',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 40),

                // الدائرة التقدمية
                SizedBox(
                  width: 220,
                  height: 220,
                  child: CustomPaint(
                    painter: _CircularProgressPainter(
                      progress: _currentPage / _totalPages,
                      color: gold,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$percentage%',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: gold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'من الختمة',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // الإحصائيات
                _buildStatCard(
                  icon: Icons.menu_book_rounded,
                  title: 'الصفحة الحالية',
                  value: '$_currentPage',
                  color: gold,
                  bgColor: cardDark,
                ),

                const SizedBox(height: 12),

                _buildStatCard(
                  icon: Icons.library_books_rounded,
                  title: 'الصفحات المتبقية',
                  value: '${_totalPages - _currentPage}',
                  color: const Color(0xFF78C8B1),
                  bgColor: cardDark,
                ),

                const SizedBox(height: 20),

                // رسالة تحفيزية
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: gold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: gold.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star_rounded, color: gold, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _getMotivationalMessage(),
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            color: Colors.white,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 120), // مساحة إضافية للبلاير
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _getMotivationalMessage() {
    final progress = _currentPage / _totalPages;

    if (progress < 0.1) {
      return 'بداية موفقة! استمر في الاستماع بانتظام';
    } else if (progress < 0.25) {
      return 'ما شاء الله! أنت في الطريق الصحيح';
    } else if (progress < 0.5) {
      return 'رائع! لقد أتممت ربع الختمة';
    } else if (progress < 0.75) {
      return 'بارك الله فيك! تجاوزت النصف';
    } else if (progress < 0.9) {
      return 'ممتاز! أوشكت على إتمام الختمة';
    } else if (progress < 1.0) {
      return 'تبقى القليل! لا تتوقف الآن';
    } else {
      return 'مبارك عليك إتمام الختمة! 🎉';
    }
  }
}

/// رسام الدائرة التقدمية
class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // الدائرة الخلفية
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;

    canvas.drawCircle(center, radius - 6, bgPaint);

    // الدائرة التقدمية
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 6),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
