import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:a5tmy/core/api_service.dart';

/// 🎵 خدمة إدارة الصوت المركزية
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  
  // الحالة الحالية
  int _currentPage = 1;
  Reciter _currentReciter = Reciters.all.first;
  double _playbackSpeed = 1.0;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  
  // Getters
  AudioPlayer get player => _player;
  int get currentPage => _currentPage;
  Reciter get currentReciter => _currentReciter;
  double get playbackSpeed => _playbackSpeed;
  bool get isPlaying => _isPlaying;
  Duration get duration => _duration;
  Duration get position => _position;

  /// تهيئة المشغل والاستماع للأحداث
  Future<void> initialize() async {
    // تحميل آخر جلسة
    await loadLastSession();
    
    // الاستماع لتغيرات المدة
    _player.onDurationChanged.listen((d) {
      _duration = d;
    });
    
    // الاستماع لتغيرات الموضع
    _player.onPositionChanged.listen((p) {
      _position = p;
    });
    
    // الاستماع لانتهاء التشغيل (للتشغيل التلقائي للصفحة التالية)
    _player.onPlayerComplete.listen((_) {
      _isPlaying = false;
      // تشغيل الصفحة التالية تلقائياً
      if (_currentPage < 604) {
        playPage(_currentPage + 1);
      }
    });
    
    // الاستماع لحالة التشغيل
    _player.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
    });
  }

  /// تحميل آخر جلسة محفوظة
  Future<void> loadLastSession() async {
    final prefs = await SharedPreferences.getInstance();
    _currentPage = prefs.getInt('currentPage') ?? 1;
    final reciterId = prefs.getString('currentReciter');
    _currentReciter = Reciters.byId(reciterId);
    _playbackSpeed = prefs.getDouble('playbackSpeed') ?? 1.0;
  }

  /// حفظ الجلسة الحالية
  Future<void> saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentPage', _currentPage);
    await prefs.setString('currentReciter', _currentReciter.id);
    await prefs.setDouble('playbackSpeed', _playbackSpeed);
  }

  /// تشغيل صفحة معينة
  Future<void> playPage(int page) async {
    if (page < 1 || page > 604) return;
    
    final url = buildPageAudioUrl(reciter: _currentReciter, page: page);
    try {
      await _player.stop();
      await _player.play(UrlSource(url));
      await _player.setPlaybackRate(_playbackSpeed);
      
      _currentPage = page;
      _isPlaying = true;
      
      await saveSession();
    } catch (e) {
      _isPlaying = false;
      rethrow;
    }
  }

  /// إيقاف/تشغيل
  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await _player.pause();
      _isPlaying = false;
    } else {
      await _player.resume();
      _isPlaying = true;
    }
  }

  /// التقديم/التأخير
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  /// تغيير القارئ
  Future<void> changeReciter(Reciter reciter) async {
    _currentReciter = reciter;
    await playPage(_currentPage);
  }

  /// تغيير سرعة التشغيل
  Future<void> changeSpeed(double speed) async {
    _playbackSpeed = speed;
    await _player.setPlaybackRate(speed);
    await saveSession();
  }

  /// الصفحة التالية
  Future<void> nextPage() async {
    if (_currentPage < 604) {
      await playPage(_currentPage + 1);
    }
  }

  /// الصفحة السابقة
  Future<void> previousPage() async {
    if (_currentPage > 1) {
      await playPage(_currentPage - 1);
    }
  }

  /// تنظيف الموارد
  void dispose() {
    _player.dispose();
  }
}
