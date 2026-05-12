import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../domain/entities/device_entity.dart';
import '../../../../domain/entities/location_entity.dart';
import '../../../main_map/presentation/providers/devices_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../generated/l10n/app_localizations.dart';

class AddDeviceScreen extends ConsumerStatefulWidget {
  static const routeName = '/add-device';
  const AddDeviceScreen({super.key});

  @override
  ConsumerState<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends ConsumerState<AddDeviceScreen>
    with SingleTickerProviderStateMixin {
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

  // Colors for status
  Color _movingColor = Colors.green;
  Color _stoppedColor = Colors.red;
  Color _disconnectedColor = Colors.grey;
  Color _idleColor = Colors.yellow;

  // ... (بقية الكود)
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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

  // تم نقل Dispose إلى الجزء العلوي مع initState

  // Helper to convert Color to Hex String
  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  // Helper to convert Hex String to Color
  // ignore: unused_element
  Color _hexToColor(String hexCode) {
    String colorString = hexCode.toUpperCase().replaceAll('#', '');
    if (colorString.length == 6) {
      colorString = 'FF$colorString';
    }
    return Color(int.parse(colorString, radix: 16));
  }

  // Helper to show color picker dialog
  Future<Color?> _showColorPickerDialog(Color initialColor) async {
    return showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        Color tempColor = initialColor;
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.selectColor),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Simple color palette for demonstration
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children:
                      [
                        Colors.red,
                        Colors.blue,
                        Colors.green,
                        Colors.yellow,
                        Colors.purple,
                        Colors.orange,
                        Colors.teal,
                        Colors.brown,
                        Colors.grey,
                        Colors.black,
                        Colors.white,
                      ].map((color) {
                        return GestureDetector(
                          onTap: () {
                            tempColor = color;
                            Navigator.of(context).pop(tempColor);
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black12,
                                width: 1,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.resetButton),
              onPressed: () {
                Navigator.of(context).pop(initialColor);
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.saveAndCloseButton),
              onPressed: () {
                Navigator.of(context).pop(tempColor);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.white1,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveDevice,
        label: Text(loc.saveDeviceButton),
        icon: const Icon(Icons.save),
        backgroundColor: AppColors.primary,
      ),
      body: CustomScrollView(
        slivers: [
          // Back Button Header
          SliverAppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    customBorder: const CircleBorder(),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Tab Bar
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.materialGrey200,
                    width: 1,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.materialGrey400,
                isScrollable: true,
                labelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  Tab(text: loc.mainTab),
                  Tab(text: loc.advancedTab),
                  Tab(text: loc.accuracyTab),
                  Tab(text: loc.tailTab),
                ],
              ),
            ),
          ),
          // Tab Content
          SliverFillRemaining(
            child: Form(
              key: _formKey,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMainTab(),
                  _buildAdvancedTab(),
                  _buildAccuracyTab(),
                  _buildTailTab(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ... (بقية الكود)

  Future<void> _saveDevice() async {
    final loc = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) {
      // Show error message if validation fails
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.errorPrefix)));
      return;
    }

    // 1. Collect Data
    final newDeviceId = const Uuid().v4();
    final newDevice = DeviceEntity(
      id: newDeviceId,
      name: _nameController.text,
      imei: _imeiController.text,
      // Mock Location Data (since we are simulating a new device)
      lastLocation: LocationEntity(
        latitude: 15.35 + (0.05 * (DateTime.now().second % 10)), // Mock Lat
        longitude: 44.20 + (0.05 * (DateTime.now().minute % 10)), // Mock Lng
        timestamp: DateTime.now(),
      ),
      // Basic Fields
      plateNumber: _plateNumberController.text.isEmpty
          ? null
          : _plateNumberController.text,
      simNumber: _simNumberController.text.isEmpty
          ? null
          : _simNumberController.text,
      model: _modelController.text.isEmpty ? null : _modelController.text,
      // Advanced Fields
      group: _selectedGroup == loc.groupUngrouped ? null : _selectedGroup,
      // Colors
      movingColor: _colorToHex(_movingColor),
      stoppedColor: _colorToHex(_stoppedColor),
      disconnectedColor: _colorToHex(_disconnectedColor),
      idleColor: _colorToHex(_idleColor),
      markerImage: _selectedMarkerImage,
      // Tail
      tailColor: _colorToHex(_tailColor),
      tailLength: int.tryParse(_tailLengthController.text) ?? 0,
      // Other Mocked/Default Fields
      status: 'offline', // New device starts offline
      isActive: true,
      speed: 0.0,
      lastUpdate: DateTime.now(),
    );

    // 2. Save Device using UseCase (which uses MockDataSource)
    try {
      final addDeviceUseCase = ref.read(addDeviceUseCaseProvider);
      await addDeviceUseCase.call(newDevice);

      // 3. Update Devices List in DevicesNotifier
      // The MockDataSource already calls _updateController.add, but we should also ensure the notifier reloads or updates its state.
      // Since MockDataSource is a stream, the DevicesNotifier should automatically pick up the change.
      // We can force a refresh for good measure if the stream is not guaranteed to update immediately.
      ref.read(devicesNotifierProvider.notifier).loadDevices();

      // 4. Show Success and Navigate Back
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${loc.objectName} "${newDevice.name}" saved')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${loc.errorPrefix}: ${e.toString()}')),
      );
    }
  }

  Widget _buildMainTab() {
    final loc = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Object Name
            _buildInputField(
              label: loc.objectName,
              hintText: loc.objectName,
              controller: _nameController,
              isRequired: true,
            ),
            const SizedBox(height: 16),

            // Object IMEI
            _buildInputField(
              label: loc.objectImei,
              hintText: loc.objectImei,
              controller: _imeiController,
              keyboardType: TextInputType.number,
              isRequired: true,
            ),
            const SizedBox(height: 16),

            // Has Expiration Date Checkbox
            _buildCheckboxField(
              label: loc.hasExpirationDate,
              value: _hasExpirationDate,
              onChanged: (value) {
                setState(() {
                  _hasExpirationDate = value ?? false;
                });
              },
            ),
            const SizedBox(height: 16),

            // Marker Image
            _buildSelectableField(
              label: loc.markerImage,
              value: _selectedMarkerImage,
              onTap: () => _showMarkerImagePicker(loc),
            ),
            const SizedBox(height: 32),

            // Device Status Colors Section
            Text(
              loc.deviceColors,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),

            _buildColorSelector(
              label: loc.movingColor,
              color: _movingColor,
              onTap: () => _selectColor(
                _movingColor,
                (color) => setState(() => _movingColor = color),
              ),
            ),
            const SizedBox(height: 16),

            _buildColorSelector(
              label: loc.stoppedColor,
              color: _stoppedColor,
              onTap: () => _selectColor(
                _stoppedColor,
                (color) => setState(() => _stoppedColor = color),
              ),
            ),
            const SizedBox(height: 16),

            _buildColorSelector(
              label: loc.disconnectedColor,
              color: _disconnectedColor,
              onTap: () => _selectColor(
                _disconnectedColor,
                (color) => setState(() => _disconnectedColor = color),
              ),
            ),
            const SizedBox(height: 16),

            _buildColorSelector(
              label: loc.idleColor,
              color: _idleColor,
              onTap: () => _selectColor(
                _idleColor,
                (color) => setState(() => _idleColor = color),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Helper function to select color
  void _selectColor(Color initialColor, Function(Color) onColorSelected) async {
    final selectedColor = await _showColorPickerDialog(initialColor);
    if (selectedColor != null) {
      onColorSelected(selectedColor);
    }
  }

  // Helper function to show marker image picker
  void _showMarkerImagePicker(AppLocalizations loc) async {
    final selected = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        const markerOptions = ['car', 'truck', 'bus', 'motorcycle', 'person'];
        return AlertDialog(
          title: Text(loc.selectMarkerImage),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: markerOptions.map((marker) {
                return ListTile(
                  title: Text(marker),
                  leading: const Icon(Icons.directions_car), // Placeholder icon
                  onTap: () => Navigator.of(context).pop(marker),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedMarkerImage = selected;
      });
    }
  }

  // Helper widget for color selection
  Widget _buildColorSelector({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return _buildSelectableField(
      label: label,
      value: _colorToHex(color),
      onTap: onTap,
      trailing: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.materialGrey400, width: 1),
        ),
      ),
    );
  }

  // (removed duplicate placeholder _buildAdvancedTab; the full implementation exists below)

  Widget _buildAdvancedTab() {
    final loc = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group
            _buildSelectableField(
              label: loc.group,
              value: _selectedGroup,
              onTap: () => _showGroupPicker(loc),
            ),
            const SizedBox(height: 16),

            // Sim Number
            _buildInputField(
              label: loc.simNumber,
              hintText: loc.simNumber,
              controller: _simNumberController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Device Model
            _buildInputField(
              label: loc.deviceModel,
              hintText: loc.deviceModel,
              controller: _modelController,
            ),
            const SizedBox(height: 16),

            // Plate Number
            _buildInputField(
              label: loc.plateNumber,
              hintText: loc.plateNumber,
              controller: _plateNumberController,
            ),
            const SizedBox(height: 16),

            // VIN
            _buildInputField(
              label: loc.vin,
              hintText: loc.vin,
              controller: _vinController,
            ),
            const SizedBox(height: 16),

            // Registration/Asset Number
            _buildInputField(
              label: loc.registrationAssetNumber,
              hintText: loc.registrationAssetNumber,
              controller: _assetNumberController,
            ),
            const SizedBox(height: 16),

            // Object Owner/Manager
            _buildInputField(
              label: loc.objectOwnerManager,
              hintText: loc.objectOwnerManager,
              controller: _ownerManagerController,
            ),
            const SizedBox(height: 16),

            // Measurement l/100km
            _buildSelectableField(
              label: loc.measurementI100km,
              value: _selectedMeasurement,
              onTap: () => _showMeasurementPicker(loc),
            ),
            const SizedBox(height: 16),

            // Km per 1 Liter
            _buildInputField(
              label: loc.kmPer1Liter,
              hintText: '1',
              controller: TextEditingController(text: '1'), // Mock value
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Cost for 1 Liter
            _buildInputField(
              label: loc.costFor1Liter,
              hintText: '0',
              controller: TextEditingController(text: '0'), // Mock value
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Time Adjustment
            _buildSelectableField(
              label: loc.timeAdjustment,
              value: _selectedTimeAdjustment,
              onTap: () => _showTimeAdjustmentPicker(loc),
            ),
            const SizedBox(height: 16),

            // Additional Notes
            _buildInputField(
              label: loc.additionalNotes,
              hintText: loc.additionalNotes,
              controller: _notesController,
              maxLines: 3,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Helper function to show group picker
  void _showGroupPicker(AppLocalizations loc) async {
    final selected = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        const groupOptions = ['Ungrouped', 'Group A', 'Group B', 'Group C'];
        return AlertDialog(
          title: Text(loc.selectGroup),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: groupOptions.map((group) {
                return ListTile(
                  title: Text(
                    group == 'Ungrouped' ? loc.groupUngrouped : group,
                  ),
                  onTap: () => Navigator.of(context).pop(group),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedGroup = selected;
      });
    }
  }

  // Helper function to show measurement picker
  void _showMeasurementPicker(AppLocalizations loc) async {
    final selected = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        const measurementOptions = ['l/100km', 'km/l', 'mpg'];
        return AlertDialog(
          title: Text(loc.measurementI100km),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: measurementOptions.map((measurement) {
                return ListTile(
                  title: Text(measurement),
                  onTap: () => Navigator.of(context).pop(measurement),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedMeasurement = selected;
      });
    }
  }

  // Helper function to show time adjustment picker
  void _showTimeAdjustmentPicker(AppLocalizations loc) async {
    final selected = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        const timeOptions = ['UTC +3:00', 'UTC +0:00', 'UTC -5:00'];
        return AlertDialog(
          title: Text(loc.timeAdjustment),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: timeOptions.map((time) {
                return ListTile(
                  title: Text(time),
                  onTap: () => Navigator.of(context).pop(time),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedTimeAdjustment = selected;
      });
    }
  }

  Widget _buildAccuracyTab() {
    final loc = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Minimal Moving Speed
            _buildInputField(
              label: loc.minimalMovingSpeed,
              hintText: '1',
              controller: _minSpeedController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Minimal Fuel Difference to Detect Fuel Fillings
            _buildInputField(
              label: loc.minimalFuelDifferenceFillings,
              hintText: '1',
              controller: _minFuelFillController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Minimal Fuel Difference to Detect Fuel Thefts
            _buildInputField(
              label: loc.minimalFuelDifferenceThefts,
              hintText: '1',
              controller: _minFuelTheftController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTailTab() {
    final loc = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tail Color
            _buildColorSelector(
              label: loc.tailColor,
              color: _tailColor,
              onTap: () => _selectColor(
                _tailColor,
                (color) => setState(() => _tailColor = color),
              ),
            ),
            const SizedBox(height: 16),

            // Tail Length
            _buildInputField(
              label: loc.tailLength,
              hintText: '10',
              controller: _tailLengthController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return 'This field is required';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: AppColors.materialGrey400,
              fontSize: 14,
            ),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 1),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 1),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectableField({
    required String label,
    required String value,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.materialGrey200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.materialGrey700,
                      ),
                    ),
                    if (value.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ],
                ),
                trailing ??
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.primary,
                      size: 24,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckboxField({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.materialGrey200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.materialGrey700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
