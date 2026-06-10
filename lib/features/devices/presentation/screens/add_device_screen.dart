import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/device_entity.dart';
import '../../../../domain/entities/location_entity.dart';
import '../../../main_map/presentation/providers/devices_provider.dart';
import '../../../setup/presentation/providers/setup_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../../core/providers/api_client_provider.dart';
import '../../../../core/constants/api_constants.dart';
import 'package:dio/dio.dart';

class AddDeviceScreen extends ConsumerStatefulWidget {
  static const routeName = '/add-device';
  final DeviceEntity? device;
  const AddDeviceScreen({super.key, this.device});

  @override
  ConsumerState<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends ConsumerState<AddDeviceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imeiController = TextEditingController();
  final _plateNumberController = TextEditingController();
  final _simNumberController = TextEditingController();
  final _modelController = TextEditingController();
  final _vinController = TextEditingController();
  final _assetNumberController = TextEditingController();
  final _ownerManagerController = TextEditingController();
  final _notesController = TextEditingController();
  final _minSpeedController = TextEditingController(text: '1');
  final _minFuelFillController = TextEditingController(text: '1');
  final _minFuelTheftController = TextEditingController(text: '1');
  final _tailLengthController = TextEditingController(text: '10');

  String _selectedMarkerImage = 'car';
  bool _hasExpirationDate = false;
  String _selectedGroup = 'Ungrouped';
  String _selectedTimeAdjustment = 'UTC +3:00';
  String _selectedMeasurement = 'l/100km';
  Color _tailColor = const Color(0xFF63f542);

  Color _movingColor = Colors.green;
  Color _stoppedColor = Colors.red;
  Color _disconnectedColor = Colors.grey;
  Color _idleColor = Colors.yellow;

  bool _isSaving = false;

