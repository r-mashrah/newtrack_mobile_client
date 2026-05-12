class AppStrings {
  // عام
  static const String appName = 'NewTrack Mobile Client';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'تطبيق تتبع وإدارة المركبات';

  // تسجيل الدخول
  static const String loginTitle = 'تسجيل الدخول';
  static const String loginSubtitle = 'أدخل بياناتك للوصول إلى النظام';
  static const String usernameHint = 'اسم المستخدم';
  static const String passwordHint = 'كلمة المرور';
  static const String rememberMe = 'تذكرني';
  static const String forgotPassword = 'نسيت كلمة المرور؟';
  static const String loginButton = 'تسجيل الدخول';

  // أسماء الخوادم
  static const String productionServer = 'الإنتاج';
  static const String demoServer = 'العرض التوضيحي';
  static const String developmentServer = 'التطوير';

  // أسماء الأجهزة الوهمية
  static const List<String> mockDeviceNames = [
    'Toyota Camry - صالح',
    'Honda Civic - أحمد',
    'Ford Ranger - محمد',
    'Nissan Patrol - خالد',
    'Hyundai Elantra - يوسف',
  ];

  // حالات الأجهزة
  static const String statusOnline = 'متصل';
  static const String statusOffline = 'غير متصل';
  static const String statusMoving = 'متحرك';
  static const String statusStopped = 'متوقف';
  static const String statusParked = 'مركون';

  // رسائل الخطأ
  static const String errorEmptyUsername = 'الرجاء إدخال اسم المستخدم';
  static const String errorEmptyPassword = 'الرجاء إدخال كلمة المرور';
  static const String errorShortPassword = 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
  static const String errorInvalidCredentials = 'اسم المستخدم أو كلمة المرور غير صحيحة';
  static const String errorConnectionFailed = 'فشل الاتصال بالخادم';

  // أزرار وأوامر
  static const String ok = 'موافق';
  static const String cancel = 'إلغاء';
  static const String confirm = 'تأكيد';
  static const String logout = 'تسجيل الخروج';
  static const String logoutConfirm = 'هل أنت متأكد من أنك تريد تسجيل الخروج؟';

  // عناوين الشاشات
  static const String mainMapTitle = 'خريطة التتبع';
  static const String devicesTitle = 'الأجهزة';
  static const String historyTitle = 'سجل المسار';
  static const String alertsTitle = 'التنبيهات';
  static const String toolsTitle = 'الأدوات';
  static const String settingsTitle = 'الإعدادات';

  // إحصائيات
  static const String totalDevices = 'الكل';
  static const String onlineDevices = 'متصل';
  static const String movingDevices = 'متحرك';
  static const String stoppedDevices = 'متوقف';

  // معلومات الجهاز
  static const String location = 'الموقع';
  static const String speed = 'السرعة';
  static const String lastUpdate = 'آخر تحديث';
  static const String driver = 'السائق';
  static const String plateNumber = 'رقم اللوحة';
  static const String deviceHistory = 'سجل الجهاز';
  static const String deviceDetails = 'تفاصيل الجهاز';

  // الإشعارات
  static const String notificationsTitle = 'الإشعارات';
  static const String clearAll = 'مسح الكل';
  static const String unreadNotifications = 'إشعارات غير مقروءة';

  // أنواع التنبيهات
  static const String alertGeofence = 'دخول منطقة محظورة';
  static const String alertOverspeed = 'تجاوز السرعة';
  static const String alertOffline = 'انقطاع الاتصال';
  static const String alertIgnition = 'تشغيل المحرك';
  static const String alertBattery = 'انخفاض البطارية';

  // واجهة إضافة جهاز
  static const String objectName = 'اسم الجهاز';
  static const String objectImei = 'رقم IMEI';
  static const String hasExpirationDate = 'يحتوي على تاريخ انتهاء';
  static const String markerImage = 'صورة العلامة';
  static const String group = 'المجموعة';
  static const String groupUngrouped = 'غير مجمعة';
  static const String simNumber = 'رقم الشريحة';
  static const String deviceModel = 'موديل الجهاز';
  static const String vin = 'رقم VIN';
  static const String registrationAssetNumber = 'رقم التسجيل/الأصل';
  static const String objectOwnerManager = 'مالك/مدير الجهاز';
  static const String measurementI100km = 'القياس ل/100كم';
  static const String kmPer1Liter = 'كم لكل 1 لتر';
  static const String costFor1Liter = 'تكلفة 1 لتر';
  static const String timeAdjustment = 'تعديل الوقت';
  static const String additionalNotes = 'ملاحظات إضافية';
  static const String minimalMovingSpeed = 'الحد الأدنى لسرعة الحركة';
  static const String minimalFuelDifferenceFillings = 'الحد الأدنى لفرق الوقود للكشف عن التعبئة';
  static const String minimalFuelDifferenceThefts = 'الحد الأدنى لفرق الوقود للكشف عن السرقة';
  static const String tailColor = 'لون الذيل';
  static const String tailLength = 'طول الذيل';

  // واجهة الإعدادات
  static const String units = 'الوحدات';
  static const String unitsOfDistance = 'وحدات المسافة';
  static const String kilometer = 'كيلومتر';
  static const String unitsOfCapacity = 'وحدات السعة';
  static const String liter = 'لتر';
  static const String unitsOfAltitude = 'وحدات الارتفاع';
  static const String meter = 'متر';
  static const String time = 'الوقت';
  static const String weekdays = 'أيام الأسبوع';
  static const String monday = 'الاثنين';
  static const String timezone = 'المنطقة الزمنية';
  static const String daylightSavingTime = 'التوقيت الصيفي';
  static const String configure = 'تكوين';
  static const String language = 'اللغة';
  static const String objects = 'الأجهزة';
  static const String objectGroups = 'مجموعات الأجهزة';
  static const String events = 'الأحداث';
  static const String templates = 'القوالب';
  static const String smsCommands = 'أوامر الرسائل القصيرة';
  static const String gprsCommands = 'أوامر GPRS';
  static const String smsGateway = 'بوابة الرسائل القصيرة';

  // واجهة الأدوات
  static const String notificationsSection = 'قسم الإشعارات';
  static const String editRemoveAddAlerts = 'تعديل، إزالة، أو إضافة تنبيهات';
  static const String tasksSection = 'قسم المهام';
  static const String tasks = 'المهام';
  static const String editRemoveAddTasks = 'تعديل، إزالة، أو إضافة مهام';
  static const String mapObjects = 'كائنات الخريطة';
  static const String geofencing = 'تحديد المناطق الجغرافية';
  static const String poi = 'نقاط الاهتمام';
  static const String addOrRemoveMapObjects = 'إضافة أو إزالة كائنات الخريطة';
  static const String mapUtilities = 'أدوات الخريطة المساعدة';
  static const String ruler = 'المسطرة';
  static const String showPoint = 'إظهار النقطة';
  static const String commands = 'الأوامر';
  static const String sendCommandsToDevice = 'إرسال أوامر إلى الجهاز';

  static String toolsForDistanceCalculations='أدوات لحساب المسافات';

  static String alerts='تنبيهات';

  static String drivers='السائقون';
}
