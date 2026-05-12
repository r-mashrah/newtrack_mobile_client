import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../domain/entities/device_entity.dart';

part 'devices_state.freezed.dart';

@freezed
class DevicesState with _$DevicesState {
  /// الحالة الأولية
  const factory DevicesState.initial() = _Initial;

  /// حالة التحميل
  const factory DevicesState.loading() = _Loading;

  /// حالة البيانات المحملة
  const factory DevicesState.loaded({
    required List<DeviceEntity> devices,
    @Default(false) bool isRefreshing,
    String? filterQuery,
    String? statusFilter,
  }) = _Loaded;

  /// حالة الخطأ
  const factory DevicesState.error({
    required String message,
    List<DeviceEntity>? previousDevices,
  }) = _Error;

  const DevicesState._();

  /// الحصول على الأجهزة
  List<DeviceEntity>? get devices => when(
    initial: () => null,
    loading: () => null,
    loaded: (devices, isRefreshing, filterQuery, statusFilter) => devices,
    error: (message, previousDevices) => previousDevices,
  );

  /// عدد الأجهزة
  int get deviceCount => devices?.length ?? 0;

  /// عدد الأجهزة المتصلة
  int get onlineCount => devices?.where((d) => d.isOnline).length ?? 0;

  /// عدد الأجهزة المتحركة
  int get movingCount => devices?.where((d) => d.displayStatus == 'moving').length ?? 0;

  /// عدد الأجهزة المتوقفة
  int get stoppedCount => devices?.where((d) => d.displayStatus == 'stopped').length ?? 0;

  /// عدد الأجهزة غير المتصلة
  int get offlineCount => devices?.where((d) => !d.isOnline).length ?? 0;
}
