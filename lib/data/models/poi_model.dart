import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entities/map_object_entities.dart';

class POIModel {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String icon;
  final DateTime createdAt;

  POIModel({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.icon,
    required this.createdAt,
  });

  factory POIModel.fromGpswoxJson(Map<String, dynamic> json) {
    return POIModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown POI',
      description: json['description']?.toString() ?? '',
      latitude: double.tryParse(json['lat']?.toString() ?? '0') ?? 0.0,
      longitude: double.tryParse(json['lng']?.toString() ?? '0') ?? 0.0,
      icon: json['icon']?.toString() ?? 'default',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  POIEntity toEntity() {
    return POIEntity(
      id: id,
      name: name,
      description: description,
      position: LatLng(latitude, longitude),
      icon: icon,
      createdAt: createdAt,
    );
  }
}
