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

  @override
  String get devicesTabTitle => 'Devices';

  @override
  String get searchDeviceHint => 'Search device...';

  @override
  String get allDevicesFilter => 'All';

  @override
  String get ungroupedFilter => 'Ungrouped';

  @override
  String get onlineStatus => 'Online';

  @override
  String get offlineStatus => 'Offline';

  @override
  String get noDevicesMatched => 'No devices match the filter';

  @override
  String get deviceOptionsTitle => 'Device Options';

  @override
  String get groupsTabTitle => 'Manage Groups';

  @override
  String get createGroup => 'Create Group';

  @override
  String get editGroup => 'Edit Group';

  @override
  String get deleteGroup => 'Delete Group';

  @override
  String deleteGroupConfirm(Object groupName) {
    return 'Do you want to delete \"$groupName\"? What should be done with the devices in it?';
  }

  @override
  String get moveDevicesToUngrouped => 'Move to Ungrouped';

  @override
  String get deleteAllDevices => 'Delete All';

  @override
  String get groupNameLabel => 'Group Name';

  @override
  String get enterGroupNameHint => 'Enter group name';

  @override
  String get emptyGroupMessage => 'No devices in this group';

  @override
  String get saveChangesButton => 'Save Changes';

  @override
  String get createGroupSuccess => 'Group created successfully';

  @override
  String get editGroupSuccess => 'Group modified successfully';

  @override
  String get groupNotSupportedError =>
      'Sorry, your server does not support creating groups directly from the app. Please create the group from the web control panel.';

  @override
  String get emptyGroupNameValidation => 'Please enter group name';

  @override
  String get showOnMap => 'Show on Map';

  @override
  String get showOnMapSubtitle => 'Show all group devices on the map';

  @override
  String get editGroupSubtitle => 'Edit name and manage devices';

  @override
  String addDevicesCount(Object count) {
    return '$count Devices';
  }

  @override
  String get pressToCreateGroup => 'Press + to create a new group';

  @override
  String get historyTabTitle => 'History';

  @override
  String get searchVehicleHint => 'Search by vehicle name or number...';

  @override
  String get viewTripsButton => 'View Trips';

  @override
  String tripsCount(Object count) {
    return '$count Trip(s)';
  }

  @override
  String get refreshTrips => 'Refresh';

  @override
  String get loadingTrips => 'Loading trips...';

  @override
  String get selectVehicleTitle => 'Select Vehicle';

  @override
  String get selectVehicleSubtitle =>
      'Select a vehicle from above to view its trips';

  @override
  String get noTripsTitle => 'No Trips';

  @override
  String get noTripsSubtitle => 'No trips found in the specified period';

  @override
  String get removeFilters => 'Remove Filters';

  @override
  String get noVehiclesMatchedSearch => 'No vehicles match the search';

  @override
  String get totalLabel => 'Total';

  @override
  String get movingStatus => 'Moving';

  @override
  String get tryChangingFilters => 'Try changing search or filter options';

  @override
  String get checkNetworkConnection => 'Check your network connection';

  @override
  String get retry => 'Retry';

  @override
  String get idleStatus => 'Idle';

  @override
  String get noGpsSignal => 'No GPS Signal';

  @override
  String get mapLabel => 'Map';

  @override
  String get sendCommand => 'Send Command';

  @override
  String get sendSmsCommand => 'SMS Command';

  @override
  String get editDevice => 'Edit Device';

  @override
  String get unpin => 'Unpin';

  @override
  String get pinToTop => 'Pin to Top';

  @override
  String lastConnectionLabel(Object time) {
    return 'Last connection: $time';
  }

  @override
  String get km => 'km';

  @override
  String get kmh => 'km/h';

  @override
  String selectedDevicesCount(Object count) {
    return 'Selected: $count Devices';
  }

  @override
  String activeDevicesCount(Object count) {
    return '| $count Active';
  }

  @override
  String get selectAll => 'Select All';

  @override
  String get clearAll => 'Clear All';

  @override
  String get searchDevice => 'Search for device...';

  @override
  String get cancel => 'Cancel';

  @override
  String get groupsLoadError => 'Error loading groups';

  @override
  String get noGroupsYet => 'No groups yet';

  @override
  String get todayPreset => 'Today';

  @override
  String get yesterdayPreset => 'Yesterday';

  @override
  String get weekPreset => 'Week';

  @override
  String get monthPreset => 'Month';

  @override
  String get customPreset => 'Custom';

  @override
  String get longTrip => '🛣️ Long';

  @override
  String get shortTrip => '📍 Short';

  @override
  String get stops => '🛑 Stops';

  @override
  String get fastTrip => '⚡ Fast';

  @override
  String get alerts => '⚠️ Alerts';

  @override
  String get night => '🌙 Night';

  @override
  String get distanceLabel => 'Distance';

  @override
  String get durationLabel => 'Duration';

  @override
  String get avgSpeedLabel => 'Avg. Speed';

  @override
  String get maxSpeedLabel => 'Max';

  @override
  String get overspeed => 'Overspeed';

  @override
  String get normalTrip => 'Normal';

  @override
  String stopsCount(Object count) {
    return '$count Stops';
  }

  @override
  String pointsCount(Object count) {
    return '$count Points';
  }

  @override
  String get statsTab => 'Stats';

  @override
  String get timelineTab => 'Timeline';

  @override
  String get stopsTab => 'Stops';

  @override
  String get noGpsPoints => 'No GPS points for this trip';

  @override
  String get startPoint => 'Start';

  @override
  String get endPoint => 'End';

  @override
  String stopIndex(Object index) {
    return 'Stop $index';
  }

  @override
  String get timeTitle => 'Time';

  @override
  String get altitudeTitle => 'Altitude';

  @override
  String get meterUnit => 'm';

  @override
  String get speedLabel => 'Speed';

  @override
  String get noStopsTitle => 'No stops';

  @override
  String get noStopsSubtitle => 'The trip was continuous without any stops';

  @override
  String get noEventsTitle => 'No events';

  @override
  String get avgSpeedCard => 'Avg. Speed';

  @override
  String get maxSpeedCard => 'Max Speed';

  @override
  String get stopsCountCard => 'Stops Count';

  @override
  String get stopTimeCard => 'Stop Time';

  @override
  String get movingTimeCard => 'Moving Time';

  @override
  String get pointsCard => 'GPS Points';

  @override
  String get movingStopRatio => 'Moving / Stopping Ratio';

  @override
  String get tripEfficiency => 'Trip Efficiency';

  @override
  String get efficiencyExcellent => 'Excellent';

  @override
  String get efficiencyGood => 'Good';

  @override
  String get efficiencyAverage => 'Average';

  @override
  String get efficiencyPoor => 'Poor';

  @override
  String get notAvailable => 'Not available';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(Object count) {
    return '${count}m ago';
  }

  @override
  String hoursAgo(Object count) {
    return '${count}h ago';
  }

  @override
  String daysAgo(Object count) {
    return '${count}d ago';
  }

  @override
  String get optionsTab => 'Options';

  @override
  String get groupsTab => 'Groups';

  @override
  String get devicesTab => 'Devices';

  @override
  String quickStatsTotal(Object count) {
    return 'Total $count';
  }

  @override
  String quickStatsOnline(Object count) {
    return 'Online $count';
  }

  @override
  String quickStatsOffline(Object count) {
    return 'Offline $count';
  }

  @override
  String get viewAll => 'View All';

  @override
  String get noResults => 'No results found';

  @override
  String get noDevices => 'No devices found';

  @override
  String get historyLabel => 'History';

  @override
  String get sendCommandDesc => 'Device control commands';

  @override
  String get sendSms => 'SMS Command';

  @override
  String get sendSmsDesc => 'Send command via SMS';

  @override
  String get editDeviceDesc => 'Change name or settings';

  @override
  String get deleteDevice => 'Delete Device';

  @override
  String get deleteDeviceDesc => 'Permanent delete';

  @override
  String get groupsLoadFailed => 'Failed to load groups';

  @override
  String get noGroups => 'No groups found';

  @override
  String get manageGroups => 'Manage Groups';

  @override
  String get addNewDevice => 'Add New Device';

  @override
  String get tools => 'Tools';

  @override
  String get setup => 'Setup';

  @override
  String get logout => 'Logout';

  @override
  String get settingsSaved => 'Settings saved successfully';

  @override
  String get vehiclesTab => 'Vehicles';

  @override
  String get smsTab => 'SMS';

  @override
  String get unitsSection => 'Units';

  @override
  String get distanceMeasure => 'Distance Measurement';

  @override
  String get distanceUnitTitle => 'Distance Unit';

  @override
  String get capacityLabel => 'Capacity';

  @override
  String get capacityUnitTitle => 'Capacity Unit';

  @override
  String get altitudeLabel => 'Altitude';

  @override
  String get altitudeUnitTitle => 'Altitude Unit';

  @override
  String get timeSection => 'Time';

  @override
  String get weekDays => 'Week Days';

  @override
  String get startOfWeekTitle => 'Start of Week';

  @override
  String get timezoneLabel => 'Timezone';

  @override
  String get daylightSavingLabel => 'Daylight Saving';

  @override
  String get languageLabel => 'Language';

  @override
  String get fleetManagement => 'Fleet Management';

  @override
  String get vehicleGroups => 'Vehicle Groups';

  @override
  String get driversList => 'Drivers List';

  @override
  String get driversTitle => 'Drivers';

  @override
  String get eventsLabel => 'Events';

  @override
  String get templatesSection => 'Templates';

  @override
  String get smsTemplates => 'SMS Templates';

  @override
  String get gprsTemplates => 'GPRS Templates';

  @override
  String get smsGatewaySection => 'SMS Gateway';

  @override
  String get enableSms => 'Enable SMS';

  @override
  String get gatewayTypeLabel => 'Gateway Type';

  @override
  String get selectLanguageTitle => 'Select Language';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get closeButton => 'Close';

  @override
  String get fetchingFromServer => 'Fetching from server...';

  @override
  String get fetching => 'Fetching...';
}
