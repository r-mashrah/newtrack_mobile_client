import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/trip_entity.dart';
import '../../../../domain/entities/device_entity.dart';
import '../../../../domain/entities/history_entity.dart';
import '../../../../core/providers/repository_providers.dart';
import '../../../../core/services/trip_analyzer.dart';
import '../../../main_map/presentation/providers/devices_provider.dart';

// ==================== State Classes ====================

enum HistoryFilterPreset { today, yesterday, lastWeek, lastMonth, custom }

enum TripChipFilter { all, longTrip, shortTrip, stops, fastTrip, alerts, night }

class HistoryFilterState {
  final HistoryFilterPreset preset;
  final DateTime fromDate;
  final DateTime toDate;
  final TripChipFilter chipFilter;
  final double? minDistance;
  final double? maxDistance;
  final double? minSpeed;
  final int? minStops;
  final String searchQuery;

  const HistoryFilterState({
    this.preset = HistoryFilterPreset.today,
    required this.fromDate,
    required this.toDate,
    this.chipFilter = TripChipFilter.all,
    this.minDistance,
    this.maxDistance,
    this.minSpeed,
    this.minStops,
    this.searchQuery = '',
  });

  HistoryFilterState copyWith({
    HistoryFilterPreset? preset,
    DateTime? fromDate,
    DateTime? toDate,
    TripChipFilter? chipFilter,
    double? minDistance,
    double? maxDistance,
    double? minSpeed,
    int? minStops,
    String? searchQuery,
  }) {
    return HistoryFilterState(
      preset: preset ?? this.preset,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      chipFilter: chipFilter ?? this.chipFilter,
      minDistance: minDistance ?? this.minDistance,
      maxDistance: maxDistance ?? this.maxDistance,
      minSpeed: minSpeed ?? this.minSpeed,
      minStops: minStops ?? this.minStops,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class HistoryPageState {
  final bool isLoading;
  final bool isRefreshing;
  final List<TripEntity> allTrips;
  final List<TripEntity> filteredTrips;
  final HistoryFilterState filter;
  final String? selectedDeviceId;
  final String? error;
  final bool hasData;

  const HistoryPageState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.allTrips = const [],
    this.filteredTrips = const [],
    required this.filter,
    this.selectedDeviceId,
    this.error,
    this.hasData = false,
  });

  HistoryPageState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    List<TripEntity>? allTrips,
    List<TripEntity>? filteredTrips,
    HistoryFilterState? filter,
    String? selectedDeviceId,
    String? error,
    bool? hasData,
  }) {
    return HistoryPageState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      allTrips: allTrips ?? this.allTrips,
      filteredTrips: filteredTrips ?? this.filteredTrips,
      filter: filter ?? this.filter,
      selectedDeviceId: selectedDeviceId ?? this.selectedDeviceId,
      error: error,
      hasData: hasData ?? this.hasData,
    );
  }
}

// ==================== Notifier ====================

class HistoryPageNotifier extends StateNotifier<HistoryPageState> {
  final Ref _ref;

