import 'package:flutter/material.dart';
import '../../../../domain/entities/device_entity.dart';

class DeviceInfoBottomSheet extends StatelessWidget {
  final DeviceEntity device;

  const DeviceInfoBottomSheet({
    Key? key,
    required this.device,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.directions_car,
                size: 40,
                color: _getStatusColor(device.displayStatus),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'رقم اللوحة: ${device.plateNumber ?? 'غير محدد'}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              _buildStatusChip(device.displayStatus),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.gps_fixed,
            label: 'الموقع',
            value: '${device.lastLocation.latitude.toStringAsFixed(5)}, '
                  '${device.lastLocation.longitude.toStringAsFixed(5)}',
          ),
          if (device.speed != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.speed,
              label: 'السرعة',
              value: '${device.speed!.toStringAsFixed(1)} كم/س',
            ),
          ],
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.access_time,
            label: 'آخر تحديث',
            value: _formatTime(device.lastUpdate),
          ),
          if (device.driverName != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.person,
              label: 'السائق',
              value: device.driverName!,
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // عرض سجل المسار
                    Navigator.pop(context);
                  },
                  child: const Text('سجل المسار'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // عرض تفاصيل الجهاز
                    Navigator.pop(context);
                  },
                  child: const Text('تفاصيل الجهاز'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(color: Colors.grey[600]),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    final color = _getStatusColor(status);
    return Chip(
      label: Text(
        _getStatusText(status),
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
    );
  }

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

  String _formatTime(DateTime? time) {
    if (time == null) return 'غير متاح';

    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 1) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inDays < 1) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return 'منذ ${difference.inDays} يوم';
    }
  }
}
