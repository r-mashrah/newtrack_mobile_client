import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/alerts_provider.dart';
import 'add_edit_alert_screen.dart';

class AlertsScreen extends ConsumerWidget {
  static const routeName = '/alerts';
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(filteredAlertsProvider);
    final currentFilter = ref.watch(alertFilterProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'التنبيهات',
          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppTheme.primaryColor, size: 22),
            onPressed: () => _showFilterDialog(context, ref, currentFilter),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: AppTheme.primaryColor, size: 22),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddEditAlertScreen()),
            ),
          ),
        ],
      ),
      body: alerts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text(
                    'لا توجد تنبيهات حالياً',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    dense: true,
                    title: Text(alert.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text('${alert.deviceName} - ${alert.type}', style: const TextStyle(fontSize: 12)),
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: alert.isActive,
                        onChanged: (value) => ref.read(alertsProvider.notifier).toggleAlertStatus(alert.id),
                        activeColor: AppTheme.primaryColor,
                      ),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddEditAlertScreen(alert: alert)),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showFilterDialog(BuildContext context, WidgetRef ref, AlertFilter currentFilter) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تصفية التنبيهات', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption(context, ref, 'الكل', AlertFilter.all, currentFilter),
            _buildFilterOption(context, ref, 'نشط', AlertFilter.active, currentFilter),
            _buildFilterOption(context, ref, 'معطل', AlertFilter.disabled, currentFilter),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(BuildContext context, WidgetRef ref, String title, AlertFilter value, AlertFilter groupValue) {
    return RadioListTile<AlertFilter>(
      title: Text(title, style: const TextStyle(fontSize: 14)),
      value: value,
      groupValue: groupValue,
      activeColor: AppTheme.primaryColor,
      onChanged: (val) {
        ref.read(alertFilterProvider.notifier).state = val!;
        Navigator.pop(context);
      },
    );
  }
}
