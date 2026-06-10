import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../main_map/presentation/providers/devices_provider.dart';
import '../providers/alerts_provider.dart';
import 'add_edit_alert_screen.dart';

class AlertsScreen extends ConsumerWidget {
  static const routeName = '/alerts';
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsAsync = ref.watch(filteredAlertsProvider);
    final currentFilter = ref.watch(alertFilterProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppTheme.primaryColor,
                    size: 18,
                  ),
                ),
              ),
            ),
            actions: [
              // Filter chip
              Padding(
                padding: const EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () => _showFilterSheet(context, ref, currentFilter),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.filter_list_rounded,
                          size: 16,
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _filterLabel(currentFilter),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Add button
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddEditAlertScreen(),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFFEE0979)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFEE0979).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 18),
                        SizedBox(width: 4),
                        Text(
                          'تنبيه جديد',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(right: 20, bottom: 16),
              title: const Text(
                'التنبيهات',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              background: Container(
                color: Colors.white,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, top: 50),
                    child: Text(
                      'تابع أحداث أسطولك لحظة بلحظة',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          alertsAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, _) => SliverFillRemaining(
              child: _buildEmptyState(
                icon: Icons.error_outline_rounded,
                title: 'خطأ في التحميل',
                subtitle: 'اسحب لأسفل لإعادة المحاولة',
                color: Colors.red,
              ),
            ),
            data: (alerts) {
              if (alerts.isEmpty) {
                return SliverFillRemaining(
                  child: _buildEmptyState(
                    icon: Icons.notifications_off_rounded,
                    title: 'لا توجد تنبيهات',
                    subtitle: 'أنشئ تنبيهاً جديداً لمراقبة أسطولك',
                    color: const Color(0xFFFF6B6B),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final alert = alerts[index];
                    
                    String displayName = alert.deviceName;
                    if (displayName == 'جهاز غير معروف' || displayName.isEmpty) {
                      final devicesState = ref.watch(devicesNotifierProvider);
                      devicesState.maybeWhen(
                        loaded: (devices, _, __, ___) {
                          try {
                            final d = devices.firstWhere((d) => d.id == alert.deviceId);
                            displayName = d.name;
                          } catch (_) {}
                        },
                        orElse: () {},
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddEditAlertScreen(alert: alert),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border(
                              right: BorderSide(
                                color: alert.isActive
                                    ? const Color(0xFF4CAF50)
                                    : Colors.grey.shade300,
                                width: 4,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Status switch
                              Transform.scale(
                                scale: 0.85,
                                child: Switch(
                                  value: alert.isActive,
                                  onChanged: (_) => ref
                                      .read(alertsProvider.notifier)
                                      .toggleAlertStatus(alert.id),
                                  activeColor: const Color(0xFF4CAF50),
                                  activeTrackColor: const Color(
                                    0xFF4CAF50,
                                  ).withOpacity(0.3),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      alert.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryColor
                                                .withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            alert.type,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.primaryColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            displayName,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }, childCount: alerts.length),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _filterLabel(AlertFilter filter) {
    switch (filter) {
      case AlertFilter.all:
        return 'الكل';
      case AlertFilter.active:
        return 'نشط';
      case AlertFilter.disabled:
        return 'معطل';
    }
  }

  void _showFilterSheet(
    BuildContext context,
    WidgetRef ref,
    AlertFilter currentFilter,
  ) {
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
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'تصفية التنبيهات',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            ...AlertFilter.values.map((filter) {
              final isSelected = filter == currentFilter;
              return ListTile(
                title: Text(
                  _filterLabel(filter),
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected ? AppTheme.primaryColor : Colors.black87,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(
                        Icons.check_circle,
                        color: AppTheme.primaryColor,
                      )
                    : null,
                onTap: () {
                  ref.read(alertFilterProvider.notifier).state = filter;
                  Navigator.pop(context);
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: color),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
