import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/alert_model.dart';
import '../providers/alerts_provider.dart';

class AddEditAlertScreen extends ConsumerStatefulWidget {
  final AlertModel? alert;
  const AddEditAlertScreen({super.key, this.alert});

  @override
  ConsumerState<AddEditAlertScreen> createState() => _AddEditAlertScreenState();
}

class _AddEditAlertScreenState extends ConsumerState<AddEditAlertScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  String? _selectedDeviceId;
  String? _selectedType;
  bool _insideGeofence = false;
  bool _outsideGeofence = false;
  bool _alertNotification = false;
  bool _commandActive = false;

  final List<String> _devices = ['Toyota Camry', 'Mercedes Actros', 'Volvo FH16'];
  final List<String> _types = ['Over Speed', 'Geofence', 'Ignition On/Off', 'Fuel Theft'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.alert?.name ?? '');
    _selectedDeviceId = widget.alert?.deviceName;
    _selectedType = widget.alert?.type;
    _insideGeofence = widget.alert?.insideGeofence ?? false;
    _outsideGeofence = widget.alert?.outsideGeofence ?? false;
    _commandActive = widget.alert?.commandEnabled ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white1,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.save, color: AppColors.primary),
          onPressed: _saveAlert,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.primary),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        title: Text(
          widget.alert == null ? 'Add Alert' : 'Edit Alert',
          style: const TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('الأجهزة', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Name(required)',
                  border: UnderlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'الأجهزة',
                value: _selectedDeviceId,
                items: _devices,
                onChanged: (val) => setState(() => _selectedDeviceId = val),
                hint: '0',
              ),
              const Text(
                'To see custom events must be selected at least one device',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              _buildDropdownField(
                label: 'النوع',
                value: _selectedType,
                items: _types,
                onChanged: (val) => setState(() => _selectedType = val),
                hint: 'النوع',
              ),
              const Text(
                'Define your event trigger type.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              const Text('الحدود الجغرافية', style: TextStyle(fontWeight: FontWeight.bold)),
              CheckboxListTile(
                title: const Text('داخل الحدود'),
                value: _insideGeofence,
                onChanged: (val) => setState(() => _insideGeofence = val!),
                controlAffinity: ListTileControlAffinity.trailing,
              ),
              CheckboxListTile(
                title: const Text('خارج الحدود'),
                value: _outsideGeofence,
                onChanged: (val) => setState(() => _outsideGeofence = val!),
                controlAffinity: ListTileControlAffinity.trailing,
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: CheckboxListTile(
                  title: const Text('التنبيهات'),
                  value: _alertNotification,
                  onChanged: (val) => setState(() => _alertNotification = val!),
                  controlAffinity: ListTileControlAffinity.trailing,
                ),
              ),
              const Text(
                'Configure alert notification types.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              const Text('الأمر', style: TextStyle(fontWeight: FontWeight.bold)),
              CheckboxListTile(
                title: const Text('Active'),
                value: _commandActive,
                onChanged: (val) => setState(() => _commandActive = val!),
                controlAffinity: ListTileControlAffinity.trailing,
              ),
              const Text(
                'Configure command that will be triggered when alert fires.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text(hint),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  void _saveAlert() {
    if (_formKey.currentState!.validate()) {
      final newAlert = AlertModel(
        id: widget.alert?.id ?? '',
        name: _nameController.text,
        deviceId: 'dev_id',
        deviceName: _selectedDeviceId ?? 'Unknown',
        type: _selectedType ?? 'General',
        insideGeofence: _insideGeofence,
        outsideGeofence: _outsideGeofence,
        notificationType: 'Push',
        isActive: widget.alert?.isActive ?? true,
        commandEnabled: _commandActive,
      );

      if (widget.alert == null) {
        ref.read(alertsProvider.notifier).addAlert(newAlert);
      } else {
        ref.read(alertsProvider.notifier).updateAlert(newAlert);
      }
      Navigator.pop(context);
    }
  }
}
