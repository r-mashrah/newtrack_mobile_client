// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => ' نيو تراك';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get loginSubtitle => 'أدخل بياناتك للوصول إلى النظام';

  @override
  String get usernameLabel => 'اسم المستخدم';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get validationUsernameRequired => 'الرجاء إدخال اسم المستخدم';

  @override
  String get validationPasswordRequired => 'الرجاء إدخال كلمة المرور';

  @override
  String get validationPasswordLength =>
      'كلمة المرور يجب أن تكون 6 أحرف على الأقل';

  @override
  String get demoCredentials => 'بيانات تسجيل الدخول التجريبية:';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get password => 'كلمة المرور';

  @override
  String get contactAdminForPasswordReset =>
      'تواصل مع المسؤول لاستعادة كلمة المرور';

  @override
  String get errorPrefix => 'خطأ';

  @override
  String get serverSelection => 'اختيار الخادم';

  @override
  String get productionServer => 'الإنتاج';

  @override
  String get stagingServer => 'التجريبي';

  @override
  String get developmentServer => 'التطوير';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get themeMode => 'وضع المظهر';

  @override
  String get systemTheme => 'النظام';

  @override
  String get lightTheme => 'فاتح';

  @override
  String get darkTheme => 'داكن';

  @override
  String get primaryColor => 'اللون الأساسي';

  @override
  String get language => 'اللغة';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageArabic => 'العربية';

  @override
  String get colorSettingsTitle => 'إعدادات الألوان';

  @override
  String get primaryColorLabel => 'اللون الرئيسي';

  @override
  String get secondaryColorLabel => 'اللون الثانوي';

  @override
  String get accentColorLabel => 'اللون الإضافي';

  @override
  String get themeModeSectionTitle => 'وضع الثيم';

  @override
  String get selectThemeMode => 'اختر وضع الثيم';

  @override
  String get presetColorSchemes => 'مجموعات ألوان مسبقة';

  @override
  String get resetButton => 'إعادة تعيين';

  @override
  String get saveAndCloseButton => 'حفظ وإغلاق';

  @override
  String get resetSuccessMessage => 'تم إعادة تعيين الإعدادات الافتراضية';

  @override
  String get tapToChangeColor => 'اضغط لتغيير اللون';

  @override
  String appliedPreset(Object presetName) {
    return 'تم تطبيق: $presetName';
  }

  @override
  String get presetGreenDefault => 'أخضر (افتراضي)';

  @override
  String get presetBlue => 'أزرق';

  @override
  String get presetOrange => 'برتقالي';

  @override
  String get presetPurple => 'بنفسجي';

  @override
  String get addDeviceTitle => 'إضافة جهاز جديد';

  @override
  String get saveDeviceButton => 'حفظ الجهاز';

  @override
  String get mainTab => 'الرئيسية';

  @override
  String get advancedTab => 'متقدم';

  @override
  String get accuracyTab => 'الدقة';

  @override
  String get tailTab => 'الذيل';

  @override
  String get objectName => 'اسم الجهاز';

  @override
  String get objectImei => 'IMEI';

  @override
  String get hasExpirationDate => 'يحتوي على تاريخ انتهاء';

  @override
  String get markerImage => 'صورة العلامة';

  @override
  String get group => 'المجموعة';

  @override
  String get groupUngrouped => 'غير مجمّع';

  @override
  String get simNumber => 'رقم الشريحة';

  @override
  String get deviceModel => 'موديل الجهاز';

  @override
  String get plateNumber => 'رقم اللوحة';

  @override
  String get vin => 'VIN';

  @override
  String get registrationAssetNumber => 'رقم التسجيل/الأصل';

  @override
  String get objectOwnerManager => 'مالك/مدير الجهاز';

  @override
  String get measurementI100km => 'القياس (لتر/100 كم)';

  @override
  String get kmPer1Liter => 'كم لكل 1 لتر';

  @override
  String get costFor1Liter => 'تكلفة 1 لتر';

  @override
  String get timeAdjustment => 'تعديل الوقت';

  @override
  String get additionalNotes => 'ملاحظات إضافية';

  @override
  String get minimalMovingSpeed => 'الحد الأدنى لسرعة الحركة (كم/س)';

  @override
  String get minimalFuelDifferenceFillings =>
      'الحد الأدنى لفرق الوقود لاكتشاف التعبئة (لتر)';

  @override
  String get minimalFuelDifferenceThefts =>
      'الحد الأدنى لفرق الوقود لاكتشاف السرقة (لتر)';

  @override
  String get tailColor => 'لون الذيل';

  @override
  String get tailLength => 'طول الذيل (نقاط)';

  @override
  String get deviceColors => 'ألوان حالة الجهاز';

  @override
  String get movingColor => 'متحرك';

  @override
  String get stoppedColor => 'متوقف';

  @override
  String get disconnectedColor => 'مقطوع الاتصال';

  @override
  String get idleColor => 'خمول المحرك';

  @override
  String get selectColor => 'اختر اللون';

  @override
  String get selectGroup => 'اختر المجموعة';

  @override
  String get selectMarkerImage => 'اختر صورة العلامة';

  @override
  String get deviceDetailsTitle => 'تفاصيل الجهاز';

  @override
  String get deviceDetailsImei => 'IMEI';

  @override
  String get deviceDetailsPlate => 'رقم اللوحة';

  @override
  String get deviceDetailsSim => 'رقم الشريحة';

  @override
  String get deviceDetailsModel => 'الموديل';

  @override
  String get deviceDetailsGroup => 'المجموعة';

  @override
  String get deviceDetailsTailLength => 'طول الذيل';

  @override
  String get deviceDetailsTailColor => 'لون الذيل';

  @override
  String get deviceDetailsMarker => 'صورة العلامة';

  @override
  String get deviceDetailsMovingColor => 'لون الحركة';

  @override
  String get deviceDetailsStoppedColor => 'لون التوقف';

  @override
  String get deviceDetailsDisconnectedColor => 'لون قطع الاتصال';

  @override
  String get deviceDetailsIdleColor => 'لون الخمول';
}
