import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show cos, sqrt, asin;
import '../../../../core/theme/app_theme.dart';

class RulerScreen extends StatefulWidget {
  const RulerScreen({super.key});

  @override
  State<RulerScreen> createState() => _RulerScreenState();
}

class _RulerScreenState extends State<RulerScreen> {
  final List<LatLng> _points = [];
  GoogleMapController? _mapController;
  double _totalDistance = 0;
  final List<double> _segmentDistances = [];

  double _calculateDistance(LatLng p1, LatLng p2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a =
        0.5 -
        c((p2.latitude - p1.latitude) * p) / 2 +
        c(p1.latitude * p) *
            c(p2.latitude * p) *
            (1 - c((p2.longitude - p1.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  void _addPoint(LatLng point) {
    setState(() {
      if (_points.isNotEmpty) {
        double dist = _calculateDistance(_points.last, point);
        _segmentDistances.add(dist);
        _totalDistance += dist;
      }
      _points.add(point);
    });
  }

  void _clearAll() {
    setState(() {
      _points.clear();
      _segmentDistances.clear();
      _totalDistance = 0;
    });
  }

  void _undoLast() {
    if (_points.isEmpty) return;
    setState(() {
      if (_points.length > 1) {
        _totalDistance -= _segmentDistances.last;
        _segmentDistances.removeLast();
      }
      _points.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(15.3694, 44.1910),
              zoom: 12,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onTap: _addPoint,
            markers: _points.asMap().entries.map((entry) {
              int idx = entry.key;
              LatLng point = entry.value;
              return Marker(
                markerId: MarkerId('point_$idx'),
                position: point,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure,
                ),
                infoWindow: InfoWindow(
                  title: idx > 0
                      ? 'المسافة: ${_segmentDistances[idx - 1].toStringAsFixed(2)} كم'
                      : '',
                ),
              );
            }).toSet(),
            polylines: {
              Polyline(
                polylineId: const PolylineId('ruler_line'),
                points: _points,
                color: AppColors.primary,
                width: 4,
              ),
            },
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
          ),
          // Header
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircleButton(
                  icon: Icons.arrow_back,
                  onTap: () => Navigator.pop(context),
                ),
                const Text(
                  'المسطرة',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                _buildCircleButton(icon: Icons.refresh, onTap: _clearAll),
              ],
            ),
          ),
          // Undo Button
          Positioned(
            bottom: 180,
            right: 20,
            child: _buildCircleButton(icon: Icons.undo, onTap: _undoLast),
          ),
          // Distance Info Card
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'إجمالي المسافة',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_totalDistance.toStringAsFixed(2)} كم',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  if (_points.length > 1) ...[
                    const Divider(height: 24),
                    SizedBox(
                      height: 60,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        itemCount: _segmentDistances.length,
                        separatorBuilder: (context, index) =>
                            const VerticalDivider(width: 20),
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'الجزء ${index + 1}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '${_segmentDistances[index].toStringAsFixed(2)} كم',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  const Text(
                    'اضغط على الخريطة لإضافة نقاط القياس',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
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
        icon: Icon(icon, color: AppColors.primary),
        onPressed: onTap,
      ),
    );
  }
}
