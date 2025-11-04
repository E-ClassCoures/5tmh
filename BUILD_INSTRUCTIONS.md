# تعليمات البناء - الختمة السمعية

## 📋 المتطلبات الأساسية

### 1. تثبيت Flutter

#### Windows
```bash
# تحميل Flutter SDK من الموقع الرسمي
https://docs.flutter.dev/get-started/install/windows

# إضافة Flutter إلى PATH
# System Properties > Environment Variables > Path > Add: C:\flutter\bin
```

#### macOS
```bash
# تحميل Flutter SDK
cd ~
git clone https://github.com/flutter/flutter.git -b stable

# إضافة إلى PATH
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.zshrc
source ~/.zshrc
```

#### Linux
```bash
# تحميل Flutter SDK
cd ~
git clone https://github.com/flutter/flutter.git -b stable

# إضافة إلى PATH
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc
```

### 2. التحقق من التثبيت
```bash
flutter doctor
```

## 🔧 إعداد المشروع

### 1. فك ضغط المشروع
```bash
tar -xzf a5tmy-complete.tar.gz
cd a5tmy
```

### 2. تثبيت الحزم
```bash
flutter pub get
```

### 3. التحقق من عدم وجود أخطاء
```bash
flutter analyze
```

## 📱 البناء للأندرويد

### الطريقة السريعة (APK للتجربة)

```bash
flutter build apk --release
```

الملف سيكون في: `build/app/outputs/flutter-apk/app-release.apk`

### الطريقة الاحترافية (للنشر على Google Play)

#### 1. إنشاء Keystore
```bash
keytool -genkey -v -keystore ~/a5tmy-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias a5tmy
```

سيطلب منك:
- كلمة مرور للـ keystore
- كلمة مرور للـ key
- معلومات شخصية (الاسم، المنظمة، إلخ)

#### 2. إنشاء ملف `android/key.properties`
```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=a5tmy
storeFile=/path/to/a5tmy-key.jks
```

#### 3. تعديل `android/app/build.gradle`

أضف قبل `android {`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}
```

داخل `android {` أضف:
```gradle
signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword keystoreProperties['storePassword']
    }
}

buildTypes {
    release {
        signingConfig signingConfigs.release
        // ... باقي الإعدادات
    }
}
```

#### 4. بناء App Bundle
```bash
flutter build appbundle --release
```

الملف سيكون في: `build/app/outputs/bundle/release/app-release.aab`

## 🍎 البناء لـ iOS (macOS فقط)

### 1. فتح المشروع في Xcode
```bash
open ios/Runner.xcworkspace
```

### 2. في Xcode:
1. اختر Runner من الشريط الجانبي
2. في تبويب "Signing & Capabilities":
   - اختر Team الخاص بك
   - تأكد من Bundle Identifier فريد (مثل: `com.yourname.a5tmy`)

### 3. بناء للجهاز
```bash
flutter build ios --release
```

### 4. الأرشفة والنشر
في Xcode:
- Product > Archive
- بعد الأرشفة، اضغط "Distribute App"
- اختر "App Store Connect"
- اتبع الخطوات

## 🧪 الاختبار

### تشغيل على محاكي/جهاز
```bash
# عرض الأجهزة المتصلة
flutter devices

# تشغيل على جهاز محدد
flutter run -d <device_id>

# تشغيل في وضع Release
flutter run --release
```

### اختبار APK المبني
```bash
# تثبيت على جهاز متصل
adb install build/app/outputs/flutter-apk/app-release.apk

# أو باستخدام Flutter
flutter install
```

## 🐛 حل المشاكل

### مشكلة: Gradle build failed
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

### مشكلة: SDK not found
```bash
# تحديد مسار Android SDK
flutter config --android-sdk /path/to/android/sdk
```

### مشكلة: Java version conflict
```bash
# تثبيت Java 17
# Windows: تحميل من https://adoptium.net/
# macOS: brew install openjdk@17
# Linux: sudo apt install openjdk-17-jdk

# تحديد مسار Java
flutter config --jdk-dir=/path/to/java17
```

### مشكلة: CocoaPods (iOS)
```bash
cd ios
pod install
cd ..
```

## 📊 تحسين حجم التطبيق

### تقليل حجم APK
```bash
# بناء APK منفصل لكل معمارية
flutter build apk --split-per-abi
```

سينتج 3 ملفات:
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM)
- `app-x86_64-release.apk` (64-bit x86)

### استخدام App Bundle (موصى به)
```bash
flutter build appbundle --release
```

Google Play سيقوم بتوزيع الحجم المناسب لكل جهاز تلقائياً.

## 🔍 فحص الجودة

### تحليل الكود
```bash
flutter analyze
```

### اختبار الأداء
```bash
flutter run --profile
```

### فحص الحجم
```bash
flutter build apk --analyze-size
```

## 📦 الملفات المهمة

- `pubspec.yaml` - الحزم والأصول
- `android/app/build.gradle` - إعدادات Android
- `android/app/src/main/AndroidManifest.xml` - صلاحيات Android
- `ios/Runner/Info.plist` - إعدادات iOS
- `lib/main.dart` - نقطة الدخول

## ✅ قائمة التحقق قبل النشر

- [ ] اختبار التطبيق على أجهزة حقيقية
- [ ] التحقق من جميع الأذونات المطلوبة
- [ ] تحديث رقم الإصدار في `pubspec.yaml`
- [ ] إضافة أيقونة التطبيق
- [ ] إضافة شاشة البداية (Splash Screen)
- [ ] اختبار على شبكات بطيئة
- [ ] التحقق من دعم RTL
- [ ] مراجعة سياسة الخصوصية
- [ ] إنشاء لقطات شاشة للمتاجر
- [ ] كتابة وصف التطبيق

## 📞 الدعم

إذا واجهت أي مشاكل:
1. تحقق من `flutter doctor`
2. نظف المشروع: `flutter clean`
3. احذف `pubspec.lock` وأعد `flutter pub get`
4. تحقق من سجلات الأخطاء: `flutter logs`

---

**بالتوفيق في نشر تطبيقك! 🚀**
