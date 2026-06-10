import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeofenceEntity {
  final String id;
  final String name;
  final List<LatLng> points;
  final Color color;
  final DateTime createdAt;

  GeofenceEntity({
    required this.id,
    required this.name,
    required this.points,
    required this.color,
    required this.createdAt,
  });

  GeofenceEntity copyWith({
    String? id,
    String? name,
    List<LatLng>? points,
    Color? color,
    DateTime? createdAt,
  }) {
    return GeofenceEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      points: points ?? this.points,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class POIEntity {
  final String id;
  final String name;
  final LatLng position;
  final String? description;
  final String? icon;
  final DateTime createdAt;

  POIEntity({
    required this.id,
    required this.name,
    required this.position,
    this.description,
    this.icon,
    required this.createdAt,
  });

  POIEntity copyWith({
    String? id,
    String? name,
    LatLng? position,
    String? description,
    String? icon,
    DateTime? createdAt,
  }) {
    return POIEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
