import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../../../../domain/entities/device_entity.dart';
import '../../../../domain/entities/history_entity.dart';
import '../providers/devices_provider.dart';
import '../providers/map_style_provider.dart';
import 'device_info_bottom_sheet.dart';
import 'map_utilities_manager.dart';
import '../providers/map_controller_provider.dart';
import '../../../history/presentation/providers/history_provider.dart';
import '../../../history/presentation/utils/trip_map_builder.dart';
import '../../../../domain/entities/trip_entity.dart';

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
  final Map<String, BitmapDescriptor> _customMarkers = {};

  LocationData? _currentLocation;
  final Location _location = Location();

  bool _isMapInitialized = false;
  bool _isLocationPermissionGranted = false;
  bool _hasCenteredOnDevices = false;

  DeviceEntity? _selectedDevice;

  static const CameraPosition _defaultLocation = CameraPosition(
    target: LatLng(15.3694, 44.1910),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<BitmapDescriptor> _createSmartMarker(
    Color statusColor,
    double speed,
    double bearing,
    String name,
    bool showName,
  ) async {
    final double size = showName ? 160 : 120;
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final double markerRadius = 24;
    final Offset center = Offset(size / 2, size / 2 - (showName ? 20 : 0));

    // 1. Draw Glow (Light Opacity 0.25)
    final Paint glowPaint = Paint()
      ..color = statusColor.withOpacity(0.25)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, markerRadius + 6, glowPaint);

    // 2. Draw Marker Base (White Circle with Border)
    final Paint bgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final Paint borderPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Small shadow
    final Path circlePath = Path()..addOval(Rect.fromCircle(center: center, radius: markerRadius));
    canvas.drawShadow(circlePath, Colors.black, 3, false);

    canvas.drawCircle(center, markerRadius, bgPaint);
    canvas.drawCircle(center, markerRadius, borderPaint);

    // 3. Draw Directional Arrow
    // We rotate the canvas to draw the arrow pointing to the actual bearing
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate((bearing) * 3.1415926535897932 / 180);

    final Path arrowPath = Path();
    arrowPath.moveTo(0, -markerRadius * 0.5); // Tip
    arrowPath.lineTo(markerRadius * 0.4, markerRadius * 0.4); // Bottom right
    arrowPath.lineTo(0, markerRadius * 0.15); // Bottom center dip
    arrowPath.lineTo(-markerRadius * 0.4, markerRadius * 0.4); // Bottom left
    arrowPath.close();

    final Paint arrowPaint = Paint()
      ..color = statusColor
      ..style = PaintingStyle.fill;
    
    // Add a slight gradient or depth to arrow if needed, but solid is clean
    canvas.drawPath(arrowPath, arrowPaint);
    canvas.restore();

    // 4. Draw Speed Badge (Overlapping Bottom Right)
    if (speed >= 0) { // Always show speed badge for consistency, even if 0
      final String speedText = speed > 999 ? '999+' : speed.toInt().toString();
      
      TextPainter speedPainter = TextPainter(textDirection: TextDirection.ltr);
      speedPainter.text = TextSpan(
        text: speedText,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
      speedPainter.layout();

      // Auto-sizing width with minimum limits
      final double badgeWidth = speedPainter.width < 16 ? 24 : speedPainter.width + 12;
      final double badgeHeight = 20;
      
      final Rect badgeRect = Rect.fromCenter(
        center: Offset(center.dx + markerRadius * 0.7, center.dy + markerRadius * 0.7),
        width: badgeWidth,
        height: badgeHeight,
      );

      final Paint badgeBgPaint = Paint()
        ..color = Colors.black87
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(badgeRect, const Radius.circular(10)),
        badgeBgPaint,
      );

      speedPainter.paint(
        canvas,
        Offset(
          badgeRect.center.dx - speedPainter.width / 2,
          badgeRect.center.dy - speedPainter.height / 2,
        ),
      );
    }

    // 5. Draw Name Label (Solid background, crisp text)
    if (showName) {
      TextPainter namePainter = TextPainter(
        textDirection: TextDirection.rtl,
        maxLines: 1,
        ellipsis: '...',
      );
      namePainter.text = TextSpan(
        text: name,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      );
      namePainter.layout(maxWidth: size - 10); // Prevent overflow

      final double nameWidth = namePainter.width + 16;
      final double nameHeight = namePainter.height + 8;
      final Rect nameRect = Rect.fromCenter(
        center: Offset(center.dx, center.dy + markerRadius + 24),
        width: nameWidth,
        height: nameHeight,
      );

      // Solid white background with subtle border/shadow (No Glassmorphism)
      final Path nameBoxPath = Path()..addRRect(RRect.fromRectAndRadius(nameRect, const Radius.circular(8)));
      canvas.drawShadow(nameBoxPath, Colors.black26, 2, false);

      final Paint nameBgPaint = Paint()..color = const Color(0xFFF8F9FA); // Off-white
      canvas.drawRRect(
        RRect.fromRectAndRadius(nameRect, const Radius.circular(8)),
        nameBgPaint,
      );

      // Light border
      canvas.drawRRect(
        RRect.fromRectAndRadius(nameRect, const Radius.circular(8)),
        borderPaint..strokeWidth = 1.0,
      );

      namePainter.paint(
        canvas,
        Offset(
          nameRect.center.dx - namePainter.width / 2,
          nameRect.center.dy - namePainter.height / 2,
        ),
      );
    }

    final ui.Image image = await pictureRecorder.endRecording().toImage(
      size.toInt(),
      size.toInt(),
    );
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  Future<void> _generateAndCacheMarker(
    String key,
    Color color,
    double speed,
    double bearing,
    String name,
    bool showName,
  ) async {
    if (_customMarkers.containsKey(key)) return;

    final marker = await _createSmartMarker(color, speed, bearing, name, showName);
    if (mounted) {
      setState(() {
        _customMarkers[key] = marker;
      });
    }
  }

  @override
  void dispose() {
    if (_isMapInitialized) {
      _mapController.dispose();
    }
    super.dispose();
  }

  void _fitBounds(List<DeviceEntity> devices) {
    if (devices.isEmpty || !_isMapInitialized) return;

    if (devices.length == 1) {
      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            devices.first.lastLocation.latitude,
            devices.first.lastLocation.longitude,
          ),
          14,
        ),
      );
      return;
    }

    double minLat = devices.first.lastLocation.latitude;
    double maxLat = devices.first.lastLocation.latitude;
    double minLng = devices.first.lastLocation.longitude;
    double maxLng = devices.first.lastLocation.longitude;

    for (var d in devices) {
      if (d.lastLocation.latitude < minLat) minLat = d.lastLocation.latitude;
      if (d.lastLocation.latitude > maxLat) maxLat = d.lastLocation.latitude;
      if (d.lastLocation.longitude < minLng) minLng = d.lastLocation.longitude;
      if (d.lastLocation.longitude > maxLng) maxLng = d.lastLocation.longitude;
    }

    _mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        50.0,
      ),
    );
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

    if (_isMapInitialized &&
        _currentLocation != null &&
        !_hasCenteredOnDevices) {
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
    bool showName =
        devices.length == 1; // Only show name directly on map if 1 device

    return devices.map((device) {
      final position = LatLng(
        device.lastLocation.latitude,
        device.lastLocation.longitude,
      );

      return Marker(
        markerId: MarkerId(device.id),
        position: position,
        icon: _getSmartMarkerIcon(device, showName),
        // No rotation here! The image itself has the rotated arrow.
        // This ensures text stays upright.
        rotation: 0, 
        anchor: Offset(0.5, showName ? 0.6 : 0.5), // Adjust anchor based on text box
        onTap: () => _onMarkerTap(device),
      );
    }).toSet();
  }

  Color _getDeviceStatusColor(DeviceEntity device) {
    final speed = device.speed ?? 0.0;
    final lastUpdate = device.lastUpdate;

    if (lastUpdate == null ||
        DateTime.now().difference(lastUpdate).inMinutes > 60) {
      return const Color(0xFFD32F2F); // Offline (Muted Red)
    } else if (speed > 0) {
      return const Color(0xFF1976D2); // Moving (Blue)
    } else if (device.status == 'idle') {
      return const Color(0xFFFBC02D); // Idle (Soft Yellow)
    } else {
      return const Color(0xFF388E3C); // Online but not moving (Green)
    }
  }

  BitmapDescriptor _getSmartMarkerIcon(DeviceEntity device, bool showName) {
    final statusColor = _getDeviceStatusColor(device);
    final speed = device.speed ?? 0.0;
    final rawBearing = device.lastLocation.bearing ?? 0.0;
    
    // Round bearing to nearest 10 degrees to limit cache combinations
    final double bearingRound = (rawBearing / 10).round() * 10.0;

    final String nameKey = showName ? '_${device.name}' : '';
    final String key =
        '${statusColor.value}_${speed.toInt()}_${bearingRound}_$showName$nameKey';

    if (_customMarkers.containsKey(key)) {
      return _customMarkers[key]!;
    }

    _generateAndCacheMarker(key, statusColor, speed, bearingRound, device.name, showName);

    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
  }

  void _fitHistoryBounds(List<HistoryEntity> points) {
    if (points.isEmpty || !_isMapInitialized) return;

    final gpsPoints = points
        .map(
          (p) => GpsPoint(
            lat: p.latitude,
            lng: p.longitude,
            speed: p.speed,
            altitude: p.altitude,
            course: p.course,
            time: p.timestamp,
          ),
        )
        .toList();

    final bounds = TripMapBuilder.boundsFromPoints(gpsPoints);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100),
      );
    });
  }

  void _onMarkerTap(DeviceEntity device) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedDevice = device;
    });

    // Animate camera to the tapped marker
    _mapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(device.lastLocation.latitude, device.lastLocation.longitude),
      ),
    );

    // Open the bottom sheet immediately upon tapping the marker
    _openFullBottomSheet();
  }

  void _openFullBottomSheet() {
    if (_selectedDevice == null) return;
    final device = _selectedDevice!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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

    // مراقبة تغييرات السجل التاريخي لتكبير الخريطة عليه تلقائياً عند تحميله
    ref.listen<AsyncValue<List<HistoryEntity>>>(historyNotifierProvider, (
      previous,
      next,
    ) {
      next.when(
        data: (points) {
          if (points.isNotEmpty) {
            _fitHistoryBounds(points);
          } else if (previous?.isLoading == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('لا توجد بيانات مسار في هذه الفترة'),
              ),
            );
          }
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('خطأ في جلب السجل: $error')));
        },
        loading: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('جاري تحميل السجل...')));
        },
      );
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
          _markers.addAll(
            MapUtilitiesManager.buildPointsOfInterest(devices, true),
          );
        }

        _polylines.clear();

        // 1. عرض المسار الحي للأجهزة إذا كان مفعلاً
        if (mapStyle.showTrail) {
          _polylines.addAll(
            MapUtilitiesManager.buildAdvancedTrails(devices, true),
          );
        }

        // 2. عرض السجل التاريخي إذا تم طلبه
        final historyState = ref.watch(historyNotifierProvider);
        historyState.whenData((historyPoints) {
          if (historyPoints.isNotEmpty) {
            final gpsPoints = historyPoints
                .map(
                  (h) => GpsPoint(
                    lat: h.latitude,
                    lng: h.longitude,
                    speed: h.speed,
                    altitude: h.altitude,
                    course: h.course,
                    time: h.timestamp,
                  ),
                )
                .toList();

            _polylines.addAll(
              TripMapBuilder.buildRoutePolylines(
                points: gpsPoints,
                idPrefix: 'history',
              ),
            );

            _markers.add(
              Marker(
                markerId: const MarkerId('history_start'),
                position: LatLng(
                  historyPoints.first.latitude,
                  historyPoints.first.longitude,
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen,
                ),
                infoWindow: const InfoWindow(title: 'بداية المسار'),
                zIndex: 6,
              ),
            );
            _markers.add(
              Marker(
                markerId: const MarkerId('history_end'),
                position: LatLng(
                  historyPoints.last.latitude,
                  historyPoints.last.longitude,
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed,
                ),
                infoWindow: const InfoWindow(title: 'نهاية المسار'),
                zIndex: 6,
              ),
            );
          }
        });

        _circles.clear();
        if (mapStyle.showGeofences) {
          _circles.addAll(
            MapUtilitiesManager.buildAdvancedGeofences(devices, true),
          );
        }

        if (!_hasCenteredOnDevices && devices.isNotEmpty && _isMapInitialized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _fitBounds(devices);
            _hasCenteredOnDevices = true;
          });
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
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

            // Mini Floating Card removed:
            // The marker tap now opens the full device details dashboard directly.
          ],
        );
      },
      error: (err, stack) => Center(child: Text('خطأ: $err')),
    );
  }

  Widget _buildMiniFloatingCard() {
    final device = _selectedDevice!;
    final statusColor = _getDeviceStatusColor(device);

    String timeAgo = 'غير متاح';
    if (device.lastUpdate != null) {
      final diff = DateTime.now().difference(device.lastUpdate!);
      if (diff.inMinutes < 1)
        timeAgo = 'الآن';
      else if (diff.inHours < 1)
        timeAgo = 'منذ ${diff.inMinutes} دقيقة';
      else if (diff.inDays < 1)
        timeAgo = 'منذ ${diff.inHours} ساعة';
      else
        timeAgo = 'منذ ${diff.inDays} يوم';
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity! < 0) {
                  _openFullBottomSheet();
                }
              },
              onTap: _openFullBottomSheet,
              child: Card(
                elevation: 8,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.directions_car,
                            color: statusColor,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  device.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: statusColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'آخر تحديث: $timeAgo',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (device.speed != null && device.speed! > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${device.speed!.toInt()} كم/س',
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.keyboard_arrow_up,
                            size: 16,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'اسحب للأعلى للمزيد',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
