import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../../../../domain/entities/device_entity.dart';
import '../providers/devices_provider.dart';
import '../providers/map_style_provider.dart';
import 'device_info_bottom_sheet.dart';
import 'map_utilities_manager.dart';
import '../providers/map_controller_provider.dart';

class MapView extends ConsumerStatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  ConsumerState<MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final Set<Circle> _circles = {};

  LocationData? _currentLocation;
  final Location _location = Location();

  bool _isMapInitialized = false;
  bool _isLocationPermissionGranted = false;

  static const CameraPosition _defaultLocation = CameraPosition(
    target: LatLng(15.3694, 44.1910),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void dispose() {
    if (_isMapInitialized) {
      _mapController.dispose();
    }
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    setState(() {
      _isLocationPermissionGranted = true;
    });

    _currentLocation = await _location.getLocation();

    if (_isMapInitialized && _currentLocation != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
          15,
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    ref.read(mapControllerProvider.notifier).setController(controller);
    setState(() {
      _isMapInitialized = true;
    });
    _updateMapStyle();
  }

  Future<void> _updateMapStyle() async {
    if (!_isMapInitialized) return;
    final mapStyleJson = ref.read(mapStyleJsonProvider);
    final mapStyle = ref.read(mapStyleStateProvider);
    
    // إذا كان النمط ساتلايت أو هجين، نستخدم النوع المدمج في قوقل
    if (mapStyle.currentStyle == MapStyleType.satellite) {
      // لا نحتاج لنمط JSON هنا
    } else if (mapStyle.currentStyle == MapStyleType.hybrid) {
      // لا نحتاج لنمط JSON هنا
    } else {
      await _mapController.setMapStyle(mapStyleJson);
    }
  }

  MapType _getGoogleMapType(MapStyleType style) {
    switch (style) {
      case MapStyleType.satellite:
        return MapType.satellite;
      case MapStyleType.terrain:
        return MapType.terrain;
      case MapStyleType.hybrid:
        return MapType.hybrid;
      default:
        return MapType.normal;
    }
  }

  Set<Marker> _buildMarkers(List<DeviceEntity> devices) {
    return devices.map((device) {
      final position = LatLng(
        device.lastLocation.latitude,
        device.lastLocation.longitude,
      );

      return Marker(
        markerId: MarkerId(device.id),
        position: position,
        icon: _getMarkerIcon(device.displayStatus),
        infoWindow: InfoWindow(
          title: device.name,
          snippet: 'السرعة: ${device.speed?.toStringAsFixed(1) ?? 0} كم/س',
          onTap: () => _onMarkerTap(device),
        ),
        rotation: device.lastLocation.bearing ?? 0,
        anchor: const Offset(0.5, 0.5),
      );
    }).toSet();
  }

  BitmapDescriptor _getMarkerIcon(String status) {
    switch (status) {
      case 'moving':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case 'stopped':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      case 'offline':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case 'parked':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }

  void _onMarkerTap(DeviceEntity device) {
    showModalBottomSheet(
      context: context,
      builder: (context) => DeviceInfoBottomSheet(device: device),
    );
  }

  @override
  Widget build(BuildContext context) {
    final devicesAsync = ref.watch(devicesNotifierProvider);
    final mapStyle = ref.watch(mapStyleStateProvider);

    // مراقبة تغييرات النمط لتحديث الخريطة
    ref.listen(mapStyleStateProvider, (previous, next) {
      if (previous?.currentStyle != next.currentStyle) {
        _updateMapStyle();
      }
    });

    return devicesAsync.when(
      initial: () => const Center(child: CircularProgressIndicator()),
      loading: () => const Center(child: CircularProgressIndicator()),
      loaded: (devices, isRefreshing, filterQuery, statusFilter) {
        // تحديث البيانات بناءً على خيارات المستخدم
        _markers.clear();
        _markers.addAll(_buildMarkers(devices));
        
        // إضافة نقاط الاهتمام إذا كانت مفعلة
        if (mapStyle.showPoI) {
          _markers.addAll(MapUtilitiesManager.buildPointsOfInterest(devices, true));
        }

        _polylines.clear();
        if (mapStyle.showTrail) {
          _polylines.addAll(MapUtilitiesManager.buildAdvancedTrails(devices, true));
        }

        _circles.clear();
        if (mapStyle.showGeofences) {
          _circles.addAll(MapUtilitiesManager.buildAdvancedGeofences(devices, true));
        }

        return Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: _defaultLocation,
              mapType: _getGoogleMapType(mapStyle.currentStyle),
              markers: _markers,
              polylines: _polylines,
              circles: _circles,
              myLocationEnabled: _isLocationPermissionGranted,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: true,
              mapToolbarEnabled: true,
            ),
            
            // تمت إزالة أزرار التحكم من هنا لأنها أضيفت في MainMapScreen كأزرار عائمة فوق الخريطة
            // لضمان التناسق مع التصميم المطلوب في الصور
            
            // زر الموقع الحالي (يمكن إضافته في MainMapScreen أيضاً إذا لزم الأمر)
            Positioned(
              right: 16,
              bottom: 150,
              child: _buildMapActionBtn(
                icon: Icons.my_location,
                onPressed: _initializeLocation,
                heroTag: 'loc_btn',
              ),
            ),

            if (isRefreshing)
              const Positioned(
                top: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text('جاري التحديث...'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
      error: (err, stack) => Center(child: Text('خطأ: $err')),
    );
  }

  Widget _buildMapActionBtn({
    required IconData icon,
    required VoidCallback onPressed,
    required String heroTag,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return FloatingActionButton.small(
      heroTag: heroTag,
      onPressed: onPressed,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.primary,
      child: Icon(icon),
    );
  }
}
