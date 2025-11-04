import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:a5tmy/core/api_service.dart';
import 'package:a5tmy/widgets/bottom_player_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:a5tmy/screens/progress/progress_page.dart';
import 'package:a5tmy/screens/settings/settings_page.dart';

class ListenPage extends StatefulWidget {
  final int initialPage;
  const ListenPage({super.key, this.initialPage = 1});

  @override
  State<ListenPage> createState() => _ListenPageState();
}

class _ListenPageState extends State<ListenPage> {
  late AudioPlayer _player;
  int _currentPage = 1;
  bool _isPlaying = false;
  double _playbackSpeed = 1.0;
  Reciter _currentReciter = Reciters.all.first;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  int _selectedIndex = 1; // listen tab
  final ScrollController _scrollController = ScrollController();

  Set<int> _completedPages = {}; // ✅ الصفحات التي تم سماعها بالكامل

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _currentPage = widget.initialPage;

    _player.onDurationChanged.listen((d) => setState(() => _duration = d));
    _player.onPositionChanged.listen((p) => setState(() => _position = p));

    // ✅ عند اكتمال الصفحة يتم حفظها وتلوينها
    _player.onPlayerComplete.listen((_) async {
      await _markPageAsCompleted(_currentPage);
      if (_currentPage < 604) {
        _playPage(_currentPage + 1);
      } else {
        setState(() => _isPlaying = false);
      }
    });

