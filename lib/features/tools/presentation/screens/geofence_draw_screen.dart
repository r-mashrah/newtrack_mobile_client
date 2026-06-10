import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/theme/app_theme.dart';

class GeofenceDrawScreen extends StatefulWidget {
  final List<LatLng> initialPoints;
  final Color color;
  const GeofenceDrawScreen({
    super.key,
    required this.initialPoints,
    required this.color,
  });

  @override
  State<GeofenceDrawScreen> createState() => _GeofenceDrawScreenState();
}

class _GeofenceDrawScreenState extends State<GeofenceDrawScreen> {
  late List<LatLng> _points;
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polygon> _polygons = {};

  @override
  void initState() {
    super.initState();
    _points = List.from(widget.initialPoints);
    _updateMapElements();
  }

  void _updateMapElements() {
    _markers.clear();
    for (int i = 0; i < _points.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId('point_$i'),
          position: _points[i],
          draggable: true,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          onDragEnd: (newPosition) {
            setState(() {
              _points[i] = newPosition;
              _updateMapElements();
            });
          },
        ),
      );
    }

    _polygons.clear();
    if (_points.length >= 3) {
      _polygons.add(
        Polygon(
          polygonId: const PolygonId('geofence'),
          points: _points,
          fillColor: widget.color.withOpacity(0.3),
          strokeColor: widget.color,
          strokeWidth: 2,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _points.isNotEmpty
                  ? _points.first
                  : const LatLng(15.3694, 44.1910),
              zoom: 10,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onTap: (latLng) {
              setState(() {
                _points.add(latLng);
                _updateMapElements();
              });
            },
            markers: _markers,
            polygons: _polygons,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
          ),
          // Header Buttons
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircleButton(
                  icon: Icons.save,
                  onTap: () {
                    if (_points.length < 3) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('يجب رسم 3 نقاط على الأقل'),
                        ),
                      );
                    } else {
                      Navigator.pop(context, _points);
                    }
                  },
                ),
                _buildCircleButton(
                  icon: Icons.arrow_forward,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Map Controls
          Positioned(
            bottom: 100,
            left: 20,
            child: Column(
              children: [
                _buildCircleButton(
                  icon: Icons.undo,
                  onTap: () {
                    if (_points.isNotEmpty) {
                      setState(() {
                        _points.removeLast();
                        _updateMapElements();
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
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
          // Bottom Status
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Text(
                _points.length < 3
                    ? 'اضغط على الخريطة لرسم النقاط (تحتاج ${3 - _points.length} إضافية)'
                    : 'يمكنك الآن حفظ الحدود الجغرافية',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w500),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(icon, color: const Color(0xFF1D99BD), size: 24),
          ),
        ),
      ),
    );
  }
}
