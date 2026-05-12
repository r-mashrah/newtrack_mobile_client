import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../../core/theme/theme_provider.dart';
import '../providers/setup_provider.dart';
import 'advanced_settings_screen.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // backgroundColor: colorScheme.surfaceVariant.withOpacity(0.3),
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'الإعدادات',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: colorScheme.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حفظ الإعدادات بنجاح')),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: colorScheme.primary,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          tabs: const [
            Tab(text: 'الرئيسية'),
            Tab(text: 'المركبات'),
            Tab(text: 'SMS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMainTab(context),
          _buildVehiclesTab(context),
          _buildSmsTab(context),
        ],
      ),
    );
  }

  Widget _buildMainTab(BuildContext context) {
    final settingsAsync = ref.watch(userSettingsProvider);

    return settingsAsync.when(
      data: (settings) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, 'الوحدات'),
            const SizedBox(height: 12),
            _buildSelectableField(
              context,
              label: 'قياس المسافة',
              value: settings.distanceUnit,
              onTap: () => _showOptionsDialog(
                context,
                'وحدة المسافة',
                ['kilometer', 'mile', 'nautical mile'],
                settings.distanceUnit,
                (val) => ref
                    .read(userSettingsProvider.notifier)
                    .updateSettings(settings.copyWith(distanceUnit: val)),
              ),
            ),
            const SizedBox(height: 8),
            _buildSelectableField(
              context,
              label: 'الحجم',
              value: settings.capacityUnit,
              onTap: () => _showOptionsDialog(
                context,
                'وحدة الحجم',
                ['liter', 'gallon'],
                settings.capacityUnit,
                (val) => ref
                    .read(userSettingsProvider.notifier)
                    .updateSettings(settings.copyWith(capacityUnit: val)),
              ),
            ),
            const SizedBox(height: 8),
            _buildSelectableField(
              context,
              label: 'الارتفاع',
              value: settings.altitudeUnit,
              onTap: () => _showOptionsDialog(
                context,
                'وحدة الارتفاع',
                ['meter', 'feet'],
                settings.altitudeUnit,
                (val) => ref
                    .read(userSettingsProvider.notifier)
                    .updateSettings(settings.copyWith(altitudeUnit: val)),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'الوقت'),
            const SizedBox(height: 12),
            _buildSelectableField(
              context,
              label: 'أيام الأسبوع',
              value: settings.startOfWeek,
              onTap: () => _showOptionsDialog(
                context,
                'بداية الأسبوع',
                [
                  'Saturday',
                  'Sunday',
                  'Monday',
                  'Tuesday',
                  'Wednesday',
                  'Thursday',
                  'Friday',
                ],
                settings.startOfWeek,
                (val) => ref
                    .read(userSettingsProvider.notifier)
                    .updateSettings(settings.copyWith(startOfWeek: val)),
              ),
            ),
            const SizedBox(height: 8),
            _buildSelectableField(
              context,
              label: 'المنطقة الزمنية',
              value: settings.timezone,
              onTap: () => _showOptionsDialog(
                context,
                'المنطقة الزمنية',
                [
                  'UTC +1:00',
                  'UTC +2:00',
                  'UTC +3:00',
                  'UTC +4:00',
                  'UTC +5:00',
                ],
                settings.timezone,
                (val) => ref
                    .read(userSettingsProvider.notifier)
                    .updateSettings(settings.copyWith(timezone: val)),
              ),
            ),
            const SizedBox(height: 8),
            _buildSelectableField(
              context,
              label: 'التوقيت الصيفي',
              value: settings.daylightSaving,
              onTap: () => _showOptionsDialog(
                context,
                'التوقيت الصيفي',
                ['None', 'Exact date', 'Automatic'],
                settings.daylightSaving,
                (val) => ref
                    .read(userSettingsProvider.notifier)
                    .updateSettings(settings.copyWith(daylightSaving: val)),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'اللغة'),
            const SizedBox(height: 12),
            _buildSelectableField(
              context,
              label: 'اللغة',
              value: settings.languageCode == 'ar'
                  ? 'العربية 🇾🇪'
                  : 'English 🇺🇸',
              onTap: () => _showLanguageDialog(context),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('خطأ: $err')),
    );
  }

  Widget _buildVehiclesTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'إدارة الأسطول'),
          const SizedBox(height: 12),
          _buildSelectableField(
            context,
            label: 'مجموعة المركبات',
            value: 'استدعاء من السيرفر...',
            onTap: () => _showListDialog(
              context,
              'مجموعات المركبات',
              ref.watch(vehicleGroupsProvider),
            ),
          ),
          const SizedBox(height: 8),
          _buildSelectableField(
            context,
            label: 'قائمة السائقين',
            value: 'استدعاء من السيرفر...',
            onTap: () => _showListDialog(
              context,
              'السائقين',
              ref.watch(driversProvider),
            ),
          ),
          const SizedBox(height: 8),
          _buildSelectableField(
            context,
            label: 'الأحداث',
            value: 'استدعاء من السيرفر...',
            onTap: () =>
                _showListDialog(context, 'الأحداث', ref.watch(eventsProvider)),
          ),
        ],
      ),
    );
  }

  Widget _buildSmsTab(BuildContext context) {
    final smsSettingsAsync = ref.watch(smsGatewaySettingsProvider);

    return smsSettingsAsync.when(
      data: (smsSettings) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, 'القوالب'),
            const SizedBox(height: 12),
            _buildSelectableField(
              context,
              label: 'قوالب SMS',
              value: 'استدعاء...',
              onTap: () => _showListDialog(
                context,
                'قوالب SMS',
                ref.watch(smsTemplatesProvider),
              ),
            ),
            const SizedBox(height: 8),
            _buildSelectableField(
              context,
              label: 'قوالب GPRS',
              value: 'استدعاء...',
              onTap: () => _showListDialog(
                context,
                'قوالب GPRS',
                ref.watch(gprsTemplatesProvider),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'بوابة الرسائل النصية'),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('تمكين الرسائل النصية'),
              value: smsSettings.enabled,
              onChanged: (val) => ref
                  .read(smsGatewaySettingsProvider.notifier)
                  .updateSettings(smsSettings.copyWith(enabled: val)),
            ),
            if (smsSettings.enabled) ...[
              const SizedBox(height: 8),
              _buildSelectableField(
                context,
                label: 'نوع البوابة',
                value: smsSettings.gatewayType,
                onTap: () => _showOptionsDialog(
                  context,
                  'نوع البوابة',
                  ['server gateway', 'GET', 'POST', 'SMS gateway app', 'Plivo'],
                  smsSettings.gatewayType,
                  (val) => ref
                      .read(smsGatewaySettingsProvider.notifier)
                      .updateSettings(smsSettings.copyWith(gatewayType: val)),
                ),
              ),
            ],
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('خطأ: $err')),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSelectableField(
    BuildContext context, {
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: ListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(color: colorScheme.primary, fontSize: 14),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  void _showOptionsDialog(
    BuildContext context,
    String title,
    List<String> options,
    String current,
    Function(String) onSelect,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options
              .map(
                (opt) => RadioListTile(
                  title: Text(opt),
                  value: opt,
                  groupValue: current,
                  onChanged: (val) {
                    onSelect(val!);
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final settings = ref.read(userSettingsProvider).value!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر اللغة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇾🇪', style: TextStyle(fontSize: 24)),
              title: const Text('العربية'),
              onTap: () {
                ref
                    .read(userSettingsProvider.notifier)
                    .updateSettings(settings.copyWith(languageCode: 'ar'));
                ref.read(themeNotifierProvider.notifier).setLocale('ar');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
              title: const Text('English'),
              onTap: () {
                ref
                    .read(userSettingsProvider.notifier)
                    .updateSettings(settings.copyWith(languageCode: 'en'));
                ref.read(themeNotifierProvider.notifier).setLocale('en');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showListDialog(
    BuildContext context,
    String title,
    AsyncValue<List<dynamic>> asyncList,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: asyncList.when(
            data: (list) => list.isEmpty
                ? const Text('لا توجد بيانات')
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
                        title: Text(name),
                        subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
                      );
                    },
                  ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text('خطأ: $err'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
