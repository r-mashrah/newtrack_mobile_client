import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/device_entity.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';

// If the real provider exported from
// features/main_map/presentation/providers/devices_provider.dart
// has a different name, remove this placeholder and import the correct provider.
// Temporary placeholder provider to satisfy references in this file.
final devicesProvider = FutureProvider<List<DeviceEntity>>((ref) async {
  return <DeviceEntity>[];
});

class DeviceDetailsScreen extends ConsumerWidget {
  final String deviceId;

  const DeviceDetailsScreen({Key? key, required this.deviceId})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final deviceAsync = ref
        .watch(devicesProvider)
        .whenData(
          (devices) => devices.firstWhere(
            (d) => d.id == deviceId,
            orElse: () => throw Exception('Device not found'),
          ),
        );

    return Scaffold(
      appBar: AppBar(title: Text(loc.deviceDetailsTitle), centerTitle: true),
      body: deviceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('${loc.errorPrefix}: $err')),
        data: (device) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(device, loc),
                const SizedBox(height: 24),
                _buildDetailsCard(device, loc),
                const SizedBox(height: 24),
                _buildAdvancedCard(device, loc),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(DeviceEntity device, AppLocalizations loc) {
    return Row(
      children: [
        // Placeholder for Marker Image
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.directions_car,
            size: 36,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                device.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              Text(
                '${loc.deviceDetailsImei}: ${device.imei}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.materialGrey700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsCard(DeviceEntity device, AppLocalizations loc) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(loc.deviceDetailsPlate, device.plateNumber ?? '-'),
            _buildDetailRow(loc.deviceDetailsSim, device.simNumber ?? '-'),
            _buildDetailRow(loc.deviceDetailsModel, device.model ?? '-'),
            _buildDetailRow(
              loc.deviceDetailsGroup,
              device.group ?? loc.groupUngrouped,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedCard(DeviceEntity device, AppLocalizations loc) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.deviceColors,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const Divider(),
            _buildColorRow(loc.deviceDetailsMovingColor, device.movingColor),
            _buildColorRow(loc.deviceDetailsStoppedColor, device.stoppedColor),
            _buildColorRow(
              loc.deviceDetailsDisconnectedColor,
              device.disconnectedColor,
            ),
            _buildColorRow(loc.deviceDetailsIdleColor, device.idleColor),
            const SizedBox(height: 16),
            Text(
              loc.tailTab,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const Divider(),
            _buildDetailRow(
              loc.deviceDetailsTailLength,
              '${device.tailLength ?? 0} ${loc.tailLength}',
            ),
            _buildColorRow(loc.deviceDetailsTailColor, device.tailColor),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.materialGrey700,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorRow(String label, String? hexColor) {
    Color color = Colors.grey;
    String displayValue = '-';

    if (hexColor != null) {
      try {
        String colorString = hexColor.toUpperCase().replaceAll('#', '');
        if (colorString.length == 6) {
          colorString = 'FF$colorString';
        }
        color = Color(int.parse(colorString, radix: 16));
        displayValue = hexColor;
      } catch (_) {
        // Keep default grey if parsing fails
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.materialGrey700,
            ),
          ),
          Row(
            children: [
              Text(
                displayValue,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.materialGrey400,
                    width: 1,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
