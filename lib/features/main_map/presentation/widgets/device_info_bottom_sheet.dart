import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/device_entity.dart';
import '../../../history/presentation/providers/history_provider.dart';
import '../../../tools/presentation/screens/gprs_command_screen.dart';
import '../../../tools/presentation/screens/sms_command_screen.dart';
import '../providers/devices_provider.dart';

class DeviceInfoBottomSheet extends ConsumerWidget {
  final DeviceEntity device;

  const DeviceInfoBottomSheet({Key? key, required this.device})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesState = ref.watch(devicesNotifierProvider);
    final currentDevice = devicesState.maybeMap(
      loaded: (state) => state.devices.firstWhere(
        (d) => d.id == device.id,
        orElse: () => device,
      ),
      orElse: () => device,
    );

    return SafeArea(
      bottom: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
          ],
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Hugs content tightly, NO vertical scroll
          children: [
            _buildDragHandle(),
            _buildHeader(context, currentDevice),
            const Divider(height: 16, indent: 16, endIndent: 16),
            const SizedBox(height: 8),

            // Quick Actions (Horizontal Scroll Only)
            _buildQuickActions(context, ref, currentDevice),
            const SizedBox(height: 16),

            // Summary Cards (Fixed Grid)
            _buildQuickSummaryCards(currentDevice),
            const SizedBox(height: 16),

            // Fixed Bottom Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.push('/device_details/${currentDevice.id}');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.blue[50],
                  foregroundColor: Colors.blue[800],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'عرض لوحة المراقبة الكاملة',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, DeviceEntity d) {
    final statusColor = _getDeviceStatusColor(d);
    final isMoving = d.speed != null && d.speed! > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.directions_car, color: statusColor, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  d.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (d.plateNumber != null && d.plateNumber!.isNotEmpty)
                  Text(
                    d.plateNumber!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                const SizedBox(height: 4),
                Row(
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
                    const SizedBox(width: 12),
                    Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(d.lastUpdate),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'بالقرب من ${d.lastLocation.latitude.toStringAsFixed(3)}, ${d.lastLocation.longitude.toStringAsFixed(3)}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isMoving)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${d.speed!.toInt()} كم/س',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.copy, size: 20, color: Colors.grey),
              onPressed: () {
                HapticFeedback.selectionClick();
                Clipboard.setData(
                  ClipboardData(
                    text:
                        '${d.lastLocation.latitude}, ${d.lastLocation.longitude}',
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم نسخ الإحداثيات')),
                );
              },
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildActionBtn(context, Icons.history, 'السجل', () {
            ref.read(historyPageProvider.notifier).selectDevice(d.id);
            ref.read(historyPageProvider.notifier).fetchTrips();
            Navigator.pop(context);
            context.push('/history');
          }),
          _buildActionBtn(context, Icons.play_arrow, 'تشغيل المسار', () {
            ref.read(historyPageProvider.notifier).selectDevice(d.id);
            ref.read(historyPageProvider.notifier).fetchTrips();
            Navigator.pop(context);
            context.push('/history');
          }),
          _buildActionBtn(context, Icons.navigation, 'انتقال', () {}),
          _buildActionBtn(context, Icons.terminal, 'أوامر', () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GPRSCommandScreen(preSelectedDevice: d),
              ),
            );
          }),
          _buildActionBtn(context, Icons.sms, 'SMS', () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SMSCommandScreen(preSelectedDevice: d),
              ),
            );
          }),
          _buildActionBtn(context, Icons.phone, 'اتصال', () {}),
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
      padding: const EdgeInsets.only(left: 16.0),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.black87),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSummaryCards(DeviceEntity d) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 2.2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: [
          _buildSummaryCard(
            Icons.speed,
            'السرعة',
            d.speed != null && d.speed! > 0 ? '${d.speed!.toInt()} كم/س' : '--',
          ),
          _buildSummaryCard(
            Icons.timer,
            'مدة التوقف',
            d.speed == null || d.speed! == 0 ? _timeSince(d.lastUpdate) : '--',
          ),
          _buildSummaryCard(
            Icons.satellite_alt,
            'GPS',
            d.status != 'offline' ? 'متصل' : '--',
          ),
          _buildSummaryCard(
            Icons.battery_charging_full,
            'البطارية',
            d.batteryLevel != null ? '${d.batteryLevel!.toInt()}%' : '--',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
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
}
