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

  @override
  String get devicesTabTitle => 'الأجهزة';

  @override
  String get searchDeviceHint => 'بحث عن جهاز...';

  @override
  String get allDevicesFilter => 'الكل';

  @override
  String get ungroupedFilter => 'بدون مجموعة';

  @override
  String get onlineStatus => 'متصل';

  @override
  String get offlineStatus => 'غير متصل';

  @override
  String get noDevicesMatched => 'لا توجد أجهزة مطابقة للفلتر';

  @override
  String get deviceOptionsTitle => 'خيارات الجهاز';

  @override
  String get groupsTabTitle => 'إدارة المجموعات';

  @override
  String get createGroup => 'إنشاء مجموعة';

  @override
  String get editGroup => 'تعديل المجموعة';

  @override
  String get deleteGroup => 'حذف المجموعة';

  @override
  String deleteGroupConfirm(Object groupName) {
    return 'هل تريد حذف \"$groupName\"؟ ماذا تفعل بالأجهزة الموجودة فيها؟';
  }

  @override
  String get moveDevicesToUngrouped => 'نقل لبدون مجموعة';

  @override
  String get deleteAllDevices => 'حذف الكل';

  @override
  String get groupNameLabel => 'اسم المجموعة';

  @override
  String get enterGroupNameHint => 'أدخل اسم المجموعة';

  @override
  String get emptyGroupMessage => 'لا توجد أجهزة في هذه المجموعة';

  @override
  String get saveChangesButton => 'حفظ التعديلات';

  @override
  String get createGroupSuccess => 'تم إنشاء المجموعة بنجاح';

  @override
  String get editGroupSuccess => 'تم تعديل المجموعة بنجاح';

  @override
  String get groupNotSupportedError =>
      'عذراً، الخادم الخاص بك لا يدعم إنشاء مجموعات مباشرة من التطبيق. يرجى إنشاء المجموعة من لوحة تحكم الويب.';

  @override
  String get emptyGroupNameValidation => 'الرجاء إدخال اسم المجموعة';

  @override
  String get showOnMap => 'عرض على الخريطة';

  @override
  String get showOnMapSubtitle => 'عرض جميع أجهزة المجموعة على الخريطة';

  @override
  String get editGroupSubtitle => 'تعديل الاسم وإدارة الأجهزة';

  @override
  String addDevicesCount(Object count) {
    return '$count أجهزة';
  }

  @override
  String get pressToCreateGroup => 'اضغط + لإنشاء مجموعة جديدة';

  @override
  String get historyTabTitle => 'السجل';

  @override
  String get searchVehicleHint => 'بحث باسم المركبة أو الرقم...';

  @override
  String get viewTripsButton => 'عرض الرحلات';

  @override
  String tripsCount(Object count) {
    return '$count رحلة';
  }

  @override
  String get refreshTrips => 'تحديث';

  @override
  String get loadingTrips => 'جاري تحميل الرحلات...';

  @override
  String get selectVehicleTitle => 'اختر مركبة';

  @override
  String get selectVehicleSubtitle => 'اختر مركبة من الأعلى لعرض رحلاتها';

  @override
  String get noTripsTitle => 'لا توجد رحلات';

  @override
  String get noTripsSubtitle => 'لم يتم العثور على رحلات في الفترة المحددة';

  @override
  String get removeFilters => 'إزالة الفلاتر';

  @override
  String get noVehiclesMatchedSearch => 'لا توجد مركبات مطابقة للبحث';

  @override
  String get totalLabel => 'إجمالي';

  @override
  String get movingStatus => 'يتحرك';

  @override
  String get tryChangingFilters => 'جرّب تغيير خيارات البحث أو الفلتر';

  @override
  String get checkNetworkConnection => 'تحقق من اتصالك بالشبكة';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get idleStatus => 'خمول';

  @override
  String get noGpsSignal => 'لا إشارة GPS';

  @override
  String get mapLabel => 'الخريطة';

  @override
  String get sendCommand => 'إرسال أمر';

  @override
  String get sendSmsCommand => 'أمر SMS';

  @override
  String get editDevice => 'تعديل الجهاز';

  @override
  String get unpin => 'إلغاء التثبيت';

  @override
  String get pinToTop => 'تثبيت في الأعلى';

  @override
  String lastConnectionLabel(Object time) {
    return 'آخر اتصال: $time';
  }

  @override
  String get km => 'كم';

  @override
  String get kmh => 'كم/س';

  @override
  String selectedDevicesCount(Object count) {
    return 'محدد: $count أجهزة';
  }

  @override
  String activeDevicesCount(Object count) {
    return '| $count نشط';
  }

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get clearAll => 'إلغاء الكل';

  @override
  String get searchDevice => 'ابحث عن جهاز...';

  @override
  String get cancel => 'إلغاء';

  @override
  String get groupsLoadError => 'حدث خطأ أثناء تحميل المجموعات';

  @override
  String get noGroupsYet => 'لا توجد مجموعات بعد';

  @override
  String get todayPreset => 'اليوم';

  @override
  String get yesterdayPreset => 'أمس';

  @override
  String get weekPreset => 'أسبوع';

  @override
  String get monthPreset => 'شهر';

  @override
  String get customPreset => 'مخصص';

  @override
  String get longTrip => '🛣️ طويلة';

  @override
  String get shortTrip => '📍 قصيرة';

  @override
  String get stops => '🛑 توقفات';

  @override
  String get fastTrip => '⚡ سريعة';

  @override
  String get alerts => '⚠️ تنبيهات';

  @override
  String get night => '🌙 ليلية';

  @override
  String get distanceLabel => 'المسافة';

  @override
  String get durationLabel => 'المدة';

  @override
  String get avgSpeedLabel => 'م.السرعة';

  @override
  String get maxSpeedLabel => 'أعلى';

  @override
  String get overspeed => 'تجاوز سرعة';

  @override
  String get normalTrip => 'عادية';

  @override
  String stopsCount(Object count) {
    return '$count توقفات';
  }

  @override
  String pointsCount(Object count) {
    return '$count نقطة';
  }

  @override
  String get statsTab => 'الإحصائيات';

  @override
  String get timelineTab => 'الخط الزمني';

  @override
  String get stopsTab => 'التوقفات';

  @override
  String get noGpsPoints => 'لا توجد نقاط GPS لهذه الرحلة';

  @override
  String get startPoint => 'البداية';

  @override
  String get endPoint => 'النهاية';

  @override
  String stopIndex(Object index) {
    return 'توقف $index';
  }

  @override
  String get timeTitle => 'الوقت';

  @override
  String get altitudeTitle => 'الارتفاع';

  @override
  String get meterUnit => 'م';

  @override
  String get speedLabel => 'السرعة';

  @override
  String get noStopsTitle => 'لا توجد توقفات';

  @override
  String get noStopsSubtitle => 'الرحلة كانت متواصلة بدون توقف';

  @override
  String get noEventsTitle => 'لا توجد أحداث';

  @override
  String get avgSpeedCard => 'متوسط السرعة';

  @override
  String get maxSpeedCard => 'أعلى سرعة';

  @override
  String get stopsCountCard => 'عدد التوقفات';

  @override
  String get stopTimeCard => 'وقت التوقف';

  @override
  String get movingTimeCard => 'وقت الحركة';

  @override
  String get pointsCard => 'النقاط';

  @override
  String get movingStopRatio => 'نسبة الحركة / التوقف';

  @override
  String get tripEfficiency => 'كفاءة الرحلة';

  @override
  String get efficiencyExcellent => 'ممتازة';

  @override
  String get efficiencyGood => 'جيدة';

  @override
  String get efficiencyAverage => 'متوسطة';

  @override
  String get efficiencyPoor => 'ضعيفة';

  @override
  String get notAvailable => 'غير متاح';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(Object count) {
    return 'منذ $count د';
  }

  @override
  String hoursAgo(Object count) {
    return 'منذ $count س';
  }

  @override
  String daysAgo(Object count) {
    return 'منذ $count يوم';
  }

  @override
  String get optionsTab => 'الخيارات';

  @override
  String get groupsTab => 'المجموعات';

  @override
  String get devicesTab => 'الأجهزة';

  @override
  String quickStatsTotal(Object count) {
    return 'إجمالي $count';
  }

  @override
  String quickStatsOnline(Object count) {
    return 'متصل $count';
  }

  @override
  String quickStatsOffline(Object count) {
    return 'غير متصل $count';
  }

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get noResults => 'لا توجد نتائج';

  @override
  String get noDevices => 'لا توجد أجهزة';

  @override
  String get historyLabel => 'السجل';

  @override
  String get sendCommandDesc => 'أوامر التحكم بالجهاز';

  @override
  String get sendSms => 'أمر SMS';

  @override
  String get sendSmsDesc => 'إرسال أمر عبر رسالة نصية';

  @override
  String get editDeviceDesc => 'تغيير الاسم أو الإعدادات';

  @override
  String get deleteDevice => 'حذف الجهاز';

  @override
  String get deleteDeviceDesc => 'حذف نهائي';

  @override
  String get groupsLoadFailed => 'فشل تحميل المجموعات';

  @override
  String get noGroups => 'لا توجد مجموعات';

  @override
  String get manageGroups => 'إدارة المجموعات';

  @override
  String get addNewDevice => 'إضافة جهاز جديد';

  @override
  String get tools => 'الأدوات';

  @override
  String get setup => 'الإعداد';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get settingsSaved => 'تم حفظ الإعدادات بنجاح';

  @override
  String get vehiclesTab => 'المركبات';

  @override
  String get smsTab => 'SMS';

  @override
  String get unitsSection => 'الوحدات';

  @override
  String get distanceMeasure => 'قياس المسافة';

  @override
  String get distanceUnitTitle => 'وحدة المسافة';

  @override
  String get capacityLabel => 'الحجم';

  @override
  String get capacityUnitTitle => 'وحدة الحجم';

  @override
  String get altitudeLabel => 'الارتفاع';

  @override
  String get altitudeUnitTitle => 'وحدة الارتفاع';

  @override
  String get timeSection => 'الوقت';

  @override
  String get weekDays => 'أيام الأسبوع';

  @override
  String get startOfWeekTitle => 'بداية الأسبوع';

  @override
  String get timezoneLabel => 'المنطقة الزمنية';

  @override
  String get daylightSavingLabel => 'التوقيت الصيفي';

  @override
  String get languageLabel => 'اللغة';

  @override
  String get fleetManagement => 'إدارة الأسطول';

  @override
  String get vehicleGroups => 'مجموعة المركبات';

  @override
  String get driversList => 'قائمة السائقين';

  @override
  String get driversTitle => 'السائقين';

  @override
  String get eventsLabel => 'الأحداث';

  @override
  String get templatesSection => 'القوالب';

  @override
  String get smsTemplates => 'قوالب SMS';

  @override
  String get gprsTemplates => 'قوالب GPRS';

  @override
  String get smsGatewaySection => 'بوابة الرسائل النصية';

  @override
  String get enableSms => 'تمكين الرسائل النصية';

  @override
  String get gatewayTypeLabel => 'نوع البوابة';

  @override
  String get selectLanguageTitle => 'اختر اللغة';

  @override
  String get noDataAvailable => 'لا توجد بيانات';

  @override
  String get closeButton => 'إغلاق';

  @override
  String get fetchingFromServer => 'استدعاء من السيرفر...';

  @override
  String get fetching => 'استدعاء...';
}