  final List<Map<String, dynamic>> _markerOptions = [
    {'id': 'car', 'icon': Icons.directions_car, 'label': 'سيارة'},
    {'id': 'truck', 'icon': Icons.local_shipping, 'label': 'شاحنة'},
    {'id': 'bus', 'icon': Icons.directions_bus, 'label': 'حافلة'},
    {'id': 'motorcycle', 'icon': Icons.two_wheeler, 'label': 'دراجة'},
    {'id': 'person', 'icon': Icons.person, 'label': 'شخص'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.device != null) {
      final d = widget.device!;
      _nameController.text = d.name;
      _imeiController.text = d.imei;
      _plateNumberController.text = d.plateNumber ?? '';
      _simNumberController.text = d.simNumber ?? '';
      _modelController.text = d.model ?? '';
      _selectedMarkerImage = d.markerImage ?? d.icon ?? 'car';
      _selectedGroup = d.group ?? 'Ungrouped';
      
      if (d.movingColor != null) _movingColor = _hexToColor(d.movingColor!);
      if (d.stoppedColor != null) _stoppedColor = _hexToColor(d.stoppedColor!);
      if (d.disconnectedColor != null) _disconnectedColor = _hexToColor(d.disconnectedColor!);
      if (d.idleColor != null) _idleColor = _hexToColor(d.idleColor!);
      if (d.tailColor != null) _tailColor = _hexToColor(d.tailColor!);
      _tailLengthController.text = d.tailLength?.toString() ?? '10';

      if (d.additionalData != null) {
        if (d.additionalData!['vin'] != null) {
          _vinController.text = d.additionalData!['vin'].toString();
        }
        if (d.additionalData!['asset_number'] != null) {
          _assetNumberController.text = d.additionalData!['asset_number'].toString();
        }
        if (d.additionalData!['owner_manager'] != null) {
          _ownerManagerController.text = d.additionalData!['owner_manager'].toString();
        }
        if (d.additionalData!['min_moving_speed'] != null) {
          _minSpeedController.text = d.additionalData!['min_moving_speed'].toString();
        }
        if (d.additionalData!['min_fuel_fillings'] != null) {
          _minFuelFillController.text = d.additionalData!['min_fuel_fillings'].toString();
        }
        if (d.additionalData!['min_fuel_thefts'] != null) {
          _minFuelTheftController.text = d.additionalData!['min_fuel_thefts'].toString();
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imeiController.dispose();
    _plateNumberController.dispose();
    _simNumberController.dispose();
    _modelController.dispose();
    _vinController.dispose();
    _assetNumberController.dispose();
    _ownerManagerController.dispose();
    _notesController.dispose();
    _minSpeedController.dispose();
    _minFuelFillController.dispose();
    _minFuelTheftController.dispose();
    _tailLengthController.dispose();
    super.dispose();
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  Color _hexToColor(String hexCode) {
    String colorString = hexCode.toUpperCase().replaceAll('#', '');
    if (colorString.length == 6) colorString = 'FF$colorString';
    return Color(int.parse(colorString, radix: 16));
  }

  Future<Color?> _showColorPickerDialog(Color initialColor) async {
    return showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        Color tempColor = initialColor;
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.selectColor, textAlign: TextAlign.right),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              alignment: WrapAlignment.center,
              children: [
                Colors.red, Colors.blue, Colors.green, Colors.yellow,
                Colors.purple, Colors.orange, Colors.teal, Colors.brown,
                Colors.grey, Colors.black, Colors.white,
              ].map((color) {
                return GestureDetector(
                  onTap: () {
                    tempColor = color;
                    Navigator.of(context).pop(tempColor);
                  },
                  child: Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black12, width: 2),
                      boxShadow: [
                        BoxShadow(color: color.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _selectColor(Color initialColor, Function(Color) onColorSelected) async {
    final selectedColor = await _showColorPickerDialog(initialColor);
    if (selectedColor != null) {
      onColorSelected(selectedColor);
    }
  }

  Future<void> _saveDevice() async {
    final loc = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.errorPrefix, textAlign: TextAlign.right), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isSaving = true);

    final newDevice = DeviceEntity(
      id: widget.device?.id ?? '',
      name: _nameController.text,
      imei: _imeiController.text,
      lastLocation: widget.device?.lastLocation ?? LocationEntity(latitude: 0.0, longitude: 0.0, timestamp: DateTime.now()),
      plateNumber: _plateNumberController.text.isEmpty ? null : _plateNumberController.text,
      simNumber: _simNumberController.text.isEmpty ? null : _simNumberController.text,
      model: _modelController.text.isEmpty ? null : _modelController.text,
      group: _selectedGroup == loc.groupUngrouped || _selectedGroup == 'Ungrouped' ? null : _selectedGroup,
      movingColor: _colorToHex(_movingColor),
      stoppedColor: _colorToHex(_stoppedColor),
      disconnectedColor: _colorToHex(_disconnectedColor),
      idleColor: _colorToHex(_idleColor),
      markerImage: _selectedMarkerImage,
      tailColor: _colorToHex(_tailColor),
      tailLength: int.tryParse(_tailLengthController.text) ?? 0,
      status: widget.device?.status ?? 'offline',
      isActive: widget.device?.isActive ?? true,
      speed: widget.device?.speed ?? 0.0,
      lastUpdate: widget.device?.lastUpdate ?? DateTime.now(),
      additionalData: {
        ...(widget.device?.additionalData ?? {}),
        'icon_id': 1,
        'fuel_measurement_id': 1,
        'tail_length': int.tryParse(_tailLengthController.text) ?? 5,
        'min_moving_speed': int.tryParse(_minSpeedController.text) ?? 6,
        'min_fuel_fillings': int.tryParse(_minFuelFillController.text) ?? 10,
        'min_fuel_thefts': int.tryParse(_minFuelTheftController.text) ?? 10,
        'vin': _vinController.text.isEmpty ? null : _vinController.text,
        'asset_number': _assetNumberController.text.isEmpty ? null : _assetNumberController.text,
        'owner_manager': _ownerManagerController.text.isEmpty ? null : _ownerManagerController.text,
      },
    );

    try {
      if (widget.device != null) {
        final updateDeviceUseCase = ref.read(updateDeviceUseCaseProvider);
        await updateDeviceUseCase.call(newDevice);
      } else {
        final addDeviceUseCase = ref.read(addDeviceUseCaseProvider);
        await addDeviceUseCase.call(newDevice);
      }

      ref.read(devicesNotifierProvider.notifier).loadDevices();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.device != null 
                ? 'تم تعديل المركبة "${newDevice.name}" بنجاح' 
                : 'تمت إضافة المركبة "${newDevice.name}" بنجاح', 
              textAlign: TextAlign.right
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل الحفظ: ${e.toString()}', textAlign: TextAlign.right),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light, clean background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.device != null 
            ? 'تعديل ${widget.device!.name}' 
            : (loc.addDeviceTitle ?? 'إضافة مركبة جديدة'),
          style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildSectionTitle('البيانات الأساسية'),
                      const SizedBox(height: 12),
                      _buildPrimaryDataCard(loc),
                      
                      const SizedBox(height: 24),
                      
                      _buildSectionTitle('المظهر على الخريطة'),
                      const SizedBox(height: 12),
                      _buildAppearanceCard(loc),

                      const SizedBox(height: 24),

                      _buildSectionTitle('تفاصيل إضافية (اختياري)'),
                      const SizedBox(height: 12),
                      _buildVehicleDetailsCard(loc),

                      const SizedBox(height: 24),

                      _buildAdvancedSettingsAccordion(loc),
                      const SizedBox(height: 40), // Padding before button
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomSaveButton(loc),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }

  Widget _buildPrimaryDataCard(AppLocalizations loc) {
    return _buildSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildModernInputField(
            label: 'اسم المركبة / الجهاز*',
            hint: loc.objectName,
            controller: _nameController,
            icon: Icons.directions_car_outlined,
            isRequired: true,
          ),
          const SizedBox(height: 16),
          _buildModernInputField(
            label: 'الرقم التسلسلي (IMEI)*',
            hint: loc.objectImei,
            controller: _imeiController,
            icon: Icons.qr_code_scanner,
            keyboardType: TextInputType.number,
            isRequired: true,
          ),
          const SizedBox(height: 16),
          _buildModernDropdown(
            label: loc.group,
            value: _selectedGroup == 'Ungrouped' ? loc.groupUngrouped : _selectedGroup,
            icon: Icons.folder_open,
            onTap: () => _showGroupPicker(loc),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceCard(AppLocalizations loc) {
    return _buildSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('شكل الأيقونة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              reverse: true, // RTL
              itemCount: _markerOptions.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final option = _markerOptions[index];
                final isSelected = _selectedMarkerImage == option['id'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedMarkerImage = option['id']),
                  child: Column(
                    children: [
                      Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.grey.shade50,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Icon(option['icon'], color: isSelected ? AppTheme.primaryColor : Colors.grey.shade600),
                      ),
                      const SizedBox(height: 4),
                      Text(option['label'], style: TextStyle(fontSize: 10, color: isSelected ? AppTheme.primaryColor : Colors.grey.shade600, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleDetailsCard(AppLocalizations loc) {
    return _buildSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildModernInputField(label: loc.plateNumber, hint: 'مثال: 123-ABC', controller: _plateNumberController, icon: Icons.pin),
          const SizedBox(height: 16),
          _buildModernInputField(label: loc.simNumber, hint: loc.simNumber, controller: _simNumberController, icon: Icons.sim_card, keyboardType: TextInputType.phone),
          const SizedBox(height: 16),
          _buildModernInputField(label: loc.deviceModel, hint: loc.deviceModel, controller: _modelController, icon: Icons.memory),
          const SizedBox(height: 16),
          _buildModernInputField(label: loc.vin, hint: loc.vin, controller: _vinController, icon: Icons.directions_car),
          const SizedBox(height: 16),
          _buildModernInputField(label: loc.registrationAssetNumber, hint: loc.registrationAssetNumber, controller: _assetNumberController, icon: Icons.confirmation_number),
          const SizedBox(height: 16),
          _buildModernInputField(label: loc.objectOwnerManager, hint: loc.objectOwnerManager, controller: _ownerManagerController, icon: Icons.person),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettingsAccordion(AppLocalizations loc) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: AppTheme.primaryColor,
          collapsedIconColor: Colors.grey,
          title: const Text('إعدادات متقدمة', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
          leading: const Icon(Icons.settings_suggest, color: AppTheme.primaryColor),
          childrenPadding: const EdgeInsets.all(20),
          children: [
            const Text('ألوان الحالات على الخريطة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildColorCircle(loc.idleColor, _idleColor, () => _selectColor(_idleColor, (c) => setState(() => _idleColor = c))),
                _buildColorCircle(loc.disconnectedColor, _disconnectedColor, () => _selectColor(_disconnectedColor, (c) => setState(() => _disconnectedColor = c))),
                _buildColorCircle(loc.stoppedColor, _stoppedColor, () => _selectColor(_stoppedColor, (c) => setState(() => _stoppedColor = c))),
                _buildColorCircle(loc.movingColor, _movingColor, () => _selectColor(_movingColor, (c) => setState(() => _movingColor = c))),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildColorCircle(loc.tailColor, _tailColor, () => _selectColor(_tailColor, (c) => setState(() => _tailColor = c))),
              ],
            ),
            const Divider(height: 32),
            SwitchListTile(
              title: Text(loc.hasExpirationDate, textAlign: TextAlign.right, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              value: _hasExpirationDate,
              activeColor: AppTheme.primaryColor,
              onChanged: (val) => setState(() => _hasExpirationDate = val),
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(height: 32),
            _buildModernInputField(label: loc.minimalMovingSpeed, hint: '6', controller: _minSpeedController, icon: Icons.speed, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildModernInputField(label: loc.tailLength, hint: '10', controller: _tailLengthController, icon: Icons.route, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildModernDropdown(label: loc.timeAdjustment, value: _selectedTimeAdjustment, icon: Icons.access_time, onTap: () => _showTimeAdjustmentPicker(loc)),
            const Divider(height: 32),
            const Text('إعدادات الوقود (اختياري)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 12),
            _buildModernDropdown(label: loc.measurementI100km, value: _selectedMeasurement, icon: Icons.local_gas_station, onTap: () => _showMeasurementPicker(loc)),
            const SizedBox(height: 16),
            _buildModernInputField(label: loc.minimalFuelDifferenceFillings, hint: '1', controller: _minFuelFillController, icon: Icons.ev_station, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildModernInputField(label: loc.minimalFuelDifferenceThefts, hint: '1', controller: _minFuelTheftController, icon: Icons.warning_amber_rounded, keyboardType: TextInputType.number),
          ],
        ),
      ),
    );
  }

  Widget _buildModernInputField({required String label, required String hint, required TextEditingController controller, required IconData icon, TextInputType keyboardType = TextInputType.text, bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          validator: isRequired ? (v) => (v == null || v.isEmpty) ? 'هذا الحقل مطلوب' : null : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primaryColor)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
            suffixIcon: Icon(icon, color: Colors.grey.shade400),
          ),
        ),
      ],
    );
  }

  Widget _buildModernDropdown({required String label, required String value, required IconData icon, required VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                Row(
                  children: [
                    Text(value, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                    const SizedBox(width: 12),
                    Icon(icon, color: Colors.grey.shade400),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorCircle(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 6, offset: const Offset(0, 2))],
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildBottomSaveButton(AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, -4), blurRadius: 16)],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _isSaving ? null : _saveDevice,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
          ),
          child: _isSaving
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.device != null ? 'حفظ التعديلات' : loc.saveDeviceButton, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 12),
                    const Icon(Icons.check_circle_outline),
                  ],
                ),
        ),
      ),
    );
  }

  // --- Same Modals for Group & Time as original logic (Stylized) ---
  void _showGroupPicker(AppLocalizations loc) async {
    showDialog(context: context, barrierDismissible: false, builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      final groups = await ref.read(vehicleGroupsProvider.future);
      if (!mounted) return;
      Navigator.of(context).pop();

      final selectedId = await showModalBottomSheet<String>(
        context: context,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('اختر المجموعة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const Divider(height: 1),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.add_circle, color: AppTheme.primaryColor),
                        title: const Text('إنشاء مجموعة جديدة', textAlign: TextAlign.right, style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                        onTap: () async {
                          Navigator.of(context).pop();
                          final newGroupName = await _showCreateGroupDialog();
                          if (newGroupName != null && newGroupName.isNotEmpty && mounted) {
                            try {
                              showDialog(context: context, barrierDismissible: false, builder: (context) => const Center(child: CircularProgressIndicator()));
                              final apiClient = ref.read(apiClientProvider);
                              final response = await apiClient.post(ApiConstants.addDeviceGroup, data: {'title': newGroupName, 'open': true, 'devices': [0]});
                              Navigator.of(context).pop();
                              if (response.statusCode == 200 || response.statusCode == 201) {
                                final data = response.data;
                                String? newGroupId;
                                if (data is Map) {
                                  if (data['id'] != null) newGroupId = data['id'].toString();
                                  else if (data['item'] != null && data['item']['id'] != null) newGroupId = data['item']['id'].toString();
                                  else if (data['status'] == 1) { ref.invalidate(vehicleGroupsProvider); newGroupId = newGroupName; }
                                }
                                if (mounted) {
                                  setState(() => _selectedGroup = newGroupId ?? newGroupName);
                                  ref.invalidate(vehicleGroupsProvider);
                                }
                              } else throw Exception('Failed to create group');
                            } catch (e) {
                              if (mounted) {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('فشل إنشاء المجموعة: $e'), backgroundColor: Colors.red));
                              }
                            }
                          }
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: Text(loc.groupUngrouped, textAlign: TextAlign.right),
                        trailing: const Icon(Icons.layers_clear_outlined, color: Colors.grey),
                        onTap: () => Navigator.of(context).pop('Ungrouped'),
                      ),
                      ...groups.map((group) => ListTile(
                        title: Text(group.name, textAlign: TextAlign.right),
                        trailing: const Icon(Icons.folder_outlined, color: Colors.grey),
                        onTap: () => Navigator.of(context).pop(group.id),
                      )).toList(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );

      if (selectedId != null && mounted) setState(() => _selectedGroup = selectedId);
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('فشل تحميل المجموعات: $e'), backgroundColor: Colors.red));
    }
  }

  Future<String?> _showCreateGroupDialog() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مجموعة جديدة', textAlign: TextAlign.right),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: TextField(
          controller: controller,
          autofocus: true,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: 'أدخل اسم المجموعة',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) Navigator.pop(context, controller.text.trim());
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text('حفظ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showTimeAdjustmentPicker(AppLocalizations loc) async {
    final options = ['UTC +3:00', 'UTC +0:00', 'UTC -5:00'];
    final selected = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            Padding(padding: const EdgeInsets.all(16), child: Text(loc.timeAdjustment, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            const Divider(height: 1),
            ...options.map((time) => ListTile(
              title: Text(time, textAlign: TextAlign.right),
              onTap: () => Navigator.of(context).pop(time),
            )),
          ],
        ),
      ),
    );
    if (selected != null) setState(() => _selectedTimeAdjustment = selected);
  }

  void _showMeasurementPicker(AppLocalizations loc) async {
    final options = ['l/100km', 'km/l', 'mpg'];
    final selected = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            Padding(padding: const EdgeInsets.all(16), child: Text(loc.measurementI100km, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            const Divider(height: 1),
            ...options.map((measurement) => ListTile(
              title: Text(measurement, textAlign: TextAlign.right),
              onTap: () => Navigator.of(context).pop(measurement),
            )),
          ],
        ),
      ),
    );
    if (selected != null) setState(() => _selectedMeasurement = selected);
  }
}
