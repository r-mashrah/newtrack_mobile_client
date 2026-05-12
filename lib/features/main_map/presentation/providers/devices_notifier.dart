import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/device_entity.dart';
import '../../../../domain/usecases/device_usecases.dart';
import 'devices_state.dart';

class DevicesNotifier extends StateNotifier<DevicesState> {
  final GetDevicesUseCase _getDevicesUseCase;
  final SubscribeToLiveUpdatesUseCase _subscribeToLiveUpdatesUseCase;

  StreamSubscription<List<DeviceEntity>>? _liveUpdatesSubscription;
  Timer? _refreshTimer;

  DevicesNotifier({
    required GetDevicesUseCase getDevicesUseCase,
    required SubscribeToLiveUpdatesUseCase subscribeToLiveUpdatesUseCase,
  })  : _getDevicesUseCase = getDevicesUseCase,
        _subscribeToLiveUpdatesUseCase = subscribeToLiveUpdatesUseCase,
        super(const DevicesState.initial());

  /// تحميل الأجهزة
  Future<void> loadDevices() async {
    state = const DevicesState.loading();

    try {
      final devices = await _getDevicesUseCase();
      state = DevicesState.loaded(devices: devices);

      // بدء التحديثات المباشرة
      _startLiveUpdates();

      // بدء المؤقت للتحديث الدوري
      _startRefreshTimer();
    } catch (e) {
      state = DevicesState.error(message: e.toString());
    }
  }

  /// إعادة تحميل الأجهزة
  Future<void> refreshDevices() async {
    // استخدم map بدلاً من if للتحقق الآمن
    state = state.maybeMap(
      loaded: (loadedState) => loadedState.copyWith(isRefreshing: true),
      orElse: () => state,
    );

    try {
      final devices = await _getDevicesUseCase();
      state = DevicesState.loaded(devices: devices);
    } catch (e) {
      // استخدم maybeMap للحصول على الأجهزة السابقة
      final previousDevices = state.maybeMap(
        loaded: (loadedState) => loadedState.devices,
        error: (errorState) => errorState.previousDevices,
        orElse: () => null,
      );

      state = DevicesState.error(
        message: e.toString(),
        previousDevices: previousDevices,
      );
    }
  }

  /// البدء في التحديثات المباشرة
  void _startLiveUpdates() {
    _liveUpdatesSubscription?.cancel();

    try {
      _liveUpdatesSubscription = _subscribeToLiveUpdatesUseCase().listen(
        (devices) {
          state = DevicesState.loaded(devices: devices);
        },
        onError: (error) {
          // لا نغير الحالة الرئيسية في حالة خطأ التحديث المباشر
          // يمكن إضافة منطق للتعامل مع الأخطاء هنا
        },
      );
    } catch (e) {
      // فشل الاشتراك في التحديثات المباشرة
    }
  }

  /// بدء المؤقت للتحديث الدوري
  void _startRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (timer) {
        refreshDevices();
      },
    );
  }

  /// تصفية الأجهزة حسب الاستعلام
  void filterDevices(String query) {
    // استخدم maybeMap بدلاً من if
    state.maybeMap(
      loaded: (loadedState) {
        final filteredDevices = loadedState.devices.where((device) {
          return device.name.toLowerCase().contains(query.toLowerCase()) ||
                 (device.plateNumber?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
                 device.imei.toLowerCase().contains(query.toLowerCase());
        }).toList();

        state = loadedState.copyWith(
          devices: filteredDevices,
          filterQuery: query,
        );
      },
      orElse: () {
        // لا تفعل شيئاً إذا لم تكن الحالة loaded
      },
    );
  }

  /// تصفية الأجهزة حسب الحالة
  void filterByStatus(String? status) {
    state.maybeMap(
      loaded: (loadedState) {
        if (status == null) {
          loadDevices();
        } else {
          final filteredDevices = loadedState.devices.where((device) {
            return device.displayStatus == status;
          }).toList();

          state = loadedState.copyWith(
            devices: filteredDevices,
            statusFilter: status,
          );
        }
      },
      orElse: () {
        // لا تفعل شيئاً إذا لم تكن الحالة loaded
      },
    );
  }

  /// مسح الفلاتر
  void clearFilters() {
    // إذا كانت الحالة loaded، قم بإعادة التحميل
    state.maybeMap(
      loaded: (_) => loadDevices(),
      orElse: () {
        // لا تفعل شيئاً إذا لم تكن الحالة loaded
      },
    );
  }

  /// الحصول على إحصائيات الأجهزة
  Map<String, int> getStatistics() {
    return {
      'total': state.deviceCount,
      'online': state.onlineCount,
      'moving': state.movingCount,
      'stopped': state.stoppedCount,
      'offline': state.offlineCount,
    };
  }

  @override
  void dispose() {
    _liveUpdatesSubscription?.cancel();
    _refreshTimer?.cancel();
    super.dispose();
  }
}