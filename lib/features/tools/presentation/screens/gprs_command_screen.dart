import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../devices/presentation/screens/device_details_screen.dart';
import '../../../main_map/presentation/providers/devices_provider.dart';
import '../../../../domain/entities/device_entity.dart';

class GPRSCommandScreen extends ConsumerStatefulWidget {
  const GPRSCommandScreen({super.key});

  @override
  ConsumerState<GPRSCommandScreen> createState() => _GPRSCommandScreenState();
}

class _GPRSCommandScreenState extends ConsumerState<GPRSCommandScreen> {
  DeviceEntity? _selectedDevice;
  String _selectedCommand = "أمر مخصص";
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final devicesState = ref.watch(devicesProvider);
    final devices = devicesState.maybeWhen(

      data: (devices) => devices,
      orElse: () => <DeviceEntity>[],
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildCircleButton(
            icon: Icons.share,
            onTap: () {
              // Share logic
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildCircleButton(
              icon: Icons.arrow_forward,
              onTap: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'اختر الأجهزة*',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildDropdownField(
              label: 'الأجهزة',
              value: _selectedDevice?.name ?? 'test',
              onTap: () => _showDevicePicker(devices),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select command*',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildDropdownField(
              label: 'أمر مخصص',
              value: _selectedCommand,
              onTap: () => _showCommandPicker(),
            ),
            const SizedBox(height: 24),
            const Text(
              'رسالة',
              style: TextStyle(fontSize: 14, color: AppColors.primary),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _messageController,
              maxLines: 5,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'الرقم التعريفي للجهاز [%IMEI%] يمكنك استخدام القيم التالية:<br><br>تدعم النص فقط RAW لاوامر',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 12, color: Colors.cyan),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({required String label, required String value, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.chevron_left, color: AppColors.primary),
            Row(
              children: [
                Text(value, style: const TextStyle(color: AppColors.primary)),
                const SizedBox(width: 12),
                Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton({required IconData icon, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.primary),
        onPressed: onTap,
      ),
    );
  }

  void _showDevicePicker(List<DeviceEntity> devices) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(devices[index].name, textAlign: TextAlign.right),
          onTap: () {
            setState(() => _selectedDevice = devices[index]);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _showCommandPicker() {
    final commands = ["أمر مخصص", "إيقاف المحرك", "تشغيل المحرك", "ضبط السرعة"];
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemCount: commands.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(commands[index], textAlign: TextAlign.right),
          onTap: () {
            setState(() => _selectedCommand = commands[index]);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