  HistoryPageNotifier(this._ref)
      : super(HistoryPageState(
          filter: HistoryFilterState(
            preset: HistoryFilterPreset.today,
            fromDate: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ),
            toDate: DateTime.now(),
          ),
        ));

  /// تحديد الجهاز المحدد
  void selectDevice(String deviceId) {
    state = state.copyWith(selectedDeviceId: deviceId);
  }

  /// تعيين فلتر مسبق الضبط
  void setPreset(HistoryFilterPreset preset) {
    final now = DateTime.now();
    DateTime from;
    DateTime to = now;

    switch (preset) {
      case HistoryFilterPreset.today:
        from = DateTime(now.year, now.month, now.day);
        break;
      case HistoryFilterPreset.yesterday:
        final yesterday = now.subtract(const Duration(days: 1));
        from = DateTime(yesterday.year, yesterday.month, yesterday.day);
        to = DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
        break;
      case HistoryFilterPreset.lastWeek:
        from = now.subtract(const Duration(days: 7));
        break;
      case HistoryFilterPreset.lastMonth:
        from = now.subtract(const Duration(days: 30));
        break;
      case HistoryFilterPreset.custom:
        from = state.filter.fromDate;
        break;
    }

    state = state.copyWith(
      filter: state.filter.copyWith(preset: preset, fromDate: from, toDate: to),
    );

    if (state.selectedDeviceId != null) {
      fetchTrips();
    }
  }

  void setCustomDateRange(DateTime from, DateTime to) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        preset: HistoryFilterPreset.custom,
        fromDate: from,
        toDate: to,
      ),
    );

    if (state.selectedDeviceId != null) {
      fetchTrips();
    }
  }

  void setChipFilter(TripChipFilter chip) {
    state = state.copyWith(
      filter: state.filter.copyWith(chipFilter: chip),
    );
    _applyFilters();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(
      filter: state.filter.copyWith(searchQuery: query),
    );
    _applyFilters();
  }

  /// جلب السجل من API
  Future<void> fetchTrips() async {
    if (state.selectedDeviceId == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final repo = _ref.read(historyRepositoryProvider);
      final fromStr = _formatDateTime(state.filter.fromDate, isStart: true);
      final toStr = _formatDateTime(state.filter.toDate, isStart: false);

      final rawPoints = await repo.getHistory(
        state.selectedDeviceId!,
        fromStr,
        toStr,
      );

      // الحصول على معلومات الجهاز
      final devicesState = _ref.read(devicesNotifierProvider);
      DeviceEntity? device;
      devicesState.maybeWhen(
        loaded: (devices, _, __, ___) {
          try {
            device = devices.firstWhere((d) => d.id == state.selectedDeviceId);
          } catch (_) {}
        },
        orElse: () {},
      );

      // تحليل وتجميع الرحلات (خارج دورة الـ UI frame)
      final trips = await Future(
        () => TripAnalyzer.groupPointsIntoTrips(
          deviceId: state.selectedDeviceId!,
          deviceName: device?.name ?? 'جهاز غير معروف',
          plateNumber: device?.plateNumber,
          rawPoints: rawPoints,
        ),
      );

      // ترتيب تنازلياً (الأحدث أولاً)
      trips.sort((a, b) => b.startTime.compareTo(a.startTime));

      state = state.copyWith(
        isLoading: false,
        allTrips: trips,
        hasData: true,
      );

      _applyFilters();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// تطبيق الفلاتر على الرحلات المحملة
  void _applyFilters() {
    var filtered = List<TripEntity>.from(state.allTrips);
    final filter = state.filter;

    // فلتر البحث
    if (filter.searchQuery.isNotEmpty) {
      final query = filter.searchQuery.toLowerCase();
      filtered = filtered.where((t) =>
        t.deviceName.toLowerCase().contains(query) ||
        (t.plateNumber?.toLowerCase().contains(query) ?? false)
      ).toList();
    }

    // فلتر Chips
    switch (filter.chipFilter) {
      case TripChipFilter.longTrip:
        filtered = filtered.where((t) => t.distanceKm > 100).toList();
        break;
      case TripChipFilter.shortTrip:
        filtered = filtered.where((t) => t.distanceKm < 10).toList();
        break;
      case TripChipFilter.stops:
        filtered = filtered.where((t) => t.stopsCount >= 2).toList();
        break;
      case TripChipFilter.fastTrip:
        filtered = filtered.where((t) => t.maxSpeed > 100).toList();
        break;
      case TripChipFilter.alerts:
        filtered = filtered.where((t) => t.hasOverSpeed).toList();
        break;
      case TripChipFilter.night:
        filtered = filtered.where((t) =>
          t.startTime.hour >= 21 || t.startTime.hour < 6
        ).toList();
        break;
      case TripChipFilter.all:
        break;
    }

    state = state.copyWith(filteredTrips: filtered);
  }

  String _formatDateTime(DateTime dt, {required bool isStart}) {
    final h = isStart ? '00' : '23';
    final m = isStart ? '00' : '59';
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} $h:$m:00';
  }

  void clearError() => state = state.copyWith(error: null);
  
  void reset() {
    state = HistoryPageState(
      filter: HistoryFilterState(
        preset: HistoryFilterPreset.today,
        fromDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
        toDate: DateTime.now(),
      ),
    );
  }
}

