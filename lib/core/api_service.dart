import 'package:flutter/foundation.dart';
import 'reciters_extra.dart';

class Reciter {
  final String id;
  final String name;
  final String baseUrl;
  final String imageUrl;
  final bool hasPages;

  const Reciter({
    required this.id,
    required this.name,
    required this.baseUrl,
    required this.imageUrl,
    this.hasPages = true,
  });
}

/// 📚 قائمة القراء الأساسية في التطبيق
class Reciters {
  static const List<Reciter> all = [
    Reciter(
      id: "Alafasy_128kbps",
      name: "مشاري راشد العفاسي",
      baseUrl: "https://everyayah.com/data/Alafasy_128kbps/PageMp3s/",
      imageUrl: "https://i.postimg.cc/MGTD6bwX/Misari-Rasid.jpg",
    ),
    Reciter(
      id: "Abdurrahmaan_As-Sudais_128kbps",
      name: "عبد الرحمن السديس",
      baseUrl:
          "https://everyayah.com/data/Abdurrahmaan_As-Sudais_128kbps/PageMp3s/",
      imageUrl: "https://i.postimg.cc/ryW9wwB9/aalsdys-1-jpg.png",
    ),
    Reciter(
      id: "Abdul_Basit_Mujawwad_128kbps",
      name: "عبد الباسط عبد الصمد (مجود)",
      baseUrl:
          "https://everyayah.com/data/Abdul_Basit_Mujawwad_128kbps/PageMp3s/",
      imageUrl:
          "https://i.postimg.cc/rmRNWVzC/swrt-shkhsyt-ʿbd-albast-ʿbd-alsmd.png",
    ),
    Reciter(
      id: "Maher_AlMuaiqly_64kbps",
      name: "ماهر المعيقلي",
      baseUrl: "https://everyayah.com/data/Maher_AlMuaiqly_64kbps/PageMp3s/",
      imageUrl: "https://i.postimg.cc/MGTD6bSh/Maher-Al-Mueaqly.png",
    ),
    Reciter(
      id: "Saood_ash-Shuraym_128kbps",
      name: "سعود الشريم",
      baseUrl: "https://everyayah.com/data/Saood_ash-Shuraym_128kbps/PageMp3s/",
      imageUrl: "https://i.postimg.cc/TP4cpL2Y/sʿwd-alshrym.jpg",
    ),
    Reciter(
      id: "Hani_Rifai_64kbps",
      name: "هاني الرفاعي",
      baseUrl: "https://everyayah.com/data/Hani_Rifai_64kbps/PageMp3s/",
      imageUrl: "https://i.postimg.cc/0jHXvWMy/hani-al-refayi.jpg",
    ),
    Reciter(
      id: "Abdullah_Basfar_64kbps",
      name: "عبد الله بصفر",
      baseUrl: "https://everyayah.com/data/Abdullah_Basfar_64kbps/PageMp3s/",
      imageUrl: "https://i.postimg.cc/ZYfM6Rf3/alshykh-ʿbdallh-bsfr.jpg",
    ),
    Reciter(
      id: "Ahmed_ibn_Ali_al-Ajmy_128kbps",
      name: "أحمد العجمي",
      baseUrl:
          "https://everyayah.com/data/Ahmed_ibn_Ali_al-Ajmy_128kbps/PageMp3s/",
      imageUrl: "https://i.postimg.cc/tJmvbSZC/download-3.jpg",
    ),
    Reciter(
      id: "Abu_Bakr_Ash-Shaatree_128kbps",
      name: "أبو بكر الشاطري",
      baseUrl:
          "https://everyayah.com/data/Abu_Bakr_Ash-Shaatree_128kbps/PageMp3s/",
      imageUrl: "https://i.postimg.cc/RCPDwFPH/abw-bkr-alshatry.jpg",
    ),
    Reciter(
      id: "Hudhaify_128kbps",
      name: "علي الحذيفي",
      baseUrl: "https://everyayah.com/data/Hudhaify_128kbps/PageMp3s/",
      imageUrl:
          "https://i.postimg.cc/7hQt4sGx/6e3e9830-f01d-4166-a9c5-abfa59090ba7.jpg",
    ),
  ];

  /// 🧩 دمج القائمة الأساسية + الإضافية من ملف reciters_extra.dart
  static List<Reciter> get allCombined => [...all, ...ExtraReciters.extra];

  /// 🔍 البحث عن القارئ حسب الـ ID
  static Reciter byId(String? id) {
    if (id == null) return all.first;
    try {
      return allCombined.firstWhere((r) => r.id == id);
    } catch (_) {
      return all.first;
    }
  }
}

/// 🧱 بناء رابط الصفحة الصوتية
String buildPageAudioUrl({
  required Reciter reciter,
  required int page,
}) {
  final padded = page.toString().padLeft(3, '0'); // 1 → 001
  return '${reciter.baseUrl}Page$padded.mp3';
}
