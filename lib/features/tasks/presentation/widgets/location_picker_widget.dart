import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '../../../../core/theme/app_theme.dart';
import 'dart:async';

class LocationPickerWidget extends StatefulWidget {
  final Function(LatLng position, String address) onLocationSelected;
  final LatLng initialPosition;

  const LocationPickerWidget({
    super.key,
    required this.onLocationSelected,
    this.initialPosition = const LatLng(15.3694, 44.1910), // Default to Sana'a
  });

  @override
  State<LocationPickerWidget> createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  late GoogleMapController _mapController;
  LatLng _currentPosition = const LatLng(15.3694, 44.1910);
  String _currentAddress = "جاري تحديد العنوان...";
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.initialPosition;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  // هذه الدالة يتم استدعاؤها فوراً عند تحريك الخريطة
  void _onCameraMove(CameraPosition position) {
    setState(() {
      _currentPosition = position.target;
      _currentAddress = "جاري البحث عن العنوان...";
    });

    // استخدام Debounce لتقليل عدد طلبات Geocoding أثناء التحريك السريع
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _getAddressFromLatLng(_currentPosition);
    });
  }

  // دالة تحويل الإحداثيات إلى عنوان نصي (Reverse Geocoding)
  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        // localeIdentifier: "en", // أو "ar" حسب الرغبة
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          // بناء العنوان بشكل مفصل كما في الصورة
          _currentAddress = "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
          // تنظيف العنوان من الفواصل الزائدة إذا كانت بعض الحقول فارغة
          _currentAddress = _currentAddress.replaceAll(RegExp(r', ,'), ',').trim();
          if (_currentAddress.startsWith(',')) _currentAddress = _currentAddress.substring(1).trim();
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = "إحداثيات: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.initialPosition,
              zoom: 15,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              _getAddressFromLatLng(widget.initialPosition);
            },
            onCameraMove: _onCameraMove,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: false,
          ),
          // مؤشر الموقع الثابت في المنتصف (Custom Marker)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35),
              child: Image.network(
                'https://maps.gstatic.com/mapfiles/api-3/images/spotlight-poi2_hdpi.png',
                height: 45,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.location_on,
                  size: 45,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // زر العودة
          Positioned(
            top: 40,
            left: 20,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          // مربع العنوان وزر التأكيد في الأسفل كما في الصورة
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // زر التأكيد (الدائرة البيضاء مع علامة الصح الزرقاء)
                GestureDetector(
                  onTap: () {
                    widget.onLocationSelected(_currentPosition, _currentAddress);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        color: Color(0xFF00ACC1),
                        size: 35,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // مربع العنوان الأبيض
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Text(
                      _currentAddress,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
