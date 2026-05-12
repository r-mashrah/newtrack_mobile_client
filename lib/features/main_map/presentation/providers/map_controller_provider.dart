import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapControllerNotifier extends StateNotifier<GoogleMapController?> {
  MapControllerNotifier() : super(null);

  void setController(GoogleMapController controller) {
    state = controller;
  }

  void zoomIn() {
    state?.animateCamera(CameraUpdate.zoomIn());
  }

  void zoomOut() {
    state?.animateCamera(CameraUpdate.zoomOut());
  }

  void animateTo(LatLng position, {double zoom = 15}) {
    state?.animateCamera(CameraUpdate.newLatLngZoom(position, zoom));
  }
}

final mapControllerProvider = StateNotifierProvider<MapControllerNotifier, GoogleMapController?>((ref) {
  return MapControllerNotifier();
});
