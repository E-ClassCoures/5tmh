import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:a5tmy/core/api_service.dart';

class BottomPlayerBar extends StatefulWidget {
  final Reciter currentReciter;
  final int currentPage;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final bool isPlaying;
  final double playbackSpeed;
  final Function(double) onSpeedChange;
  final Function(Reciter) onReciterChange;

  const BottomPlayerBar({
    super.key,
    required this.currentReciter,
    required this.currentPage,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrev,
    required this.isPlaying,
    required this.playbackSpeed,
    required this.onSpeedChange,
    required this.onReciterChange,
  });

  @override
  State<BottomPlayerBar> createState() => _BottomPlayerBarState();
}

class _BottomPlayerBarState extends State<BottomPlayerBar> {
  late Reciter _selectedReciter;

  @override
  void initState() {
    super.initState();
    _selectedReciter = widget.currentReciter;
  }

  @override
  void didUpdateWidget(BottomPlayerBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentReciter.id != widget.currentReciter.id) {
      setState(() => _selectedReciter = widget.currentReciter);
    }
  }

  /// 🧱 BottomSheet لاختيار القارئ
  void _showRecitersBottomSheet(BuildContext context) {
    final gold = const Color(0xFFE8C16B);
    final dark = const Color(0xFF132539);

    showModalBottomSheet(
      context: context,
      backgroundColor: dark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      isScrollControlled: true,
      builder: (context) {
        final allReciters = Reciters.allCombined;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'اختر القارئ',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // ✅ قائمة القراء بالصور
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: allReciters.length,
                    itemBuilder: (context, index) {
                      final reciter = allReciters[index];
                      final isSelected = reciter.id == _selectedReciter.id;

                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: reciter.imageUrl.isNotEmpty
                              ? Image.network(
                                  reciter.imageUrl,
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.person,
                                    color: Colors.white54,
                                    size: 36,
                                  ),
                                )
                              : const Icon(
                                  Icons.person,
                                  color: Colors.white54,
                                  size: 36,
                                ),
                        ),
                        title: Text(
                          reciter.name,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: isSelected
                                ? gold
                                : Colors.white.withOpacity(0.9),
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                          setState(() => _selectedReciter = reciter);
                          widget.onReciterChange(reciter);

                          // حفظ التغيير
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('currentReciter', reciter.id);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final gold = const Color(0xFFE8C16B);
    final dark = const Color(0xFF132539);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: dark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🎧 العنوان + الأزرار
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _selectedReciter.imageUrl.isNotEmpty
                    ? Image.network(
                        _selectedReciter.imageUrl,
                        height: 45,
                        width: 45,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.person,
                            size: 40, color: Colors.white54),
                      )
                    : const Icon(Icons.person, size: 40, color: Colors.white54),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedReciter.name,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "صفحة ${widget.currentPage}",
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: widget.onPrev,
                icon: const Icon(Icons.skip_previous, color: Colors.white70),
              ),
              IconButton(
                onPressed: widget.onPlayPause,
                icon: Icon(
                  widget.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  color: gold,
                  size: 40,
                ),
              ),
              IconButton(
                onPressed: widget.onNext,
                icon: const Icon(Icons.skip_next, color: Colors.white70),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ⚙️ السطر السفلي (سرعة التشغيل + اختيار القارئ)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // سرعة التشغيل
              Row(
                children: [
                  const Icon(Icons.speed, color: Colors.white54, size: 18),
                  const SizedBox(width: 6),
                  DropdownButton<double>(
                    value: widget.playbackSpeed,
                    dropdownColor: dark,
                    underline: const SizedBox(),
                    style: const TextStyle(color: Colors.white),
                    items: [1.0, 1.25, 1.5, 2.0, 2.5, 3.0]
                        .map(
                          (speed) => DropdownMenuItem(
                            value: speed,
                            child: Text('${speed}x'),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) widget.onSpeedChange(v);
                    },
                  ),
                ],
              ),

              // 🔊 تغيير القارئ عبر BottomSheet
              GestureDetector(
                onTap: () => _showRecitersBottomSheet(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: Colors.white70, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        _selectedReciter.name,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_up_rounded,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
