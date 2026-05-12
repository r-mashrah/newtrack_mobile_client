import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/device_entity.dart';
import 'map_utilities_manager.dart';

/// Widget لعرض إحصائيات المسار
class TrailStatisticsWidget extends ConsumerWidget {
  final DeviceEntity device;

  const TrailStatisticsWidget({
    Key? key,
    required this.device,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = MapUtilitiesManager.calculateTrailStatistics(device);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // عنوان القسم
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.timeline,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'إحصائيات المسار',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // شبكة الإحصائيات
          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildStatCard(
                  context,
                  label: 'المسافة الكلية',
                  value: '${stats.totalDistance.toStringAsFixed(2)} كم',
                  icon: Icons.route,
                  color: Colors.blue,
                ),
                _buildStatCard(
                  context,
                  label: 'متوسط السرعة',
                  value: '${stats.averageSpeed.toStringAsFixed(2)} كم/س',
                  icon: Icons.speed,
                  color: Colors.green,
                ),
                _buildStatCard(
                  context,
                  label: 'أقصى سرعة',
                  value: '${stats.maxSpeed.toStringAsFixed(2)} كم/س',
                  icon: Icons.trending_up,
                  color: Colors.orange,
                ),
                _buildStatCard(
                  context,
                  label: 'أدنى سرعة',
                  value: '${stats.minSpeed.toStringAsFixed(2)} كم/س',
                  icon: Icons.trending_down,
                  color: Colors.red,
                ),
              ],
            ),
          ),

          // معلومات إضافية
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'عدد النقاط',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${stats.pointCount} نقطة',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'حالة الجهاز',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(device.displayStatus),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _getStatusText(device.displayStatus),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  /// بناء بطاقة الإحصائية
  Widget _buildStatCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// الحصول على لون الحالة
  Color _getStatusColor(String status) {
    switch (status) {
      case 'moving':
        return Colors.green;
      case 'stopped':
        return Colors.orange;
      case 'offline':
        return Colors.red;
      case 'parked':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  /// الحصول على نص الحالة
  String _getStatusText(String status) {
    switch (status) {
      case 'moving':
        return 'متحرك';
      case 'stopped':
        return 'متوقف';
      case 'offline':
        return 'غير متصل';
      case 'parked':
        return 'مركون';
      default:
        return 'غير معروف';
    }
  }
}
