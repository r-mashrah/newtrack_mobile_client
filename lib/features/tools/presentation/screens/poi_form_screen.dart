import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/map_object_entities.dart';
import '../providers/map_objects_provider.dart';

class POIFormScreen extends StatefulWidget {
  final POIEntity? poi;
  const POIFormScreen({super.key, this.poi});

  @override
  State<POIFormScreen> createState() => _POIFormScreenState();
}

class _POIFormScreenState extends State<POIFormScreen> {
  LatLng? _selectedPosition;
  GoogleMapController? _mapController;
  final TextEditingController _nameController = TextEditingController();
  bool _isSaving = false;
  @override
  void initState() {
    super.initState();
    if (widget.poi != null) {
      _selectedPosition = widget.poi!.position;
      _nameController.text = widget.poi!.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedPosition ?? const LatLng(15.3694, 44.1910),
              zoom: 12,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onTap: _isSaving ? null : (latLng) {
              setState(() {
                _selectedPosition = latLng;
              });
            },
            markers: _selectedPosition == null
                ? {}
                : {
                    Marker(
                      markerId: const MarkerId('selected_poi'),
                      position: _selectedPosition!,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueGreen,
                      ),
                    ),
                  },
            zoomControlsEnabled: false,
          ),
          // Header Buttons
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _isSaving
                    ? _buildCircleLoading()
                    : _buildCircleButton(icon: Icons.save, onTap: _savePOI),
                Row(
                  children: [
                    if (widget.poi != null && !_isSaving)
                      _buildCircleButton(
                        icon: Icons.delete_outline,
                        onTap: _confirmDelete,
                        color: Colors.red,
                      ),
                    if (widget.poi != null && !_isSaving) const SizedBox(width: 8),
                    if (!_isSaving)
                      _buildCircleButton(
                        icon: Icons.close,
                        onTap: () => Navigator.pop(context),
                      ),
                  ],
                ),
              ],
            ),
          ), // Map Controls
          Positioned(
            bottom: 120,
            left: 20,
            child: Column(
              children: [
                _buildCircleButton(
                  icon: Icons.add,
                  onTap: () =>
                      _mapController?.animateCamera(CameraUpdate.zoomIn()),
                ),
                const SizedBox(height: 12),
                _buildCircleButton(
                  icon: Icons.remove,
                  onTap: () =>
                      _mapController?.animateCamera(CameraUpdate.zoomOut()),
                ),
              ],
            ),
          ),
          // Bottom Info Sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    textAlign: TextAlign.right,
                    enabled: !_isSaving,
                    decoration: const InputDecoration(
                      hintText: 'اسم الموقع المهم',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_selectedPosition != null) ...[
                    Text(
                      'خط العرض: ${_selectedPosition!.latitude}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'خط الطول: ${_selectedPosition!.longitude}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ] else
                    const Text(
                      'اضغط على الخريطة لتحديد الموقع',
                      style: TextStyle(color: Colors.grey),
                    ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
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
        icon: Icon(icon, color: color ?? const Color(0xFF1D99BD)),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildCircleLoading() {
    return Container(
      padding: const EdgeInsets.all(12),
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
      child: const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف', textAlign: TextAlign.right),
        content: const Text(
          'هل أنت متأكد من حذف هذا الموقع المهم؟',
          textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close dialog
              setState(() => _isSaving = true);
              try {
                final container = ProviderScope.containerOf(context);
                await container.read(poiProvider.notifier).removePOI(widget.poi!.id);
                if (mounted) {
                  Navigator.of(context).pop(); // Close form
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الحذف بنجاح'), backgroundColor: Colors.green));
                }
              } catch (e) {
                if (mounted) {
                  setState(() => _isSaving = false);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('فشل الحذف: $e'), backgroundColor: Colors.red));
                }
              }
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _savePOI() async {
    if (_nameController.text.isEmpty || _selectedPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال الاسم وتحديد الموقع'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final container = ProviderScope.containerOf(context);
      final newPOI = POIEntity(
        id: widget.poi?.id ?? '0',
        name: _nameController.text,
        position: _selectedPosition!,
        createdAt: widget.poi?.createdAt ?? DateTime.now(),
      );

      if (widget.poi == null) {
        await container.read(poiProvider.notifier).addPOI(newPOI);
      } else {
        await container.read(poiProvider.notifier).updatePOI(newPOI);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم الحفظ بنجاح'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل الحفظ: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
