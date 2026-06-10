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

  /// No description provided for @devicesTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get devicesTabTitle;

  /// No description provided for @searchDeviceHint.
  ///
  /// In en, this message translates to:
  /// **'Search device...'**
  String get searchDeviceHint;

  /// No description provided for @allDevicesFilter.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allDevicesFilter;

  /// No description provided for @ungroupedFilter.
  ///
  /// In en, this message translates to:
  /// **'Ungrouped'**
  String get ungroupedFilter;

  /// No description provided for @onlineStatus.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get onlineStatus;

  /// No description provided for @offlineStatus.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offlineStatus;

  /// No description provided for @noDevicesMatched.
  ///
  /// In en, this message translates to:
  /// **'No devices match the filter'**
  String get noDevicesMatched;

  /// No description provided for @deviceOptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Device Options'**
  String get deviceOptionsTitle;

  /// No description provided for @groupsTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Groups'**
  String get groupsTabTitle;

  /// No description provided for @createGroup.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get createGroup;

  /// No description provided for @editGroup.
  ///
  /// In en, this message translates to:
  /// **'Edit Group'**
  String get editGroup;

  /// No description provided for @deleteGroup.
  ///
  /// In en, this message translates to:
  /// **'Delete Group'**
  String get deleteGroup;

  /// No description provided for @deleteGroupConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete \"{groupName}\"? What should be done with the devices in it?'**
  String deleteGroupConfirm(Object groupName);

  /// No description provided for @moveDevicesToUngrouped.
  ///
  /// In en, this message translates to:
  /// **'Move to Ungrouped'**
  String get moveDevicesToUngrouped;

  /// No description provided for @deleteAllDevices.
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get deleteAllDevices;

  /// No description provided for @groupNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get groupNameLabel;

  /// No description provided for @enterGroupNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter group name'**
  String get enterGroupNameHint;

  /// No description provided for @emptyGroupMessage.
  ///
  /// In en, this message translates to:
  /// **'No devices in this group'**
  String get emptyGroupMessage;

  /// No description provided for @saveChangesButton.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChangesButton;

  /// No description provided for @createGroupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Group created successfully'**
  String get createGroupSuccess;

  /// No description provided for @editGroupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Group modified successfully'**
  String get editGroupSuccess;

  /// No description provided for @groupNotSupportedError.
  ///
  /// In en, this message translates to:
  /// **'Sorry, your server does not support creating groups directly from the app. Please create the group from the web control panel.'**
  String get groupNotSupportedError;

  /// No description provided for @emptyGroupNameValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter group name'**
  String get emptyGroupNameValidation;

  /// No description provided for @showOnMap.
  ///
  /// In en, this message translates to:
  /// **'Show on Map'**
  String get showOnMap;

  /// No description provided for @showOnMapSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show all group devices on the map'**
  String get showOnMapSubtitle;

  /// No description provided for @editGroupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Edit name and manage devices'**
  String get editGroupSubtitle;

  /// No description provided for @addDevicesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Devices'**
  String addDevicesCount(Object count);

  /// No description provided for @pressToCreateGroup.
  ///
  /// In en, this message translates to:
  /// **'Press + to create a new group'**
  String get pressToCreateGroup;

  /// No description provided for @historyTabTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTabTitle;

  /// No description provided for @searchVehicleHint.
  ///
  /// In en, this message translates to:
  /// **'Search by vehicle name or number...'**
  String get searchVehicleHint;

  /// No description provided for @viewTripsButton.
  ///
  /// In en, this message translates to:
  /// **'View Trips'**
  String get viewTripsButton;

  /// No description provided for @tripsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Trip(s)'**
  String tripsCount(Object count);

  /// No description provided for @refreshTrips.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshTrips;

  /// No description provided for @loadingTrips.
  ///
  /// In en, this message translates to:
  /// **'Loading trips...'**
  String get loadingTrips;

  /// No description provided for @selectVehicleTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Vehicle'**
  String get selectVehicleTitle;

  /// No description provided for @selectVehicleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select a vehicle from above to view its trips'**
  String get selectVehicleSubtitle;

  /// No description provided for @noTripsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Trips'**
  String get noTripsTitle;

  /// No description provided for @noTripsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No trips found in the specified period'**
  String get noTripsSubtitle;

  /// No description provided for @removeFilters.
  ///
  /// In en, this message translates to:
  /// **'Remove Filters'**
  String get removeFilters;

  /// No description provided for @noVehiclesMatchedSearch.
  ///
  /// In en, this message translates to:
  /// **'No vehicles match the search'**
  String get noVehiclesMatchedSearch;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @movingStatus.
  ///
  /// In en, this message translates to:
  /// **'Moving'**
  String get movingStatus;

  /// No description provided for @tryChangingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try changing search or filter options'**
  String get tryChangingFilters;

  /// No description provided for @checkNetworkConnection.
  ///
  /// In en, this message translates to:
  /// **'Check your network connection'**
  String get checkNetworkConnection;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @idleStatus.
  ///
  /// In en, this message translates to:
  /// **'Idle'**
  String get idleStatus;

  /// No description provided for @noGpsSignal.
  ///
  /// In en, this message translates to:
  /// **'No GPS Signal'**
  String get noGpsSignal;

  /// No description provided for @mapLabel.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapLabel;

  /// No description provided for @sendCommand.
  ///
  /// In en, this message translates to:
  /// **'Send Command'**
  String get sendCommand;

  /// No description provided for @sendSmsCommand.
  ///
  /// In en, this message translates to:
  /// **'SMS Command'**
  String get sendSmsCommand;

  /// No description provided for @editDevice.
  ///
  /// In en, this message translates to:
  /// **'Edit Device'**
  String get editDevice;

  /// No description provided for @unpin.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get unpin;

  /// No description provided for @pinToTop.
  ///
  /// In en, this message translates to:
  /// **'Pin to Top'**
  String get pinToTop;

  /// No description provided for @lastConnectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Last connection: {time}'**
  String lastConnectionLabel(Object time);

  /// No description provided for @km.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get km;

  /// No description provided for @kmh.
  ///
  /// In en, this message translates to:
  /// **'km/h'**
  String get kmh;

  /// No description provided for @selectedDevicesCount.
  ///
  /// In en, this message translates to:
  /// **'Selected: {count} Devices'**
  String selectedDevicesCount(Object count);

  /// No description provided for @activeDevicesCount.
  ///
  /// In en, this message translates to:
  /// **'| {count} Active'**
  String activeDevicesCount(Object count);

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @searchDevice.
  ///
  /// In en, this message translates to:
  /// **'Search for device...'**
  String get searchDevice;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @groupsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Error loading groups'**
  String get groupsLoadError;

  /// No description provided for @noGroupsYet.
  ///
  /// In en, this message translates to:
  /// **'No groups yet'**
  String get noGroupsYet;

  /// No description provided for @todayPreset.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayPreset;

  /// No description provided for @yesterdayPreset.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterdayPreset;

  /// No description provided for @weekPreset.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get weekPreset;

  /// No description provided for @monthPreset.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get monthPreset;

  /// No description provided for @customPreset.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customPreset;

  /// No description provided for @longTrip.
  ///
  /// In en, this message translates to:
  /// **'🛣️ Long'**
  String get longTrip;

  /// No description provided for @shortTrip.
  ///
  /// In en, this message translates to:
  /// **'📍 Short'**
  String get shortTrip;

  /// No description provided for @stops.
  ///
  /// In en, this message translates to:
  /// **'🛑 Stops'**
  String get stops;

  /// No description provided for @fastTrip.
  ///
  /// In en, this message translates to:
  /// **'⚡ Fast'**
  String get fastTrip;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Alerts'**
  String get alerts;

  /// No description provided for @night.
  ///
  /// In en, this message translates to:
  /// **'🌙 Night'**
  String get night;

  /// No description provided for @distanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distanceLabel;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationLabel;

  /// No description provided for @avgSpeedLabel.
  ///
  /// In en, this message translates to:
  /// **'Avg. Speed'**
  String get avgSpeedLabel;

  /// No description provided for @maxSpeedLabel.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get maxSpeedLabel;

  /// No description provided for @overspeed.
  ///
  /// In en, this message translates to:
  /// **'Overspeed'**
  String get overspeed;

  /// No description provided for @normalTrip.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normalTrip;

  /// No description provided for @stopsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Stops'**
  String stopsCount(Object count);

  /// No description provided for @pointsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Points'**
  String pointsCount(Object count);

  /// No description provided for @statsTab.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get statsTab;

  /// No description provided for @timelineTab.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timelineTab;

  /// No description provided for @stopsTab.
  ///
  /// In en, this message translates to:
  /// **'Stops'**
  String get stopsTab;

  /// No description provided for @noGpsPoints.
  ///
  /// In en, this message translates to:
  /// **'No GPS points for this trip'**
  String get noGpsPoints;

  /// No description provided for @startPoint.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startPoint;

  /// No description provided for @endPoint.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get endPoint;

  /// No description provided for @stopIndex.
  ///
  /// In en, this message translates to:
  /// **'Stop {index}'**
  String stopIndex(Object index);

  /// No description provided for @timeTitle.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeTitle;

  /// No description provided for @altitudeTitle.
  ///
  /// In en, this message translates to:
  /// **'Altitude'**
  String get altitudeTitle;

  /// No description provided for @meterUnit.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get meterUnit;

  /// No description provided for @speedLabel.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speedLabel;

  /// No description provided for @noStopsTitle.
  ///
  /// In en, this message translates to:
  /// **'No stops'**
  String get noStopsTitle;

  /// No description provided for @noStopsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The trip was continuous without any stops'**
  String get noStopsSubtitle;

  /// No description provided for @noEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'No events'**
  String get noEventsTitle;

  /// No description provided for @avgSpeedCard.
  ///
  /// In en, this message translates to:
  /// **'Avg. Speed'**
  String get avgSpeedCard;

  /// No description provided for @maxSpeedCard.
  ///
  /// In en, this message translates to:
  /// **'Max Speed'**
  String get maxSpeedCard;

  /// No description provided for @stopsCountCard.
  ///
  /// In en, this message translates to:
  /// **'Stops Count'**
  String get stopsCountCard;

  /// No description provided for @stopTimeCard.
  ///
  /// In en, this message translates to:
  /// **'Stop Time'**
  String get stopTimeCard;

  /// No description provided for @movingTimeCard.
  ///
  /// In en, this message translates to:
  /// **'Moving Time'**
  String get movingTimeCard;

  /// No description provided for @pointsCard.
  ///
  /// In en, this message translates to:
  /// **'GPS Points'**
  String get pointsCard;

  /// No description provided for @movingStopRatio.
  ///
  /// In en, this message translates to:
  /// **'Moving / Stopping Ratio'**
  String get movingStopRatio;

  /// No description provided for @tripEfficiency.
  ///
  /// In en, this message translates to:
  /// **'Trip Efficiency'**
  String get tripEfficiency;

  /// No description provided for @efficiencyExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get efficiencyExcellent;

  /// No description provided for @efficiencyGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get efficiencyGood;

  /// No description provided for @efficiencyAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get efficiencyAverage;

  /// No description provided for @efficiencyPoor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get efficiencyPoor;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String minutesAgo(Object count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String hoursAgo(Object count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String daysAgo(Object count);

  /// No description provided for @optionsTab.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get optionsTab;

  /// No description provided for @groupsTab.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groupsTab;

  /// No description provided for @devicesTab.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get devicesTab;

  /// No description provided for @quickStatsTotal.
  ///
  /// In en, this message translates to:
  /// **'Total {count}'**
  String quickStatsTotal(Object count);

  /// No description provided for @quickStatsOnline.
  ///
  /// In en, this message translates to:
  /// **'Online {count}'**
  String quickStatsOnline(Object count);

  /// No description provided for @quickStatsOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline {count}'**
  String quickStatsOffline(Object count);

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @noDevices.
  ///
  /// In en, this message translates to:
  /// **'No devices found'**
  String get noDevices;

  /// No description provided for @historyLabel.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyLabel;

  /// No description provided for @sendCommandDesc.
  ///
  /// In en, this message translates to:
  /// **'Device control commands'**
  String get sendCommandDesc;

  /// No description provided for @sendSms.
  ///
  /// In en, this message translates to:
  /// **'SMS Command'**
  String get sendSms;

  /// No description provided for @sendSmsDesc.
  ///
  /// In en, this message translates to:
  /// **'Send command via SMS'**
  String get sendSmsDesc;

  /// No description provided for @editDeviceDesc.
  ///
  /// In en, this message translates to:
  /// **'Change name or settings'**
  String get editDeviceDesc;

  /// No description provided for @deleteDevice.
  ///
  /// In en, this message translates to:
  /// **'Delete Device'**
  String get deleteDevice;

  /// No description provided for @deleteDeviceDesc.
  ///
  /// In en, this message translates to:
  /// **'Permanent delete'**
  String get deleteDeviceDesc;

  /// No description provided for @groupsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load groups'**
  String get groupsLoadFailed;

  /// No description provided for @noGroups.
  ///
  /// In en, this message translates to:
  /// **'No groups found'**
  String get noGroups;

  /// No description provided for @manageGroups.
  ///
  /// In en, this message translates to:
  /// **'Manage Groups'**
  String get manageGroups;

  /// No description provided for @addNewDevice.
  ///
  /// In en, this message translates to:
  /// **'Add New Device'**
  String get addNewDevice;

  /// No description provided for @tools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get tools;

  /// No description provided for @setup.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get setup;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully'**
  String get settingsSaved;

  /// No description provided for @vehiclesTab.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get vehiclesTab;

  /// No description provided for @smsTab.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get smsTab;

  /// No description provided for @unitsSection.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get unitsSection;

  /// No description provided for @distanceMeasure.
  ///
  /// In en, this message translates to:
  /// **'Distance Measurement'**
  String get distanceMeasure;

  /// No description provided for @distanceUnitTitle.
  ///
  /// In en, this message translates to:
  /// **'Distance Unit'**
  String get distanceUnitTitle;

  /// No description provided for @capacityLabel.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get capacityLabel;

  /// No description provided for @capacityUnitTitle.
  ///
  /// In en, this message translates to:
  /// **'Capacity Unit'**
  String get capacityUnitTitle;

  /// No description provided for @altitudeLabel.
  ///
  /// In en, this message translates to:
  /// **'Altitude'**
  String get altitudeLabel;

  /// No description provided for @altitudeUnitTitle.
  ///
  /// In en, this message translates to:
  /// **'Altitude Unit'**
  String get altitudeUnitTitle;

  /// No description provided for @timeSection.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeSection;

  /// No description provided for @weekDays.
  ///
  /// In en, this message translates to:
  /// **'Week Days'**
  String get weekDays;

  /// No description provided for @startOfWeekTitle.
  ///
  /// In en, this message translates to:
  /// **'Start of Week'**
  String get startOfWeekTitle;

  /// No description provided for @timezoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get timezoneLabel;

  /// No description provided for @daylightSavingLabel.
  ///
  /// In en, this message translates to:
  /// **'Daylight Saving'**
  String get daylightSavingLabel;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @fleetManagement.
  ///
  /// In en, this message translates to:
  /// **'Fleet Management'**
  String get fleetManagement;

  /// No description provided for @vehicleGroups.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Groups'**
  String get vehicleGroups;

  /// No description provided for @driversList.
  ///
  /// In en, this message translates to:
  /// **'Drivers List'**
  String get driversList;

  /// No description provided for @driversTitle.
  ///
  /// In en, this message translates to:
  /// **'Drivers'**
  String get driversTitle;

  /// No description provided for @eventsLabel.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get eventsLabel;

  /// No description provided for @templatesSection.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get templatesSection;

  /// No description provided for @smsTemplates.
  ///
  /// In en, this message translates to:
  /// **'SMS Templates'**
  String get smsTemplates;

  /// No description provided for @gprsTemplates.
  ///
  /// In en, this message translates to:
  /// **'GPRS Templates'**
  String get gprsTemplates;

  /// No description provided for @smsGatewaySection.
  ///
  /// In en, this message translates to:
  /// **'SMS Gateway'**
  String get smsGatewaySection;

  /// No description provided for @enableSms.
  ///
  /// In en, this message translates to:
  /// **'Enable SMS'**
  String get enableSms;

  /// No description provided for @gatewayTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Gateway Type'**
  String get gatewayTypeLabel;

  /// No description provided for @selectLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguageTitle;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @closeButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// No description provided for @fetchingFromServer.
  ///
  /// In en, this message translates to:
  /// **'Fetching from server...'**
  String get fetchingFromServer;

  /// No description provided for @fetching.
  ///
  /// In en, this message translates to:
  /// **'Fetching...'**
  String get fetching;
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