// ==================== Provider ====================

final historyPageProvider = StateNotifierProvider<HistoryPageNotifier, HistoryPageState>((ref) {
  return HistoryPageNotifier(ref);
});

// ==================== Trip Playback State ====================

class TripPlaybackState {
  final TripEntity? trip;
  final bool isPlaying;
  final int currentPointIndex;
  final double playbackSpeed; // 1x, 2x, 4x, 8x
  final bool isFinished;

  const TripPlaybackState({
    this.trip,
    this.isPlaying = false,
    this.currentPointIndex = 0,
    this.playbackSpeed = 1.0,
    this.isFinished = false,
  });

  GpsPoint? get currentPoint => 
    trip != null && currentPointIndex < trip!.points.length
      ? trip!.points[currentPointIndex]
      : null;

  double get progress => 
    trip == null || trip!.points.isEmpty 
      ? 0 
      : currentPointIndex / trip!.points.length;

  TripPlaybackState copyWith({
    TripEntity? trip,
    bool? isPlaying,
    int? currentPointIndex,
    double? playbackSpeed,
    bool? isFinished,
  }) {
    return TripPlaybackState(
      trip: trip ?? this.trip,
      isPlaying: isPlaying ?? this.isPlaying,
      currentPointIndex: currentPointIndex ?? this.currentPointIndex,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}

class TripPlaybackNotifier extends StateNotifier<TripPlaybackState> {
  TripPlaybackNotifier() : super(const TripPlaybackState());

  void loadTrip(TripEntity trip) {
    state = TripPlaybackState(trip: trip);
  }

  void play() => state = state.copyWith(isPlaying: true, isFinished: false);
  void pause() => state = state.copyWith(isPlaying: false);
  
  void setSpeed(double speed) => state = state.copyWith(playbackSpeed: speed);

  void seekTo(int index) {
    if (state.trip == null) return;
    final clamped = index.clamp(0, state.trip!.points.length - 1);
    state = state.copyWith(currentPointIndex: clamped, isFinished: false);
  }

  void seekToProgress(double progress) {
    if (state.trip == null || state.trip!.points.isEmpty) return;
    final idx = (progress * (state.trip!.points.length - 1)).round();
    seekTo(idx);
  }

  void nextFrame() {
    if (state.trip == null) return;
    final next = state.currentPointIndex + 1;
    if (next >= state.trip!.points.length) {
      state = state.copyWith(isPlaying: false, isFinished: true);
    } else {
      state = state.copyWith(currentPointIndex: next);
    }
  }

  void reset() {
    state = state.copyWith(
      currentPointIndex: 0,
      isPlaying: false,
      isFinished: false,
    );
  }

  void stop() => state = const TripPlaybackState();
}

final tripPlaybackProvider = StateNotifierProvider<TripPlaybackNotifier, TripPlaybackState>((ref) {
  return TripPlaybackNotifier();
});

// ==================== Legacy History Notifier (For MapView Compatibility) ====================

class HistoryNotifier extends StateNotifier<AsyncValue<List<HistoryEntity>>> {
  final Ref _ref;

  HistoryNotifier(this._ref) : super(const AsyncValue.data([]));

  Future<void> fetchHistory(String deviceId, String fromDate, String toDate) async {
    state = const AsyncValue.loading();
    try {
      final repo = _ref.read(historyRepositoryProvider);
      final rawPoints = await repo.getHistory(deviceId, fromDate, toDate);
      state = AsyncValue.data(rawPoints);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final historyNotifierProvider = StateNotifierProvider<HistoryNotifier, AsyncValue<List<HistoryEntity>>>((ref) {
  return HistoryNotifier(ref);
});
