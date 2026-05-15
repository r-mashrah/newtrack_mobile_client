import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entities/map_object_entities.dart';

class GeofenceModel extends GeofenceEntity {
  GeofenceModel({
    required super.id,
    required super.name,
    required super.points,
    required super.color,
    required super.createdAt,
  });

  factory GeofenceModel.fromGpswoxJson(Map<String, dynamic> json) {
    List<LatLng> points = [];
    if (json['polygon'] != null) {
      try {
        final polygonData = json['polygon'];
        if (polygonData is List) {
          for (var point in polygonData) {
            points.add(LatLng(
              double.tryParse(point['lat']?.toString() ?? '0') ?? 0.0,
              double.tryParse(point['lng']?.toString() ?? '0') ?? 0.0,
            ));
          }
        }
      } catch (e) {
        debugPrint('Error parsing geofence polygon: $e');
      }
    }

    Color color = const Color(0xFF1D99BD);
    if (json['polygon_color'] != null) {
      try {
        String hex = json['polygon_color'].toString().replaceAll('#', '');
        if (hex.length == 6) {
          color = Color(int.parse('0xFF$hex'));
        }
      } catch (_) {}
    }

    return GeofenceModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Geofence',
      points: points,
      color: color,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  GeofenceEntity toEntity() {
    return GeofenceEntity(
      id: id,
      name: name,
      points: points,
      color: color,
      createdAt: createdAt,
    );
  }
}
