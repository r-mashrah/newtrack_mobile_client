import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/alert_model.dart';
import '../../../main_map/presentation/providers/devices_provider.dart';
import '../../../tools/presentation/providers/map_objects_provider.dart';
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
  late TextEditingController _overspeedController;
  String? _selectedDeviceId; // الآن يحتفظ بـ ID الجهاز الحقيقي
  String? _selectedDeviceName;
  String? _selectedType;
  bool _insideGeofence = false;
  bool _outsideGeofence = false;
  bool _alertNotification = false;
  bool _commandActive = false;
  bool _isSaving = false;
  String? _selectedGeofenceId;

  final List<String> _types = [
    'overspeed',
    'stop_duration',
    'offline_duration',
    'idle_duration',
    'ignition_duration',
    'geofence_in',
    'geofence_out',
    'geofence_in_out',
    'sos',
    'custom',
    'driver'
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.alert?.name ?? '');
    _overspeedController = TextEditingController(text: widget.alert?.overspeed.toString() ?? '120');
    _selectedDeviceId = widget.alert?.deviceId;
    _selectedDeviceName = widget.alert?.deviceName;
    _selectedType = widget.alert?.type;
    _insideGeofence = widget.alert?.insideGeofence ?? false;
    _outsideGeofence = widget.alert?.outsideGeofence ?? false;
    _commandActive = widget.alert?.commandEnabled ?? false;
    _alertNotification = widget.alert?.notificationType == 'push';
    if (widget.alert?.geofenceIds.isNotEmpty == true) {
      _selectedGeofenceId = widget.alert!.geofenceIds.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _overspeedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final devicesState = ref.watch(devicesNotifierProvider);
    // جلب السياجات الجغرافية لعرضها في قائمة منسدلة عند الحاجة
    // استخدمنا قراءة المزود مباشرة بافتراض أنه تم تهيئته في مكان آخر، أو سيتم استدعاؤه هنا
    final geofencesAsync = ref.watch(geofencesProvider);

    return Scaffold(
      backgroundColor: AppColors.white1,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save, color: AppColors.primary),
          onPressed: _isSaving ? null : _saveAlert,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.primary),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        title: Text(
          widget.alert == null ? 'إضافة تنبيه' : 'تعديل تنبيه',
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
              const Text('الاسم', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'اسم التنبيه (مطلوب)',
                  border: UnderlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 16),

              // قائمة الأجهزة الحقيقية
              const Text('الأجهزة', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              devicesState.when(
                initial: () => const Center(child: Text('جاري التحميل...')),
                loading: () => const Center(child: CircularProgressIndicator()),
                loaded: (devices, isRefreshing, filterQuery, statusFilter) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedDeviceId,
                        isExpanded: true,
                        hint: const Text('اختر جهاز'),
                        items: devices.map((device) {
                          return DropdownMenuItem<String>(
                            value: device.id,
                            child: Text(device.name),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedDeviceId = val;
                            _selectedDeviceName = devices
                                .firstWhere((d) => d.id == val)
                                .name;
                          });
                        },
                      ),
                    ),
                  );
                },
                error: (message, previousDevices) => Text(
                  'خطأ في تحميل الأجهزة: $message',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              const Text(
                'يجب اختيار جهاز واحد على الأقل لتفعيل التنبيه المخصص',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              _buildDropdownField(
                label: 'النوع',
                value: _selectedType,
                items: _types,
                onChanged: (val) {
                  setState(() {
                    _selectedType = val;
                    // تصفير القيم المتعلقة عند تغيير النوع لتجنب أخطاء السيرفر
                    if (!val!.contains('geofence')) {
                      _selectedGeofenceId = null;
                    }
                  });
                },
                hint: 'اختر نوع التنبيه',
              ),
              const Text(
                'حدد نوع التنبيه المطلوب من القائمة أعلاه.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),

              // حقول ديناميكية بناءً على النوع المختار
              if (_selectedType == 'overspeed' || 
                  _selectedType == 'stop_duration' || 
                  _selectedType == 'offline_duration' || 
                  _selectedType == 'idle_duration' || 
                  _selectedType == 'ignition_duration') ...[
                const SizedBox(height: 24),
                Text(
                  _selectedType == 'overspeed' ? 'السرعة الزائدة (كم/س)' : 'المدة الزمنية (بالدقائق)', 
                  style: const TextStyle(fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _overspeedController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: _selectedType == 'overspeed' ? 'مثال: 120' : 'مثال: 15',
                    border: const UnderlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'هذا الحقل مطلوب';
                    }
                    if (int.tryParse(val) == null) {
                      return 'قيمة غير صالحة';
                    }
                    return null;
                  },
                ),
              ],

              if ((_selectedType != null && _selectedType!.contains('geofence')) || _insideGeofence || _outsideGeofence) ...[
                const SizedBox(height: 24),
                const Text('اختيار السياج الجغرافي', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                geofencesAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Text('فشل في جلب السياجات: $e', style: const TextStyle(color: Colors.red)),
                  data: (geofences) {
                    if (geofences.isEmpty) {
                      return const Text('لا يوجد سياجات جغرافية حالياً. قم بإنشاء سياج أولاً.', style: TextStyle(color: Colors.orange));
                    }
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedGeofenceId,
                          isExpanded: true,
                          hint: const Text('اختر سياجاً جغرافياً'),
                          items: geofences.map((g) {
                            return DropdownMenuItem<String>(
                              value: g.id,
                              child: Text(g.name),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedGeofenceId = val),
                        ),
                      ),
                    );
                  },
                ),
                if (_selectedGeofenceId == null)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text('السياج الجغرافي مطلوب لهذا الإعداد', style: TextStyle(color: Colors.red, fontSize: 12)),
                  ),
              ],

              const SizedBox(height: 24),
              const Text('إعدادات إضافية', style: TextStyle(fontWeight: FontWeight.bold)),
              CheckboxListTile(
                title: const Text('داخل الحدود (Inside)'),
                value: _insideGeofence,
                onChanged: (val) => setState(() {
                  _insideGeofence = val!;
                  if (val) _outsideGeofence = false; // لا يمكن أن يكون داخل وخارج معاً في GPSWox عادة
                  if (!val && !_outsideGeofence && _selectedType != null && !_selectedType!.contains('geofence')) {
                    _selectedGeofenceId = null;
                  }
                }),
                controlAffinity: ListTileControlAffinity.trailing,
              ),
              CheckboxListTile(
                title: const Text('خارج الحدود (Outside)'),
                value: _outsideGeofence,
                onChanged: (val) => setState(() {
                  _outsideGeofence = val!;
                  if (val) _insideGeofence = false;
                  if (!val && !_insideGeofence && _selectedType != null && !_selectedType!.contains('geofence')) {
                    _selectedGeofenceId = null;
                  }
                }),
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
                  title: const Text('استلام إشعارات Push'),
                  value: _alertNotification,
                  onChanged: (val) => setState(() => _alertNotification = val!),
                  controlAffinity: ListTileControlAffinity.trailing,
                ),
              ),
              const Text(
                'تفعيل إشعارات التطبيق المباشرة (Push Notifications).',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              const Text('الأوامر', style: TextStyle(fontWeight: FontWeight.bold)),
              CheckboxListTile(
                title: const Text('تفعيل الأوامر (Active)'),
                value: _commandActive,
                onChanged: (val) => setState(() => _commandActive = val!),
                controlAffinity: ListTileControlAffinity.trailing,
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

  void _saveAlert() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDeviceId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى اختيار جهاز'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      bool needsGeofence = (_selectedType != null && _selectedType!.contains('geofence')) || _insideGeofence || _outsideGeofence;
      if (needsGeofence && _selectedGeofenceId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى اختيار السياج الجغرافي المطلوب'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() => _isSaving = true);

      final newAlert = AlertModel(
        id: widget.alert?.id ?? '',
        name: _nameController.text,
        deviceId: _selectedDeviceId!,
        deviceName: _selectedDeviceName ?? '',
        type: _selectedType ?? 'custom',
        insideGeofence: _insideGeofence,
        outsideGeofence: _outsideGeofence,
        notificationType: _alertNotification ? 'push' : 'none',
        isActive: widget.alert?.isActive ?? true,
        commandEnabled: _commandActive,
        overspeed: int.tryParse(_overspeedController.text) ?? 120,
        geofenceIds: _selectedGeofenceId != null ? [_selectedGeofenceId!] : [],
      );

      try {
        if (widget.alert == null) {
          await ref.read(alertsProvider.notifier).addAlert(newAlert);
        } else {
          await ref.read(alertsProvider.notifier).updateAlert(newAlert);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.alert == null ? 'تم إضافة التنبيه بنجاح' : 'تم تحديث التنبيه بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isSaving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('فشل في الحفظ: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
