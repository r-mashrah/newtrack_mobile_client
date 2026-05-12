import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/entities/device_entity.dart';
import '../../../main_map/presentation/providers/devices_provider.dart';

class DeviceList extends ConsumerWidget {
  const DeviceList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsync = ref.watch(devicesNotifierProvider);

    return devicesAsync.when(
      initial: () => const Center(child: CircularProgressIndicator()),
      loading: () => const Center(child: CircularProgressIndicator()),
      loaded: (devices, isRefreshing, filterQuery, statusFilter) {
        if (devices.isEmpty) {
          return const Center(
            child: Text('لا توجد أجهزة متاحة'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: devices.length,
          itemBuilder: (context, index) {
            final device = devices[index];
            return DeviceCard(device: device);
          },
        );
      },
      error: (message, previousDevices) {
        if (previousDevices != null && previousDevices.isNotEmpty) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.red[50],
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'خطأ: $message',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.red),
                      onPressed: () {
                        ref.read(devicesNotifierProvider.notifier).loadDevices();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: previousDevices.length,
                  itemBuilder: (context, index) {
                    final device = previousDevices[index];
                    return DeviceCard(device: device);
                  },
                ),
              ),
            ],
          );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('خطأ: $message'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(devicesNotifierProvider.notifier).loadDevices();
                },
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DeviceCard extends ConsumerWidget {
  final DeviceEntity device;

  const DeviceCard({
    Key? key,
    required this.device,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // الانتقال لتفاصيل الجهاز
          context.push('/device_details/${device.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // أيقونة الجهاز
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getStatusColor(device.displayStatus).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.directions_car,
                      color: _getStatusColor(device.displayStatus),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // معلومات الجهاز الأساسية
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          device.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (device.plateNumber != null)
                          Text(
                            device.plateNumber!,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        Text(
                          'IMEI: ${device.imei}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // حالة الجهاز
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildStatusChip(device.displayStatus),
                      const SizedBox(height: 4),
                      if (device.isOnline)
                        const Icon(Icons.circle, color: Colors.green, size: 12)
                      else
                        const Icon(Icons.circle, color: Colors.red, size: 12),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              // معلومات إضافية
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (device.speed != null)
                    _buildInfoItem(
                      icon: Icons.speed,
                      label: 'السرعة',
                      value: '${device.speed!.toStringAsFixed(1)} كم/س',
                    ),
                  _buildInfoItem(
                    icon: Icons.battery_full,
                    label: 'البطارية',
                    value: device.batteryLevel != null
                        ? '${device.batteryLevel!.toStringAsFixed(0)}%'
                        : 'غير معروف',
                  ),
                  _buildInfoItem(
                    icon: Icons.local_gas_station,
                    label: 'الوقود',
                    value: device.fuelLevel != null
                        ? '${device.fuelLevel!.toStringAsFixed(0)}%'
                        : 'غير معروف',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // معلومات الموقع والتحديث
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'الموقع: ${device.lastLocation.latitude.toStringAsFixed(5)}, ${device.lastLocation.longitude.toStringAsFixed(5)}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatTime(device.lastUpdate),
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              if (device.driverName != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'السائق: ${device.driverName}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 10,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getStatusText(status),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
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
