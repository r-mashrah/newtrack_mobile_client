import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../devices/presentation/screens/device_details_screen.dart';
import '../../../main_map/presentation/providers/devices_provider.dart';
import '../../../../domain/entities/device_entity.dart';

class SMSCommandScreen extends ConsumerStatefulWidget {
  const SMSCommandScreen({super.key});

  @override
  ConsumerState<SMSCommandScreen> createState() => _SMSCommandScreenState();
}

class _SMSCommandScreenState extends ConsumerState<SMSCommandScreen> {
  DeviceEntity? _selectedDevice;
  String _selectedTemplate = "No Template";
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
              'اختر الأجهزة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildDropdownField(
              label: 'الأجهزة',
              value: _selectedDevice?.name ?? '1',
              onTap: () => _showDevicePicker(devices),
            ),
            const SizedBox(height: 24),
            const Text(
              'اختر قالب الرسائل القصيرة*',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildDropdownField(
              label: '',
              value: _selectedTemplate,
              onTap: () => _showTemplatePicker(),
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
                if (label.isNotEmpty) ...[
                  const SizedBox(width: 12),
                  Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
                ],
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

  void _showTemplatePicker() {
    final templates = ["No Template", "قالب 1", "قالب 2", "قالب 3"];
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemCount: templates.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(templates[index], textAlign: TextAlign.right),
          onTap: () {
            setState(() => _selectedTemplate = templates[index]);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
