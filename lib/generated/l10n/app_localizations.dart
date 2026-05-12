import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'NewTrack Mobile Client'**
  String get appName;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your credentials to access the system'**
  String get loginSubtitle;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @validationUsernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your username'**
  String get validationUsernameRequired;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get validationPasswordLength;

  /// No description provided for @demoCredentials.
  ///
  /// In en, this message translates to:
  /// **'Demo Credentials:'**
  String get demoCredentials;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @contactAdminForPasswordReset.
  ///
  /// In en, this message translates to:
  /// **'Contact the administrator to reset your password'**
  String get contactAdminForPasswordReset;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorPrefix;

  /// No description provided for @serverSelection.
  ///
  /// In en, this message translates to:
  /// **'Server Selection'**
  String get serverSelection;

  /// No description provided for @productionServer.
  ///
  /// In en, this message translates to:
  /// **'Production'**
  String get productionServer;

  /// No description provided for @stagingServer.
  ///
  /// In en, this message translates to:
  /// **'Staging'**
  String get stagingServer;

  /// No description provided for @developmentServer.
  ///
  /// In en, this message translates to:
  /// **'Development'**
  String get developmentServer;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @primaryColor.
  ///
  /// In en, this message translates to:
  /// **'Primary Color'**
  String get primaryColor;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @colorSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Color Settings'**
  String get colorSettingsTitle;

  /// No description provided for @primaryColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Primary Color'**
  String get primaryColorLabel;

  /// No description provided for @secondaryColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Secondary Color'**
  String get secondaryColorLabel;

  /// No description provided for @accentColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Accent Color'**
  String get accentColorLabel;

  /// No description provided for @themeModeSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeModeSectionTitle;

  /// No description provided for @selectThemeMode.
  ///
  /// In en, this message translates to:
  /// **'Select Theme Mode'**
  String get selectThemeMode;

  /// No description provided for @presetColorSchemes.
  ///
  /// In en, this message translates to:
  /// **'Preset Color Schemes'**
  String get presetColorSchemes;

  /// No description provided for @resetButton.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetButton;

  /// No description provided for @saveAndCloseButton.
  ///
  /// In en, this message translates to:
  /// **'Save and Close'**
  String get saveAndCloseButton;

  /// No description provided for @resetSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Settings reset to defaults'**
  String get resetSuccessMessage;

  /// No description provided for @tapToChangeColor.
  ///
  /// In en, this message translates to:
  /// **'Tap to change color'**
  String get tapToChangeColor;

  /// No description provided for @appliedPreset.
  ///
  /// In en, this message translates to:
  /// **'Applied: {presetName}'**
  String appliedPreset(Object presetName);

  /// No description provided for @presetGreenDefault.
  ///
  /// In en, this message translates to:
  /// **'Green (Default)'**
  String get presetGreenDefault;

  /// No description provided for @presetBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get presetBlue;

  /// No description provided for @presetOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get presetOrange;

  /// No description provided for @presetPurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get presetPurple;

  /// No description provided for @addDeviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Device'**
  String get addDeviceTitle;

  /// No description provided for @saveDeviceButton.
  ///
  /// In en, this message translates to:
  /// **'Save Device'**
  String get saveDeviceButton;

  /// No description provided for @mainTab.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get mainTab;

  /// No description provided for @advancedTab.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advancedTab;

  /// No description provided for @accuracyTab.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get accuracyTab;

  /// No description provided for @tailTab.
  ///
  /// In en, this message translates to:
  /// **'Tail'**
  String get tailTab;

  /// No description provided for @objectName.
  ///
  /// In en, this message translates to:
  /// **'Object Name'**
  String get objectName;

  /// No description provided for @objectImei.
  ///
  /// In en, this message translates to:
  /// **'IMEI'**
  String get objectImei;

  /// No description provided for @hasExpirationDate.
  ///
  /// In en, this message translates to:
  /// **'Has Expiration Date'**
  String get hasExpirationDate;

  /// No description provided for @markerImage.
  ///
  /// In en, this message translates to:
  /// **'Marker Image'**
  String get markerImage;

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @groupUngrouped.
  ///
  /// In en, this message translates to:
  /// **'Ungrouped'**
  String get groupUngrouped;

  /// No description provided for @simNumber.
  ///
  /// In en, this message translates to:
  /// **'SIM Number'**
  String get simNumber;

  /// No description provided for @deviceModel.
  ///
  /// In en, this message translates to:
  /// **'Device Model'**
  String get deviceModel;

  /// No description provided for @plateNumber.
  ///
  /// In en, this message translates to:
  /// **'Plate Number'**
  String get plateNumber;

  /// No description provided for @vin.
  ///
  /// In en, this message translates to:
  /// **'VIN'**
  String get vin;

  /// No description provided for @registrationAssetNumber.
  ///
  /// In en, this message translates to:
  /// **'Registration/Asset Number'**
  String get registrationAssetNumber;

  /// No description provided for @objectOwnerManager.
  ///
  /// In en, this message translates to:
  /// **'Object Owner/Manager'**
  String get objectOwnerManager;

  /// No description provided for @measurementI100km.
  ///
  /// In en, this message translates to:
  /// **'Measurement (l/100km)'**
  String get measurementI100km;

  /// No description provided for @kmPer1Liter.
  ///
  /// In en, this message translates to:
  /// **'Km per 1 Liter'**
  String get kmPer1Liter;

  /// No description provided for @costFor1Liter.
  ///
  /// In en, this message translates to:
  /// **'Cost for 1 Liter'**
  String get costFor1Liter;

  /// No description provided for @timeAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Time Adjustment'**
  String get timeAdjustment;

  /// No description provided for @additionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes'**
  String get additionalNotes;

  /// No description provided for @minimalMovingSpeed.
  ///
  /// In en, this message translates to:
  /// **'Minimal Moving Speed (km/h)'**
  String get minimalMovingSpeed;

  /// No description provided for @minimalFuelDifferenceFillings.
  ///
  /// In en, this message translates to:
  /// **'Minimal Fuel Difference to Detect Fuel Fillings (L)'**
  String get minimalFuelDifferenceFillings;

  /// No description provided for @minimalFuelDifferenceThefts.
  ///
  /// In en, this message translates to:
  /// **'Minimal Fuel Difference to Detect Fuel Thefts (L)'**
  String get minimalFuelDifferenceThefts;

  /// No description provided for @tailColor.
  ///
  /// In en, this message translates to:
  /// **'Tail Color'**
  String get tailColor;

  /// No description provided for @tailLength.
  ///
  /// In en, this message translates to:
  /// **'Tail Length (Points)'**
  String get tailLength;

  /// No description provided for @deviceColors.
  ///
  /// In en, this message translates to:
  /// **'Device Status Colors'**
  String get deviceColors;

  /// No description provided for @movingColor.
  ///
  /// In en, this message translates to:
  /// **'Moving'**
  String get movingColor;

  /// No description provided for @stoppedColor.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get stoppedColor;

  /// No description provided for @disconnectedColor.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnectedColor;

  /// No description provided for @idleColor.
  ///
  /// In en, this message translates to:
  /// **'Engine Idle'**
  String get idleColor;

  /// No description provided for @selectColor.
  ///
  /// In en, this message translates to:
  /// **'Select Color'**
  String get selectColor;

  /// No description provided for @selectGroup.
  ///
  /// In en, this message translates to:
  /// **'Select Group'**
  String get selectGroup;

  /// No description provided for @selectMarkerImage.
  ///
  /// In en, this message translates to:
  /// **'Select Marker Image'**
  String get selectMarkerImage;

  /// No description provided for @deviceDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Device Details'**
  String get deviceDetailsTitle;

  /// No description provided for @deviceDetailsImei.
  ///
  /// In en, this message translates to:
  /// **'IMEI'**
  String get deviceDetailsImei;

  /// No description provided for @deviceDetailsPlate.
  ///
  /// In en, this message translates to:
  /// **'Plate Number'**
  String get deviceDetailsPlate;

  /// No description provided for @deviceDetailsSim.
  ///
  /// In en, this message translates to:
  /// **'SIM Number'**
  String get deviceDetailsSim;

  /// No description provided for @deviceDetailsModel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get deviceDetailsModel;

  /// No description provided for @deviceDetailsGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get deviceDetailsGroup;

  /// No description provided for @deviceDetailsTailLength.
  ///
  /// In en, this message translates to:
  /// **'Tail Length'**
  String get deviceDetailsTailLength;

  /// No description provided for @deviceDetailsTailColor.
  ///
  /// In en, this message translates to:
  /// **'Tail Color'**
  String get deviceDetailsTailColor;

  /// No description provided for @deviceDetailsMarker.
  ///
  /// In en, this message translates to:
  /// **'Marker Image'**
  String get deviceDetailsMarker;

  /// No description provided for @deviceDetailsMovingColor.
  ///
  /// In en, this message translates to:
  /// **'Moving Color'**
  String get deviceDetailsMovingColor;

  /// No description provided for @deviceDetailsStoppedColor.
  ///
  /// In en, this message translates to:
  /// **'Stopped Color'**
  String get deviceDetailsStoppedColor;

  /// No description provided for @deviceDetailsDisconnectedColor.
  ///
  /// In en, this message translates to:
  /// **'Disconnected Color'**
  String get deviceDetailsDisconnectedColor;

  /// No description provided for @deviceDetailsIdleColor.
  ///
  /// In en, this message translates to:
  /// **'Idle Color'**
  String get deviceDetailsIdleColor;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
