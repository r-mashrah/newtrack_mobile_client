import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/trip_entity.dart';
import '../providers/history_provider.dart';
import '../utils/trip_map_builder.dart';
import '../utils/history_map_style.dart';
import '../widgets/trip_stats_sheet.dart';
import '../widgets/trip_timeline_sheet.dart';
import '../widgets/trip_stops_sheet.dart';
import '../../../../generated/l10n/app_localizations.dart';

class TripPlaybackScreen extends ConsumerStatefulWidget {
  final TripEntity trip;

  const TripPlaybackScreen({super.key, required this.trip});

  @override
  ConsumerState<TripPlaybackScreen> createState() => _TripPlaybackScreenState();
}

class _TripPlaybackScreenState extends ConsumerState<TripPlaybackScreen>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  Timer? _playbackTimer;
  late TabController _tabController;
  bool _isDarkMap = false;
  MapType _mapType = MapType.normal;
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  /// Local playback index — avoids rebuilding map polylines every frame.
  int _playbackIndex = 0;
  bool _isPlaying = false;
  bool _isFinished = false;
  double _playbackSpeed = 1.0;

  late Set<Polyline> _basePolylines;

  static const double _initialSheetSize = 0.28;
  static const double _playbackBarHeight = 88.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _basePolylines = TripMapBuilder.buildRoutePolylines(
      points: widget.trip.points,
      traveledUpToIndex: -1,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tripPlaybackProvider.notifier).loadTrip(widget.trip);
      _fitRouteBounds();
    });

    _sheetController.addListener(_onSheetSizeChanged);
  }

  void _onSheetSizeChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    _sheetController.removeListener(_onSheetSizeChanged);
    _tabController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  EdgeInsets _mapPadding(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenH = media.size.height;
    final top = media.padding.top + 56;
    final sheetFraction =
        _sheetController.isAttached ? _sheetController.size : _initialSheetSize;
    final bottom = (screenH * sheetFraction) + _playbackBarHeight + 12;
    return EdgeInsets.only(top: top, bottom: bottom, left: 20, right: 20);
  }

  Set<Polyline> _buildPolylines() {
    if (_playbackIndex <= 0) return _basePolylines;
    return TripMapBuilder.buildRoutePolylines(
      points: widget.trip.points,
      traveledUpToIndex: _playbackIndex,
    );
  }

  Set<Marker> _buildMarkers() {
    final trip = widget.trip;
    final markers = <Marker>{};
    if (trip.points.isEmpty) return markers;

    final loc = AppLocalizations.of(context)!;
    final start = trip.points.first;
    final end = trip.points.last;

    markers.add(Marker(
      markerId: const MarkerId('start'),
      position: LatLng(start.lat, start.lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(
        title: loc.startPoint,
        snippet: DateFormat('hh:mm a').format(start.time),
      ),
      zIndex: 5,
    ));

    markers.add(Marker(
      markerId: const MarkerId('end'),
      position: LatLng(end.lat, end.lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(
        title: loc.endPoint,
        snippet: DateFormat('hh:mm a').format(end.time),
      ),
      zIndex: 5,
    ));

    for (final stop in trip.stops) {
      markers.add(Marker(
        markerId: MarkerId('stop_${stop.index}'),
        position: LatLng(stop.lat, stop.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(
          title: '${stop.reason.icon} ${loc.stopIndex(stop.index + 1)}',
          snippet: '${stop.durationFormatted} - ${stop.reason.getName(context)}',
        ),
        zIndex: 4,
      ));
    }

    if (_playbackIndex < trip.points.length) {
      final current = trip.points[_playbackIndex];
      markers.add(Marker(
        markerId: const MarkerId('current'),
        position: LatLng(current.lat, current.lng),
        rotation: current.course,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(
          title: '${current.speed.toStringAsFixed(0)} ${loc.kmh}',
          snippet: DateFormat('hh:mm:ss a').format(current.time),
        ),
        zIndex: 10,
      ));
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
    final padding = _mapPadding(context);

    return Scaffold(
      body: Stack(
        children: [
          if (trip.points.isEmpty)
            Center(child: Text(AppLocalizations.of(context)!.noGpsPoints))
          else
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(trip.points.first.lat, trip.points.first.lng),
                zoom: 13,
              ),
              padding: padding,
              polylines: _buildPolylines(),
              markers: _buildMarkers(),
              mapType: _mapType,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: true,
              tiltGesturesEnabled: false,
              rotateGesturesEnabled: true,
              style: _isDarkMap ? kHistoryDarkMapStyle : null,
              onMapCreated: (controller) async {
                _mapController = controller;
                await Future.delayed(const Duration(milliseconds: 300));
                _fitRouteBounds();
              },
            ),

          _buildTopBar(trip),

          // Compact playback bar — sits just above the bottom sheet
          if (trip.points.isNotEmpty)
            Positioned(
              left: 12,
              right: 12,
              bottom: MediaQuery.of(context).size.height *
                      (_sheetController.isAttached
                          ? _sheetController.size
                          : _initialSheetSize) +
                  8,
              child: _buildCompactPlaybackBar(trip),
            ),

          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: _initialSheetSize,
            minChildSize: 0.12,
            maxChildSize: 0.72,
            snap: true,
            snapSizes: const [0.12, 0.28, 0.72],
            builder: (context, scrollController) {
              return NotificationListener<DraggableScrollableNotification>(
                onNotification: (notification) {
                  if (notification.extent == notification.minExtent ||
                      notification.extent == notification.maxExtent) {
                    _fitRouteBounds();
                  }
                  return false;
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          final target = _sheetController.size > 0.4 ? 0.28 : 0.72;
                          _sheetController.animateTo(
                            target,
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.easeOut,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey.shade600,
                          labelStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          unselectedLabelStyle: const TextStyle(fontSize: 12),
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          tabs: [
                            Tab(
                              text: AppLocalizations.of(context)!.statsTab,
                              height: 36,
                            ),
                            Tab(
                              text: AppLocalizations.of(context)!.timelineTab,
                              height: 36,
                            ),
                            Tab(
                              text: AppLocalizations.of(context)!.stopsTab,
                              height: 36,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            TripStatsSheet(
                              trip: trip,
                              scrollController: scrollController,
                            ),
                            TripTimelineSheet(
                              trip: trip,
                              scrollController: scrollController,
                              onEventTap: _goToEvent,
                            ),
                            TripStopsSheet(
                              trip: trip,
                              scrollController: scrollController,
                              onStopTap: _goToStop,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(TripEntity trip) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 4,
          bottom: 8,
          left: 8,
          right: 8,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.45),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.deviceName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                    ),
                  ),
                  Text(
                    '${DateFormat('yyyy/MM/dd').format(trip.startTime)} • ${trip.durationFormatted}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                    ),
                  ),
                ],
              ),
            ),
            _MapButton(
              icon: _isDarkMap ? Icons.light_mode : Icons.dark_mode,
              onTap: () => setState(() => _isDarkMap = !_isDarkMap),
            ),
            const SizedBox(width: 6),
            _MapButton(
              icon: Icons.layers,
              onTap: () {
                setState(() {
                  _mapType = _mapType == MapType.normal
                      ? MapType.satellite
                      : _mapType == MapType.satellite
                          ? MapType.hybrid
                          : MapType.normal;
                });
              },
            ),
            const SizedBox(width: 6),
            _MapButton(
              icon: Icons.fit_screen,
              onTap: _fitRouteBounds,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactPlaybackBar(TripEntity trip) {
    final loc = AppLocalizations.of(context)!;
    final point = trip.points.isNotEmpty ? trip.points[_playbackIndex] : null;
    final progress = trip.points.isEmpty
        ? 0.0
        : _playbackIndex / (trip.points.length - 1).clamp(1, trip.points.length);

    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(14),
      color: Colors.white.withValues(alpha: 0.96),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (point != null)
              Row(
                children: [
                  _MiniInfo(
                    icon: Icons.speed,
                    value: '${point.speed.toStringAsFixed(0)} ${loc.kmh}',
                  ),
                  _MiniInfo(
                    icon: Icons.schedule,
                    value: DateFormat('HH:mm:ss').format(point.time),
                  ),
                  _MiniInfo(
                    icon: Icons.terrain,
                    value:
                        '${point.altitude.toStringAsFixed(0)} ${loc.meterUnit}',
                  ),
                ],
              ),
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                activeTrackColor: AppTheme.primaryColor,
                inactiveTrackColor: Colors.grey.shade200,
                thumbColor: AppTheme.primaryColor,
              ),
              child: Slider(
                value: progress.clamp(0.0, 1.0),
                onChanged: (v) {
                  final idx =
                      (v * (trip.points.length - 1)).round().clamp(0, trip.points.length - 1);
                  setState(() {
                    _playbackIndex = idx;
                    _isFinished = false;
                  });
                  ref.read(tripPlaybackProvider.notifier).seekTo(idx);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SpeedChip(
                  speed: _playbackSpeed,
                  onTap: () {
                    const speeds = [1.0, 2.0, 4.0, 8.0];
                    final next = speeds[
                        (speeds.indexOf(_playbackSpeed) + 1) % speeds.length];
                    setState(() => _playbackSpeed = next);
                    if (_isPlaying) {
                      _playbackTimer?.cancel();
                      _startPlaybackTimer(next);
                    }
                  },
                ),
                const SizedBox(width: 12),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _seekRelative(-10, trip),
                  icon: const Icon(Icons.replay_10, size: 24),
                ),
                GestureDetector(
                  onTap: _togglePlayback,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0277BD), Color(0xFF03A9F4)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isFinished
                          ? Icons.replay
                          : (_isPlaying ? Icons.pause : Icons.play_arrow),
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _seekRelative(10, trip),
                  icon: const Icon(Icons.forward_10, size: 24),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    setState(() {
                      _playbackIndex = 0;
                      _isPlaying = false;
                      _isFinished = false;
                    });
                    ref.read(tripPlaybackProvider.notifier).reset();
                  },
                  icon: const Icon(Icons.stop, size: 22),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _togglePlayback() {
    if (_isFinished) {
      setState(() {
        _playbackIndex = 0;
        _isFinished = false;
        _isPlaying = true;
      });
      ref.read(tripPlaybackProvider.notifier).reset();
      ref.read(tripPlaybackProvider.notifier).play();
      _startPlaybackTimer(_playbackSpeed);
      return;
    }

    if (_isPlaying) {
      setState(() => _isPlaying = false);
      _playbackTimer?.cancel();
      ref.read(tripPlaybackProvider.notifier).pause();
    } else {
      setState(() => _isPlaying = true);
      ref.read(tripPlaybackProvider.notifier).play();
      _startPlaybackTimer(_playbackSpeed);
    }
  }

  void _seekRelative(int delta, TripEntity trip) {
    final idx = (_playbackIndex + delta).clamp(0, trip.points.length - 1);
    setState(() {
      _playbackIndex = idx;
      _isFinished = false;
    });
    ref.read(tripPlaybackProvider.notifier).seekTo(idx);
  }

  /// Playback updates marker only — camera stays fixed so path remains visible.
  void _startPlaybackTimer(double speed) {
    _playbackTimer?.cancel();
    final ms = (400 / speed).round().clamp(50, 2000);
    _playbackTimer = Timer.periodic(Duration(milliseconds: ms), (_) {
      if (!_isPlaying || !mounted) return;

      final trip = widget.trip;
      final next = _playbackIndex + 1;
      if (next >= trip.points.length) {
        setState(() {
          _isPlaying = false;
          _isFinished = true;
        });
        _playbackTimer?.cancel();
        ref.read(tripPlaybackProvider.notifier).pause();
        return;
      }

      setState(() => _playbackIndex = next);
      ref.read(tripPlaybackProvider.notifier).seekTo(next);
    });
  }

  Future<void> _fitRouteBounds() async {
    if (_mapController == null || widget.trip.points.isEmpty) return;

    final bounds = TripMapBuilder.boundsFromPoints(widget.trip.points);
    try {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 48),
      );
    } catch (_) {
      // Fallback for degenerate bounds
      final first = widget.trip.points.first;
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(first.lat, first.lng), 14),
      );
    }
  }

  void _goToEvent(TripEvent event) {
    if (event.lat == null || event.lng == null) return;
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(event.lat!, event.lng!), 16),
    );
  }

  void _goToStop(TripStop stop) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(stop.lat, stop.lng), 16),
    );
  }
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _MapButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: Colors.black87),
      ),
    );
  }
}

class _MiniInfo extends StatelessWidget {
  final IconData icon;
  final String value;
  const _MiniInfo({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 13, color: AppTheme.primaryColor),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpeedChip extends StatelessWidget {
  final double speed;
  final VoidCallback onTap;
  const _SpeedChip({required this.speed, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          '${speed.toStringAsFixed(0)}x',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }
}