    _loadLastSession();
    _loadCompletedPages();
  }

  Future<void> _loadCompletedPages() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('completedPages') ?? [];
    setState(() {
      _completedPages = saved.map(int.parse).toSet();
    });
  }

  Future<void> _markPageAsCompleted(int page) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _completedPages.add(page);
    });
    await prefs.setStringList(
      'completedPages',
      _completedPages.map((e) => e.toString()).toList(),
    );

    // ✅ حفظ التقدم بشكل بسيط
    await prefs.setInt('progressCount', _completedPages.length);
  }

  Future<void> _loadLastSession() async {
    final prefs = await SharedPreferences.getInstance();
    final lastPage = prefs.getInt('currentPage') ?? 1;
    final lastReciter = prefs.getString('currentReciter');
    final lastSpeed = prefs.getDouble('playbackSpeed') ?? 1.0;

    setState(() {
      _currentPage = widget.initialPage > 1 ? widget.initialPage : lastPage;
      _currentReciter = Reciters.byId(lastReciter);
      _playbackSpeed = lastSpeed;
    });
  }

  Future<void> _playPage(int page) async {
    if (page < 1 || page > 604) return;

    final url = buildPageAudioUrl(reciter: _currentReciter, page: page);
    try {
      await _player.stop();
      await _player.play(UrlSource(url));
      await _player.setPlaybackRate(_playbackSpeed);

      setState(() {
        _currentPage = page;
        _isPlaying = true;
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('currentPage', page);
      await prefs.setString('currentReciter', _currentReciter.id);
      await prefs.setDouble('playbackSpeed', _playbackSpeed);
    } catch (e) {
      setState(() => _isPlaying = false);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("تعذر تشغيل الصفحة $page")));
      }
    }
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _player.pause();
      setState(() => _isPlaying = false);
    } else {
      // نتحقق إذا في ملف جاهز ولا لا
      final state = await _player.getCurrentPosition();
      if (state != null && _duration > Duration.zero) {
        // عنده ملف جاهز، نكمل منه
        await _player.resume();
      } else {
        // ما في صوت جاهز، نشغّل الصفحة الحالية من البداية
        await _playPage(_currentPage);
      }
      setState(() => _isPlaying = true);
    }
  }

  Future<void> _seek(Duration pos) async {
    await _player.seek(pos);
  }

  Future<void> _changeReciter(Reciter r) async {
    // نوقف الصوت الحالي أول
    await _player.stop();

    // نحدّث القارئ
    setState(() => _currentReciter = r);

    // نحفظ الاختيار الجديد
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentReciter', r.id);

    // نشغّل الصفحة الحالية من جديد بصوت القارئ الجديد
    await _playPage(_currentPage);
  }

  Future<void> _changeSpeed(double v) async {
    setState(() => _playbackSpeed = v);
    await _player.setPlaybackRate(v);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('playbackSpeed', v);
  }

  void _scrollToCurrentPage() {
    const double itemHeight = 70.0;
    final targetIndex = (_currentPage - 3).clamp(0, 604);
    _scrollController.animateTo(
      targetIndex * itemHeight,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildQuranList() {
    final darkBox = const Color(0xFF132539);
    final gold = const Color(0xFFE8C16B);

    return ListView.builder(
      controller: _scrollController,
      itemCount: 604,
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
        top: 8,
        bottom: 180,
      ),
      itemBuilder: (context, index) {
        final page = index + 1;
        final isCurrent = page == _currentPage;
        final isCompleted = _completedPages.contains(page);

        Color tileColor;
        if (isCompleted) {
          tileColor = Colors.green.withOpacity(0.4);
        } else if (isCurrent) {
          tileColor = gold.withOpacity(0.15);
        } else {
          tileColor = darkBox;
        }

        return Card(
          color: tileColor,
          margin: const EdgeInsets.symmetric(vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isCompleted
                  ? Colors.green
                  : (isCurrent ? gold.withOpacity(0.5) : Colors.transparent),
              width: 1.5,
            ),
          ),
          child: ListTile(
            leading: Icon(
              isCompleted
                  ? Icons.check_circle_rounded
                  : (isCurrent
                      ? Icons.play_circle_fill
                      : Icons.menu_book_rounded),
              color: isCompleted
                  ? Colors.greenAccent
                  : (isCurrent ? gold : Colors.white70),
              size: 28,
            ),
            title: Text(
              "صفحة $page",
              style: TextStyle(
                fontFamily: 'Cairo',
                color: isCompleted
                    ? Colors.greenAccent
                    : (isCurrent ? gold : Colors.white),
                fontWeight: isCurrent || isCompleted
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: 16,
              ),
            ),
            onTap: () => _playPage(page),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = const Color(0xFF0B1A2A);

    final List<Widget> pages = [
      const ProgressPage(),
      _buildQuranList(),
      const SettingsPage(),
    ];

    return Scaffold(
      backgroundColor: dark,
      appBar: AppBar(
        backgroundColor: dark,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'الختمة السمعية',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButton: null,
      body: Stack(
        children: [
          pages[_selectedIndex],

          // ✅ الزر في الزاوية اليمنى فوق صورة الشيخ والـ timeline
          if (_selectedIndex == 1)
            Positioned(
              right: 16,
              bottom: 225, // يتحكم بمكان الزر فوق المشغل مباشرة
              child: FloatingActionButton(
                heroTag: "scrollToPage",
                backgroundColor: const Color(0xFFE8C16B),
                onPressed: _scrollToCurrentPage,
                child: const Icon(
                  Icons.my_location_rounded,
                  color: Colors.black,
                  size: 28,
                ),
              ),
            ),

          // ✅ المشغل السفلي + التايملاين
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 18,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: const Color(0xFF132539),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(_position),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        Text(
                          _formatDuration(_duration),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Slider(
                    activeColor: const Color(0xFFE8C16B),
                    inactiveColor: Colors.white24,
                    thumbColor: const Color(0xFFE8C16B),
                    min: 0.0,
                    max: _duration.inSeconds.toDouble() > 0
                        ? _duration.inSeconds.toDouble()
                        : 1.0,
                    value: _position.inSeconds
                        .clamp(0, _duration.inSeconds)
                        .toDouble(),
                    onChanged: (v) => _seek(Duration(seconds: v.toInt())),
                  ),
                  BottomPlayerBar(
                    currentReciter: _currentReciter,
                    currentPage: _currentPage,
                    isPlaying: _isPlaying,
                    playbackSpeed: _playbackSpeed,
                    onPlayPause: _togglePlayPause,
                    onNext: () => _playPage(_currentPage + 1),
                    onPrev: () =>
                        _currentPage > 1 ? _playPage(_currentPage - 1) : null,
                    onSpeedChange: _changeSpeed,
                    onReciterChange: _changeReciter,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: dark,
        selectedItemColor: const Color(0xFFE8C16B),
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: const TextStyle(fontFamily: 'Cairo'),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo'),
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart_rounded),
            label: "التقدم",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: "القرآن الكريم",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: "الإعدادات",
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
