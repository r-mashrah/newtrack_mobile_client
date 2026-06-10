import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/device_entity.dart';
import '../../../history/presentation/providers/history_provider.dart';
import '../../../tools/presentation/screens/gprs_command_screen.dart';
import '../../../tools/presentation/screens/sms_command_screen.dart';
import '../../../main_map/presentation/providers/devices_provider.dart';

class DeviceDetailsScreen extends ConsumerWidget {
  final String deviceId;

  const DeviceDetailsScreen({Key? key, required this.deviceId})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesState = ref.watch(devicesNotifierProvider);

    final deviceAsync = devicesState.maybeMap(
      loaded: (loaded) {
        try {
          final device = loaded.devices.firstWhere((d) => d.id == deviceId);
          return AsyncValue.data(device);
        } catch (e) {
          return AsyncValue.error(
            Exception('الجهاز غير موجود'),
            StackTrace.current,
          );
        }
      },
      loading: (_) => const AsyncValue<DeviceEntity>.loading(),
      error: (err) =>
          AsyncValue<DeviceEntity>.error(err.message, StackTrace.current),
      orElse: () => const AsyncValue<DeviceEntity>.loading(),
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'لوحة المراقبة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: deviceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text('خطأ: $err', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
        data: (device) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroHeader(context, device),
                const SizedBox(height: 24),
                _buildQuickActions(context, ref, device),
                const SizedBox(height: 24),
                _buildBasicInfoSection(device),
                const SizedBox(height: 32),
                _buildQuickSummaryCards(device),
                const SizedBox(height: 32),
                _buildActivityTimeline(device),
                const SizedBox(height: 32),
                _buildSensorsSection(device),
                const SizedBox(height: 32),
                _buildServicesSection(device),
                const SizedBox(height: 32),
                _buildColorSettingsSection(device),
                const SizedBox(height: 48),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context, DeviceEntity d) {
    final statusColor = _getDeviceStatusColor(d);
    final isMoving = d.speed != null && d.speed! > 0;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.directions_car, color: statusColor, size: 36),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: statusColor.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _getStatusText(d),
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTime(d.lastUpdate),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isMoving)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.lightBlue],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    '${d.speed!.toInt()} كم/س',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'بالقرب من ${d.lastLocation.latitude.toStringAsFixed(4)}, ${d.lastLocation.longitude.toStringAsFixed(4)}',
                    style: TextStyle(color: Colors.grey[800], fontSize: 14),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20, color: Colors.blue),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    Clipboard.setData(
                      ClipboardData(
                        text:
                            '${d.lastLocation.latitude}, ${d.lastLocation.longitude}',
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم نسخ الإحداثيات بنجاح')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(
    BuildContext context,
    WidgetRef ref,
    DeviceEntity d,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildActionBtn(context, Icons.history, 'السجل', () {
            ref.read(historyPageProvider.notifier).selectDevice(d.id);
            ref.read(historyPageProvider.notifier).fetchTrips();
            context.push('/history');
          }),
          _buildActionBtn(context, Icons.play_arrow, 'تشغيل المسار', () {
            ref.read(historyPageProvider.notifier).selectDevice(d.id);
            ref.read(historyPageProvider.notifier).fetchTrips();
            context.push('/history');
          }),
          _buildActionBtn(context, Icons.navigation, 'انتقال', () {}),
          _buildActionBtn(context, Icons.terminal, 'أوامر', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GPRSCommandScreen(preSelectedDevice: d),
              ),
            );
          }),
          _buildActionBtn(context, Icons.sms, 'SMS', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SMSCommandScreen(preSelectedDevice: d),
              ),
            );
          }),
          _buildActionBtn(context, Icons.phone, 'اتصال', () {}),
          _buildActionBtn(context, Icons.settings, 'إعدادات', () {}),
        ],
      ),
    );
  }

  Widget _buildActionBtn(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.blue[800], size: 26),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSummaryCards(DeviceEntity d) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.8,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildSummaryCard(
            Icons.speed,
            'السرعة الحالية',
            d.speed != null && d.speed! > 0 ? '${d.speed!.toInt()} كم/س' : '--',
          ),
          _buildSummaryCard(
            Icons.timer,
            'حالة التوقف',
            d.speed == null || d.speed! == 0 ? _timeSince(d.lastUpdate) : '--',
          ),
          _buildSummaryCard(
            Icons.satellite_alt,
            'إشارة GPS',
            d.status != 'offline' ? 'متصل ومستقر' : '--',
          ),
          _buildSummaryCard(
            Icons.battery_charging_full,
            'البطارية الداخلية',
            d.batteryLevel != null ? '${d.batteryLevel!.toInt()}%' : '--',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildActivityTimeline(DeviceEntity d) {
    return _buildCollapsibleSection(
      'التسلسل الزمني للنشاط',
      Icons.timeline,
      Column(
        children: [
          _buildTimelineItem(
            Icons.location_on,
            'آخر ظهور وموقع مسجل',
            _timeSince(d.lastUpdate),
            isFirst: true,
          ),
          _buildTimelineItem(
            d.speed != null && d.speed! > 0
                ? Icons.directions_car
                : Icons.stop_circle,
            d.speed != null && d.speed! > 0
                ? 'بداية الحركة الفعلية'
                : 'بداية التوقف الأخير',
            '--',
          ),
          _buildTimelineItem(
            Icons.warning_amber,
            'آخر تنبيه مسجل',
            'لا توجد تنبيهات حديثة مسجلة للنظام',
            isLast: true,
            isAlert: true,
          ),
        ],
      ),
      initiallyExpanded: true,
    );
  }

  Widget _buildTimelineItem(
    IconData icon,
    String title,
    String subtitle, {
    bool isFirst = false,
    bool isLast = false,
    bool isAlert = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 2,
              height: isFirst ? 0 : 20,
              color: Colors.grey[200],
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isAlert ? Colors.red[50] : Colors.blue[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 16,
                color: isAlert ? Colors.red : Colors.blue,
              ),
            ),
            Container(
              width: 2,
              height: isLast ? 0 : 20,
              color: Colors.grey[200],
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                if (isAlert && subtitle != 'لا توجد تنبيهات حديثة مسجلة للنظام')
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 0,
                        ),
                        minimumSize: const Size(0, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'عرض التفاصيل',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSensorsSection(DeviceEntity d) {
    return _buildCollapsibleSection(
      'قراءات الحساسات',
      Icons.sensors,
      d.sensors == null || d.sensors!.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(Icons.sensors_off, size: 48, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد بيانات حساسات متاحة حالياً',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                ],
              ),
            )
          : Wrap(
              spacing: 12,
              runSpacing: 12,
              children: d.sensors!.entries
                  .map(
                    (entry) => InkWell(
                      onTap: () {
                        HapticFeedback.selectionClick();
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.memory,
                              size: 16,
                              color: Colors.blueGrey[400],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${entry.key}: ',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              entry.value.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }

  Widget _buildServicesSection(DeviceEntity d) {
    return _buildCollapsibleSection(
      'الخدمات والصيانة',
      Icons.build_circle,
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              Icons.build_circle_outlined,
              size: 48,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد خدمات مسجلة لهذه المركبة',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('إضافة خدمة جديدة'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDeviceStatusColor(DeviceEntity device) {
    final speed = device.speed ?? 0.0;
    final lastUpdate = device.lastUpdate;
    if (lastUpdate == null ||
        DateTime.now().difference(lastUpdate).inMinutes > 60)
      return Colors.red;
    if (speed > 0) return Colors.blue;
    if (device.status == 'idle') return Colors.yellow[700]!;
    return Colors.green;
  }

  String _getStatusText(DeviceEntity device) {
    final speed = device.speed ?? 0.0;
    final lastUpdate = device.lastUpdate;
    if (lastUpdate == null ||
        DateTime.now().difference(lastUpdate).inMinutes > 60)
      return 'غير متصل';
    if (speed > 0) return 'متحرك';
    if (device.status == 'idle') return 'خمول';
    return 'متوقف';
  }

  String _timeSince(DateTime? time) {
    if (time == null) return '--';
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inHours < 1) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inDays < 1) return 'منذ ${diff.inHours} ساعة';
    return 'منذ ${diff.inDays} يوم';
  }

  String _formatTime(DateTime? time) {
    return _timeSince(time);
  }

  Widget _buildCollapsibleSection(
    String title,
    IconData icon,
    Widget child, {
    bool initiallyExpanded = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          iconColor: Colors.blue[700],
          collapsedIconColor: Colors.grey[500],
          title: Row(
            children: [
              Icon(icon, size: 20, color: Colors.blue[700]),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(DeviceEntity d) {
    return _buildCollapsibleSection(
      'المعلومات الأساسية للمركبة',
      Icons.info_outline,
      Column(
        children: [
          _buildInfoRow(
            'رقم اللوحة',
            (d.plateNumber != null && d.plateNumber!.isNotEmpty)
                ? d.plateNumber!
                : _extractFromDevice(d, 'plate_number'),
            Icons.pin,
          ),
          const Divider(height: 24),
          _buildInfoRow('المجموعة', d.group ?? 'بدون مجموعة', Icons.group),
          const Divider(height: 24),
          _buildInfoRow(
            'السائق',
            (d.driverName != null && d.driverName!.isNotEmpty)
                ? d.driverName!
                : _extractFromDevice(d, 'driver_name'),
            Icons.person,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            'موديل الجهاز',
            (d.model != null && d.model!.isNotEmpty)
                ? d.model!
                : _extractFromDevice(d, 'device_model'),
            Icons.developer_board,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            'رقم الشريحة (SIM)',
            (d.simNumber != null && d.simNumber!.isNotEmpty)
                ? d.simNumber!
                : _extractFromDevice(d, 'sim_number'),
            Icons.sim_card,
          ),
          const Divider(height: 24),
          _buildInfoRow('الرقم التسلسلي (IMEI)', d.imei, Icons.tag),
        ],
      ),
      initiallyExpanded: true,
    );
  }

  String _extractFromDevice(DeviceEntity d, String key) {
    if (d.additionalData != null) {
      if (d.additionalData![key] != null &&
          d.additionalData![key].toString().isNotEmpty) {
        return d.additionalData![key].toString();
      }
      if (d.additionalData!['device_data'] != null &&
          d.additionalData!['device_data'] is Map) {
        final deviceData = d.additionalData!['device_data'] as Map;
        if (deviceData[key] != null && deviceData[key].toString().isNotEmpty) {
          return deviceData[key].toString();
        }
      }
    }
    return 'غير متوفر';
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: Colors.blue[700]),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildColorSettingsSection(DeviceEntity d) {
    return _buildCollapsibleSection(
      'إعدادات التتبع والمسار',
      Icons.settings_suggest,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildColorRow('لون الحركة', d.movingColor ?? '#00FF00'),
          const Divider(height: 24),
          _buildColorRow('لون التوقف', d.stoppedColor ?? '#FF0000'),
          const Divider(height: 24),
          _buildColorRow('لون الخمول', d.idleColor ?? '#FFFF00'),
          const Divider(height: 24),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.route, size: 18, color: Colors.grey[700]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'طول ذيل المسار (Tail)',
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
              ),
              Text(
                '${d.tailLength ?? 0} نقطة',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          _buildColorRow('لون ذيل المسار', d.tailColor ?? '#0000FF'),
        ],
      ),
    );
  }

  Widget _buildColorRow(String label, String hexColor) {
    Color color = Colors.grey;
    try {
      String colorString = hexColor.toUpperCase().replaceAll('#', '');
      if (colorString.length == 6) colorString = 'FF$colorString';
      color = Color(int.parse(colorString, radix: 16));
    } catch (_) {}

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.palette, size: 18, color: Colors.grey[700]),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
          ),
        ),
        Text(
          hexColor.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(width: 12),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
        ),
      ],
    );
  }
}
