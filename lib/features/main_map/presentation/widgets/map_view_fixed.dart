import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../../../../domain/entities/device_entity.dart';
import '../providers/devices_provider.dart';
import '../providers/map_style_provider.dart';
import 'device_info_bottom_sheet.dart';
import 'map_settings_bottom_sheet.dart';

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

  // إعدادات الخريطة
  static const CameraPosition _defaultLocation = CameraPosition(
    target: LatLng(15.3694, 44.1910), // صنعاء، اليمن
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  /// تهيئة خدمات الموقع
  Future<void> _initializeLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // التحقق من تفعيل خدمات الموقع
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // التحقق من إذن الوصول للموقع
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isLocationPermissionGranted = true;
    });

    // الحصول على الموقع الحالي
    _currentLocation = await _location.getLocation();

    // تحديث الكاميرا إذا تم تهيئة الخريطة
    if (_isMapInitialized && _currentLocation != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            _currentLocation!.latitude!,
            _currentLocation!.longitude!,
          ),
          15,
        ),
      );
    }
  }

  /// معالجة إنشاء الخريطة
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() {
      _isMapInitialized = true;
    });

    // تحديث الموقع الحالي على الخريطة
    if (_currentLocation != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            _currentLocation!.latitude!,
            _currentLocation!.longitude!,
          ),
          15,
        ),
      );
    }

    // تطبيق نمط الخريطة الأولي
    _updateMapStyle();
  }

  /// تحديث نمط الخريطة
  Future<void> _updateMapStyle() async {
    if (!_isMapInitialized) return;

    final mapStyleJson = ref.read(mapStyleJsonProvider);
    try {
      await _mapController.setMapStyle(mapStyleJson);
    } catch (e) {
      debugPrint('Error setting map style: $e');
    }
  }

  /// بناء الـ Markers للأجهزة
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
          snippet: _buildDeviceSnippet(device),
          onTap: () => _onMarkerTap(device),
        ),
        rotation: device.lastLocation.bearing ?? 0,
        anchor: const Offset(0.5, 0.5),
      );
    }).toSet();
  }

  /// الحصول على أيقونة الـ Marker حسب الحالة
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

  /// بناء نص معلومات الجهاز
  String _buildDeviceSnippet(DeviceEntity device) {
    final buffer = StringBuffer();

    if (device.speed != null) {
      buffer.write('السرعة: ${device.speed!.toStringAsFixed(1)} كم/س\n');
    }

    buffer.write('الحالة: ${_getStatusText(device.displayStatus)}\n');

    if (device.lastUpdate != null) {
      final timeDiff = DateTime.now().difference(device.lastUpdate!);
      if (timeDiff.inMinutes < 1) {
        buffer.write('التحديث: الآن');
      } else if (timeDiff.inHours < 1) {
        buffer.write('التحديث: منذ ${timeDiff.inMinutes} دقيقة');
      } else {
        buffer.write('التحديث: منذ ${timeDiff.inHours} ساعة');
      }
    }

    return buffer.toString();
  }

  /// الحصول على نص الحالة
  String _getStatusText(String status) {
    switch (status) {
      case 'moving':
        return 'متحرك';
      case 'stopped':
        return 'متوقف';
      case 'offline':
        return 'غير متصل';
      case 'parked':
        return 'مركون';
      default:
        return 'غير معروف';
    }
  }

  /// معالجة النقر على Marker
  void _onMarkerTap(DeviceEntity device) {
    showModalBottomSheet(
      context: context,
      builder: (context) => DeviceInfoBottomSheet(device: device),
    );
  }

  /// تكبير لعرض جميع الأجهزة
  void _fitBounds(List<DeviceEntity> devices) {
    if (devices.isEmpty) return;

    if (devices.length == 1) {
      final device = devices.first;
      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            device.lastLocation.latitude,
            device.lastLocation.longitude,
          ),
          15,
        ),
      );
      return;
    }

    // حساب الحدود
    double minLat = devices.first.lastLocation.latitude;
    double maxLat = devices.first.lastLocation.latitude;
    double minLng = devices.first.lastLocation.longitude;
    double maxLng = devices.first.lastLocation.longitude;

    for (final device in devices) {
      minLat = device.lastLocation.latitude < minLat
          ? device.lastLocation.latitude
          : minLat;
      maxLat = device.lastLocation.latitude > maxLat
          ? device.lastLocation.latitude
          : maxLat;
      minLng = device.lastLocation.longitude < minLng
          ? device.lastLocation.longitude
          : minLng;
      maxLng = device.lastLocation.longitude > maxLng
          ? device.lastLocation.longitude
          : maxLng;
    }

    final bounds = LatLngBounds(
      northeast: LatLng(maxLat, maxLng),
      southwest: LatLng(minLat, minLng),
    );

    _mapController.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50),
    );
  }

  /// بناء الأسوار الجغرافية (Geofences)
  Set<Circle> _buildGeofences(List<DeviceEntity> devices, bool showGeofences) {
    if (!showGeofences) return {};

    final geofences = <Circle>{};
    for (final device in devices) {
      // الحد الأول - منطقة التحذير
      geofences.add(
        Circle(
          circleId: CircleId('geofence_warning_${device.id}'),
          center: LatLng(
            device.lastLocation.latitude,
            device.lastLocation.longitude,
          ),
          radius: 1000, // 1 كم
          fillColor: Colors.orange.withOpacity(0.05),
          strokeColor: Colors.orange.withOpacity(0.4),
          strokeWidth: 1,
        ),
      );

      // الحد الثاني - منطقة الخطر
      geofences.add(
        Circle(
          circleId: CircleId('geofence_danger_${device.id}'),
          center: LatLng(
            device.lastLocation.latitude,
            device.lastLocation.longitude,
          ),
          radius: 500, // 500 متر
          fillColor: Colors.red.withOpacity(0.05),
          strokeColor: Colors.red.withOpacity(0.5),
          strokeWidth: 2,
        ),
      );

      // الحد الثالث - منطقة آمنة
      geofences.add(
        Circle(
          circleId: CircleId('geofence_safe_${device.id}'),
          center: LatLng(
            device.lastLocation.latitude,
            device.lastLocation.longitude,
          ),
          radius: 2000, // 2 كم
          fillColor: Colors.green.withOpacity(0.02),
          strokeColor: Colors.green.withOpacity(0.3),
          strokeWidth: 1,
        ),
      );
    }
    return geofences;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final devicesAsync = ref.watch(devicesNotifierProvider);
        final mapStyle = ref.watch(mapStyleStateProvider);

        // تحديث نمط الخريطة عند التغيير
        ref.listen(mapStyleStateProvider, (previous, next) {
          if (previous?.currentStyle != next.currentStyle) {
            _updateMapStyle();
          }
        });

        return devicesAsync.when(
          initial: () => const Center(child: CircularProgressIndicator()),
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded: (devices, isRefreshing, filterQuery, statusFilter) {
            // تحديث الـ Markers
            _markers.clear();
            _markers.addAll(_buildMarkers(devices));

            // تحديث الأسوار الجغرافية
            _circles.clear();
            _circles.addAll(_buildGeofences(devices, mapStyle.showGeofences));

            return Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: _defaultLocation,
                  markers: _markers,
                  polylines: _polylines,
                  circles: _circles,
                  myLocationEnabled: _isLocationPermissionGranted,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  compassEnabled: true,
                  mapToolbarEnabled: false,
                  onCameraMove: (position) {
                    // يمكن إضافة منطق عند تحريك الكاميرا
                  },
                ),

                // أزرار التحكم المخصصة
                Positioned(
                  right: 16,
                  top: 16,
                  child: Column(
                    children: [
                      // زر الموقع الحالي
                      FloatingActionButton.small(
                        heroTag: 'my_location',
                        onPressed: _initializeLocation,
                        tooltip: 'موقعي الحالي',
                        child: const Icon(Icons.my_location),
                      ),
                      const SizedBox(height: 8),
                      // زر تكبير
                      FloatingActionButton.small(
                        heroTag: 'zoom_in',
                        onPressed: () {
                          _mapController.animateCamera(
                            CameraUpdate.zoomIn(),
                          );
                        },
                        tooltip: 'تكبير',
                        child: const Icon(Icons.add),
                      ),
                      const SizedBox(height: 8),
                      // زر تصغير
                      FloatingActionButton.small(
                        heroTag: 'zoom_out',
                        onPressed: () {
                          _mapController.animateCamera(
                            CameraUpdate.zoomOut(),
                          );
                        },
                        tooltip: 'تصغير',
                        child: const Icon(Icons.remove),
                      ),
                      const SizedBox(height: 8),
                      // زر عرض جميع الأجهزة
                      FloatingActionButton.small(
                        heroTag: 'fit_bounds',
                        onPressed: () => _fitBounds(devices),
                        tooltip: 'عرض جميع الأجهزة',
                        child: const Icon(Icons.center_focus_strong),
                      ),
                    ],
                  ),
                ),

                // زر إعدادات الخريطة (أسفل يمين)
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton(
                    heroTag: 'map_settings',
                    onPressed: () => MapSettingsBottomSheet(),
                    tooltip: 'إعدادات الخريطة',
                    child: const Icon(Icons.settings),
                  ),
                ),

                // مؤشر التحديث
                if (isRefreshing)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),

                // عدد الأجهزة المعروضة
                Positioned(
                  left: 16,
                  top: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.devices, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          '${devices.length} جهاز',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // مؤشر الأدوات المفعلة
                if (mapStyle.showTrail ||
                    mapStyle.showGeofences ||
                    mapStyle.showPoI)
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (mapStyle.showTrail)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Tooltip(
                                message: 'المسار مفعل',
                                child: Icon(
                                  Icons.timeline,
                                  size: 18,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          if (mapStyle.showGeofences)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Tooltip(
                                message: 'الأسوار الجغرافية مفعلة',
                                child: Icon(
                                  Icons.border_all,
                                  size: 18,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          if (mapStyle.showPoI)
                            Tooltip(
                              message: 'نقاط الاهتمام مفعلة',
                              child: Icon(
                                Icons.location_on,
                                size: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
          error: (message, previousDevices) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('خطأ: $message'),
              ],
            ),
          ),
        );
      },
    );
  }
}
