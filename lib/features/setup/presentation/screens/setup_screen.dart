import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/setup_provider.dart';
import '../../../../data/models/setup_models.dart';

class SetupScreen extends ConsumerStatefulWidget {
  static const routeName = '/setup';
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Soft background color
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppTheme.primaryColor,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          loc.settingsTitle,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: const EdgeInsets.all(4),
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: Colors.grey.shade600,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              tabs: [
                Tab(text: loc.mainTab),
                Tab(text: loc.vehiclesTab),
                Tab(text: loc.smsTab),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMainTab(context, loc),
          _buildVehiclesTab(context, loc),
          _buildSmsTab(context, loc),
        ],
      ),
    );
  }

  Widget _buildMainTab(BuildContext context, AppLocalizations loc) {
    final settingsAsync = ref.watch(userSettingsProvider);

    return settingsAsync.when(
      data: (settings) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(loc.unitsSection),
            _buildSettingsGroup([
              _buildSettingsRow(
                icon: Icons.straighten,
                iconColor: Colors.blue,
                label: loc.distanceMeasure,
                value: settings.distanceUnit,
                onTap: () => _showModernBottomSheetPicker(
                  title: loc.distanceUnitTitle,
                  options: ['kilometer', 'mile', 'nautical mile'],
                  currentValue: settings.distanceUnit,
                  onSelect: (val) => ref
                      .read(userSettingsProvider.notifier)
                      .updateSettings(settings.copyWith(distanceUnit: val)),
                ),
              ),
              _buildDivider(),
              _buildSettingsRow(
                icon: Icons.water_drop,
                iconColor: Colors.teal,
                label: loc.capacityLabel,
                value: settings.capacityUnit,
                onTap: () => _showModernBottomSheetPicker(
                  title: loc.capacityUnitTitle,
                  options: ['liter', 'gallon'],
                  currentValue: settings.capacityUnit,
                  onSelect: (val) => ref
                      .read(userSettingsProvider.notifier)
                      .updateSettings(settings.copyWith(capacityUnit: val)),
                ),
              ),
              _buildDivider(),
              _buildSettingsRow(
                icon: Icons.landscape,
                iconColor: Colors.brown,
                label: loc.altitudeLabel,
                value: settings.altitudeUnit,
                onTap: () => _showModernBottomSheetPicker(
                  title: loc.altitudeUnitTitle,
                  options: ['meter', 'feet'],
                  currentValue: settings.altitudeUnit,
                  onSelect: (val) => ref
                      .read(userSettingsProvider.notifier)
                      .updateSettings(settings.copyWith(altitudeUnit: val)),
                ),
              ),
            ]),

            const SizedBox(height: 24),
            _buildSectionTitle(loc.timeSection),
            _buildSettingsGroup([
              _buildSettingsRow(
                icon: Icons.calendar_today,
                iconColor: Colors.orange,
                label: loc.weekDays,
                value: settings.startOfWeek,
                onTap: () => _showModernBottomSheetPicker(
                  title: loc.startOfWeekTitle,
                  options: [
                    'Saturday',
                    'Sunday',
                    'Monday',
                    'Tuesday',
                    'Wednesday',
                    'Thursday',
                    'Friday',
                  ],
                  currentValue: settings.startOfWeek,
                  onSelect: (val) => ref
                      .read(userSettingsProvider.notifier)
                      .updateSettings(settings.copyWith(startOfWeek: val)),
                ),
              ),
              _buildDivider(),
              _buildSettingsRow(
                icon: Icons.language,
                iconColor: Colors.indigo,
                label: loc.timezoneLabel,
                value: settings.timezone,
                onTap: () => _showModernBottomSheetPicker(
                  title: loc.timezoneLabel,
                  options: [
                    'UTC +1:00',
                    'UTC +2:00',
                    'UTC +3:00',
                    'UTC +4:00',
                    'UTC +5:00',
                  ],
                  currentValue: settings.timezone,
                  onSelect: (val) => ref
                      .read(userSettingsProvider.notifier)
                      .updateSettings(settings.copyWith(timezone: val)),
                ),
              ),
              _buildDivider(),
              _buildSettingsRow(
                icon: Icons.wb_sunny,
                iconColor: Colors.amber,
                label: loc.daylightSavingLabel,
                value: settings.daylightSaving,
                onTap: () => _showModernBottomSheetPicker(
                  title: loc.daylightSavingLabel,
                  options: ['None', 'Exact date', 'Automatic'],
                  currentValue: settings.daylightSaving,
                  onSelect: (val) => ref
                      .read(userSettingsProvider.notifier)
                      .updateSettings(settings.copyWith(daylightSaving: val)),
                ),
              ),
            ]),

            const SizedBox(height: 24),
            _buildSectionTitle(loc.languageLabel),
            _buildSettingsGroup([
              _buildSettingsRow(
                icon: Icons.translate,
                iconColor: Colors.purple,
                label: loc.languageLabel,
                value: settings.languageCode == 'ar' ? 'العربية' : 'English',
                onTap: () => _showLanguagePicker(settings.languageCode),
              ),
            ]),
            const SizedBox(height: 32),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('خطأ: $err')),
    );
  }

  Widget _buildVehiclesTab(BuildContext context, AppLocalizations loc) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(loc.fleetManagement),
          _buildSettingsGroup([
            _buildSettingsRow(
              icon: Icons.folder,
              iconColor: Colors.blueGrey,
              label: loc.vehicleGroups,
              value: loc.fetchingFromServer,
              onTap: () => _showListDialog(
                loc.vehicleGroups,
                ref.watch(vehicleGroupsProvider),
              ),
            ),
            _buildDivider(),
            _buildSettingsRow(
              icon: Icons.badge,
              iconColor: Colors.green,
              label: loc.driversList,
              value: loc.fetchingFromServer,
              onTap: () =>
                  _showListDialog(loc.driversTitle, ref.watch(driversProvider)),
            ),
            _buildDivider(),
            _buildSettingsRow(
              icon: Icons.event_note,
              iconColor: Colors.redAccent,
              label: loc.eventsLabel,
              value: loc.fetchingFromServer,
              onTap: () =>
                  _showListDialog(loc.eventsLabel, ref.watch(eventsProvider)),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSmsTab(BuildContext context, AppLocalizations loc) {
    final smsSettingsAsync = ref.watch(smsGatewaySettingsProvider);

    return smsSettingsAsync.when(
      data: (smsSettings) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(loc.templatesSection),
            _buildSettingsGroup([
              _buildSettingsRow(
                icon: Icons.sms,
                iconColor: Colors.lightBlue,
                label: loc.smsTemplates,
                value: loc.fetching,
                onTap: () => _showListDialog(
                  loc.smsTemplates,
                  ref.watch(smsTemplatesProvider),
                ),
              ),
              _buildDivider(),
              _buildSettingsRow(
                icon: Icons.cell_tower,
                iconColor: Colors.green,
                label: loc.gprsTemplates,
                value: loc.fetching,
                onTap: () => _showListDialog(
                  loc.gprsTemplates,
                  ref.watch(gprsTemplatesProvider),
                ),
              ),
            ]),

            const SizedBox(height: 24),
            _buildSectionTitle(loc.smsGatewaySection),
            _buildSettingsGroup([
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: Row(
                  children: [
                    _buildIconContainer(Icons.toggle_on, Colors.deepPurple),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        loc.enableSms,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Switch(
                      value: smsSettings.enabled,
                      activeColor: AppTheme.primaryColor,
                      onChanged: (val) => ref
                          .read(smsGatewaySettingsProvider.notifier)
                          .updateSettings(smsSettings.copyWith(enabled: val)),
                    ),
                  ],
                ),
              ),
              if (smsSettings.enabled) ...[
                _buildDivider(),
                _buildSettingsRow(
                  icon: Icons.router,
                  iconColor: Colors.deepOrange,
                  label: loc.gatewayTypeLabel,
                  value: smsSettings.gatewayType,
                  onTap: () => _showModernBottomSheetPicker(
                    title: loc.gatewayTypeLabel,
                    options: [
                      'server gateway',
                      'GET',
                      'POST',
                      'SMS gateway app',
                      'Plivo',
                    ],
                    currentValue: smsSettings.gatewayType,
                    onSelect: (val) => ref
                        .read(smsGatewaySettingsProvider.notifier)
                        .updateSettings(smsSettings.copyWith(gatewayType: val)),
                  ),
                ),
              ],
            ]),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('خطأ: $err')),
    );
  }

  // --- UI Helpers ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade100,
      indent: 56,
    );
  }

  Widget _buildIconContainer(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildSettingsRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            _buildIconContainer(icon, iconColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }

  // --- Modal Helpers ---

  void _showModernBottomSheetPicker({
    required String title,
    required List<String> options,
    required String currentValue,
    required Function(String) onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isSelected = option == currentValue;
                  return ListTile(
                    title: Text(
                      option,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? AppTheme.primaryColor
                            : Colors.black87,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle,
                            color: AppTheme.primaryColor,
                          )
                        : null,
                    onTap: () {
                      onSelect(option);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(String currentLanguageCode) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                AppLocalizations.of(context)!.selectLanguageTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Text('🇾🇪', style: TextStyle(fontSize: 28)),
              title: const Text(
                'العربية',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: currentLanguageCode == 'ar'
                  ? const Icon(Icons.check_circle, color: AppTheme.primaryColor)
                  : null,
              onTap: () {
                final settings = ref.read(userSettingsProvider).value!;
                ref
                    .read(userSettingsProvider.notifier)
                    .updateSettings(settings.copyWith(languageCode: 'ar'));
                ref.read(themeNotifierProvider.notifier).setLocale('ar');
                Navigator.pop(context);
              },
            ),
            const Divider(height: 1, indent: 64),
            ListTile(
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 28)),
              title: const Text(
                'English',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: currentLanguageCode == 'en'
                  ? const Icon(Icons.check_circle, color: AppTheme.primaryColor)
                  : null,
              onTap: () {
                final settings = ref.read(userSettingsProvider).value!;
                ref
                    .read(userSettingsProvider.notifier)
                    .updateSettings(settings.copyWith(languageCode: 'en'));
                ref.read(themeNotifierProvider.notifier).setLocale('en');
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showListDialog(String title, AsyncValue<List<dynamic>> asyncList) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: asyncList.when(
                data: (list) => list.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          AppLocalizations.of(context)!.noDataAvailable,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final item = list[index];
                          String name = '';
                          String subtitle = '';
                          if (item is VehicleGroup) name = item.name;
                          if (item is Driver) {
                            name = item.name;
                            subtitle = item.phone;
                          }
                          if (item is AppEvent) {
                            name = item.message;
                            subtitle = item.timestamp.toString();
                          }
                          if (item is SmsTemplate) {
                            name = item.name;
                            subtitle = item.content;
                          }

                          return ListTile(
                            title: Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: subtitle.isNotEmpty
                                ? Text(
                                    subtitle,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  )
                                : null,
                            leading: CircleAvatar(
                              backgroundColor: AppTheme.primaryColor
                                  .withOpacity(0.1),
                              child: Icon(
                                Icons.data_usage,
                                color: AppTheme.primaryColor,
                                size: 20,
                              ),
                            ),
                          );
                        },
                      ),
                loading: () => const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, _) => Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'خطأ: $err',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
