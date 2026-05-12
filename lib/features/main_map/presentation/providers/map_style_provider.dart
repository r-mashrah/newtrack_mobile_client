import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_style_provider.freezed.dart';

/// أنماط الخريطة المتاحة
enum MapStyleType {
  normal,
  satellite,
  terrain,
  hybrid,
  night,
}

/// حالة نمط الخريطة
@freezed
class MapStyleState with _$MapStyleState {
  const factory MapStyleState({
    required MapStyleType currentStyle,
    required bool showTrail,
    required bool showGeofences,
    required bool showPoI,
  }) = _MapStyleState;

  factory MapStyleState.initial() => const MapStyleState(
    currentStyle: MapStyleType.terrain,
    showTrail: false,
    showGeofences: false,
    showPoI: false,
  );
}

/// Notifier لإدارة نمط الخريطة
class MapStyleNotifier extends StateNotifier<MapStyleState> {
  MapStyleNotifier() : super(MapStyleState.initial());

  /// تحديث نمط الخريطة
  void setMapStyle(MapStyleType style) {
    state = state.copyWith(currentStyle: style);
  }

  /// تبديل عرض المسار
  void toggleTrail() {
    state = state.copyWith(showTrail: !state.showTrail);
  }

  /// تبديل عرض الأسوار الجغرافية
  void toggleGeofences() {
    state = state.copyWith(showGeofences: !state.showGeofences);
  }

  /// تبديل عرض نقاط الاهتمام
  void togglePoI() {
    state = state.copyWith(showPoI: !state.showPoI);
  }

  /// تعيين جميع الخيارات
  void setAllOptions({
    required MapStyleType style,
    required bool showTrail,
    required bool showGeofences,
    required bool showPoI,
  }) {
    state = MapStyleState(
      currentStyle: style,
      showTrail: showTrail,
      showGeofences: showGeofences,
      showPoI: showPoI,
    );
  }
}

/// Provider لإدارة نمط الخريطة
final mapStyleNotifierProvider =
    StateNotifierProvider<MapStyleNotifier, MapStyleState>((ref) {
  return MapStyleNotifier();
});

/// Provider لحالة نمط الخريطة (للقراءة فقط)
final mapStyleStateProvider = Provider<MapStyleState>((ref) {
  return ref.watch(mapStyleNotifierProvider);
});

/// Provider لنمط الخريطة بصيغة JSON
final mapStyleJsonProvider = Provider<String>((ref) {
  final style = ref.watch(mapStyleStateProvider);
  return _getMapStyleJson(style.currentStyle);
});

/// دالة للحصول على نمط الخريطة بصيغة JSON
String _getMapStyleJson(MapStyleType style) {
  switch (style) {
    case MapStyleType.normal:
      return _normalStyle;
    case MapStyleType.satellite:
      return _satelliteStyle;
    case MapStyleType.terrain:
      return _terrainStyle;
    case MapStyleType.hybrid:
      return _hybridStyle;
    case MapStyleType.night:
      return _nightStyle;
  }
}

// ==================== أنماط الخريطة ====================

/// النمط الطبيعي
const String _normalStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]
''';

/// نمط الليل
const String _nightStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#1a1a1a"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1a1a1a"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#4a4a4a"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#86753d"
      }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#2a2a2a"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#38414e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#212a37"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9ca5b0"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#2c3e50"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#1a1a1a"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#f3d19c"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#2a3a4a"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#d59563"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#17263c"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#515c6d"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#17263c"
      }
    ]
  }
]
''';

/// نمط التضاريس
const String _terrainStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e4e4e4"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#cccccc"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#ddd"
      }
    ]
  },
  {
    "featureType": "landscape",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f3f3f3"
      }
    ]
  },
  {
    "featureType": "landscape.natural",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ddd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#e1e1e1"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ddd"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#b3d9ff"
      }
    ]
  }
]
''';

/// نمط الأقمار الصناعية (مخصص)
const String _satelliteStyle = '''
[
  {
    "elementType": "labels",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "administrative.country",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#cccccc"
      }
    ]
  }
]
''';

/// نمط الهجين (مخصص)
const String _hybridStyle = '''
[
  {
    "featureType": "administrative",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#a3a3a3"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#98a5be"
      }
    ]
  },
  {
    "featureType": "landscape",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eaeaea"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  }
]
''';
