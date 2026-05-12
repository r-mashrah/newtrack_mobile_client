import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/map_object_entities.dart';
import '../providers/map_objects_provider.dart';
import 'geofence_draw_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeofenceFormScreen extends StatefulWidget {
  final GeofenceEntity? geofence;
  const GeofenceFormScreen({super.key, this.geofence});

  @override
  State<GeofenceFormScreen> createState() => _GeofenceFormScreenState();
}

class _GeofenceFormScreenState extends State<GeofenceFormScreen> {
  late TextEditingController _nameController;
  late Color _selectedColor;
  List<LatLng> _points = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.geofence?.name ?? '');
    _selectedColor = widget.geofence?.color ?? const Color(0xFF1D99BD);
    _points = widget.geofence?.points ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white1,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _buildHeaderButton(
          icon: Icons.save,
          onTap: _saveGeofence,
        ),
        actions: [
          if (widget.geofence != null)
            _buildHeaderButton(
              icon: Icons.delete_outline,
              onTap: _confirmDelete,
              color: Colors.red,
            ),
          _buildHeaderButton(
            icon: Icons.close,
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'اسم الحدود الجغرافية',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'Yemen',
                fillColor: AppColors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'اللون',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildColorPicker(),
            const SizedBox(height: 24),
            const Text(
              'الخريطة',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildMapSection(),
            const SizedBox(height: 8),
            const Text(
              'ارسم سياجًا جغرافيًا في نقطة الوسط باستخدام نصف القطر أو الحدود المخصصة',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderButton({required IconData icon, required VoidCallback onTap, Color? color}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
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
          icon: Icon(icon, color: color ?? const Color(0xFF1D99BD)),
          onPressed: onTap,
        ),
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف', textAlign: TextAlign.right),
        content: const Text('هل أنت متأكد من حذف هذه المنطقة الجغرافية؟', textAlign: TextAlign.right),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              final container = ProviderScope.containerOf(context);
              container.read(geofencesProvider.notifier).removeGeofence(widget.geofence!.id);
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close form
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker() {
    return InkWell(
      onTap: _showColorPickerDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.chevron_left, color: Colors.grey),
            Row(
              children: [
                const Text('لون الحدود الجغرافية'),
                const SizedBox(width: 12),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _selectedColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    return InkWell(
      onTap: () async {
        final result = await Navigator.push<List<LatLng>>(
          context,
          MaterialPageRoute(
            builder: (context) => GeofenceDrawScreen(initialPoints: _points, color: _selectedColor),
          ),
        );
        if (result != null) {
          setState(() {
            _points = result;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.chevron_left, color: Colors.grey),
            Row(
              children: [
                Text(_points.isEmpty ? 'ارسم الحدود الجغرافية' : 'تعديل الحدود الجغرافية (${_points.length} نقاط)'),
                const SizedBox(width: 12),
                const Icon(Icons.map_outlined, color: Color(0xFF1D99BD)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 150,
              width: double.maxFinite,
              color: _selectedColor,
            ),
            const SizedBox(height: 16),
            // Simplified color picker based on UI screenshot
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _colorOption(Colors.red),
                _colorOption(Colors.green),
                _colorOption(Colors.blue),
                _colorOption(const Color(0xFF1D99BD)),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '#${_selectedColor.value.toRadixString(16).toUpperCase().substring(2)}',
                prefixText: '# ',
              ),
              onChanged: (value) {
                // Handle hex input
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('SELECT'),
            )
          ],
        ),
      ),
    );
  }

  Widget _colorOption(Color color) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
        Navigator.pop(context);
        _showColorPickerDialog();
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }

  void _saveGeofence() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال اسم الحدود')),
      );
      return;
    }
    if (_points.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب رسم 3 نقاط على الأقل لتكوين شكل هندسي')),
      );
      return;
    }

    final container = ProviderScope.containerOf(context);
    final newGeofence = GeofenceEntity(
      id: widget.geofence?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      points: _points,
      color: _selectedColor,
      createdAt: widget.geofence?.createdAt ?? DateTime.now(),
    );

    if (widget.geofence == null) {
      container.read(geofencesProvider.notifier).addGeofence(newGeofence);
    } else {
      container.read(geofencesProvider.notifier).updateGeofence(newGeofence);
    }

    Navigator.pop(context);
  }
}
