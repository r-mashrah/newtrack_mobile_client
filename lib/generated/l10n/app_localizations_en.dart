// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'NewTrack Mobile Client';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginSubtitle => 'Enter your credentials to access the system';

  @override
  String get usernameLabel => 'Username';

  @override
  String get passwordLabel => 'Password';

  @override
  String get rememberMe => 'Remember Me';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get loginButton => 'Login';

  @override
  String get validationUsernameRequired => 'Please enter your username';

  @override
  String get validationPasswordRequired => 'Please enter your password';

  @override
  String get validationPasswordLength =>
      'Password must be at least 6 characters';

  @override
  String get demoCredentials => 'Demo Credentials:';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get contactAdminForPasswordReset =>
      'Contact the administrator to reset your password';

  @override
  String get errorPrefix => 'Error';

  @override
  String get serverSelection => 'Server Selection';

  @override
  String get productionServer => 'Production';

  @override
  String get stagingServer => 'Staging';

  @override
  String get developmentServer => 'Development';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get systemTheme => 'System';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get primaryColor => 'Primary Color';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get colorSettingsTitle => 'Color Settings';

  @override
  String get primaryColorLabel => 'Primary Color';

  @override
  String get secondaryColorLabel => 'Secondary Color';

  @override
  String get accentColorLabel => 'Accent Color';

  @override
  String get themeModeSectionTitle => 'Theme Mode';

  @override
  String get selectThemeMode => 'Select Theme Mode';

  @override
  String get presetColorSchemes => 'Preset Color Schemes';

  @override
  String get resetButton => 'Reset';

  @override
  String get saveAndCloseButton => 'Save and Close';

  @override
  String get resetSuccessMessage => 'Settings reset to defaults';

  @override
  String get tapToChangeColor => 'Tap to change color';

  @override
  String appliedPreset(Object presetName) {
    return 'Applied: $presetName';
  }

  @override
  String get presetGreenDefault => 'Green (Default)';

  @override
  String get presetBlue => 'Blue';

  @override
  String get presetOrange => 'Orange';

  @override
  String get presetPurple => 'Purple';

  @override
  String get addDeviceTitle => 'Add New Device';

  @override
  String get saveDeviceButton => 'Save Device';

  @override
  String get mainTab => 'Main';

  @override
  String get advancedTab => 'Advanced';

  @override
  String get accuracyTab => 'Accuracy';

  @override
  String get tailTab => 'Tail';

  @override
  String get objectName => 'Object Name';

  @override
  String get objectImei => 'IMEI';

  @override
  String get hasExpirationDate => 'Has Expiration Date';

  @override
  String get markerImage => 'Marker Image';

  @override
  String get group => 'Group';

  @override
  String get groupUngrouped => 'Ungrouped';

  @override
  String get simNumber => 'SIM Number';

  @override
  String get deviceModel => 'Device Model';

  @override
  String get plateNumber => 'Plate Number';

  @override
  String get vin => 'VIN';

  @override
  String get registrationAssetNumber => 'Registration/Asset Number';

  @override
  String get objectOwnerManager => 'Object Owner/Manager';

  @override
  String get measurementI100km => 'Measurement (l/100km)';

  @override
  String get kmPer1Liter => 'Km per 1 Liter';

  @override
  String get costFor1Liter => 'Cost for 1 Liter';

  @override
  String get timeAdjustment => 'Time Adjustment';

  @override
  String get additionalNotes => 'Additional Notes';

  @override
  String get minimalMovingSpeed => 'Minimal Moving Speed (km/h)';

  @override
  String get minimalFuelDifferenceFillings =>
      'Minimal Fuel Difference to Detect Fuel Fillings (L)';

  @override
  String get minimalFuelDifferenceThefts =>
      'Minimal Fuel Difference to Detect Fuel Thefts (L)';

  @override
  String get tailColor => 'Tail Color';

  @override
  String get tailLength => 'Tail Length (Points)';

  @override
  String get deviceColors => 'Device Status Colors';

  @override
  String get movingColor => 'Moving';

  @override
  String get stoppedColor => 'Stopped';

  @override
  String get disconnectedColor => 'Disconnected';

  @override
  String get idleColor => 'Engine Idle';

  @override
  String get selectColor => 'Select Color';

  @override
  String get selectGroup => 'Select Group';

  @override
  String get selectMarkerImage => 'Select Marker Image';

  @override
  String get deviceDetailsTitle => 'Device Details';

  @override
  String get deviceDetailsImei => 'IMEI';

  @override
  String get deviceDetailsPlate => 'Plate Number';

  @override
  String get deviceDetailsSim => 'SIM Number';

  @override
  String get deviceDetailsModel => 'Model';

  @override
  String get deviceDetailsGroup => 'Group';

  @override
  String get deviceDetailsTailLength => 'Tail Length';

  @override
  String get deviceDetailsTailColor => 'Tail Color';

  @override
  String get deviceDetailsMarker => 'Marker Image';

  @override
  String get deviceDetailsMovingColor => 'Moving Color';

  @override
  String get deviceDetailsStoppedColor => 'Stopped Color';

  @override
  String get deviceDetailsDisconnectedColor => 'Disconnected Color';

  @override
  String get deviceDetailsIdleColor => 'Idle Color';
}
