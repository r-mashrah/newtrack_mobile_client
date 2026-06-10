import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/alert_model.dart';
import '../../../../core/providers/repository_providers.dart';

enum AlertFilter { all, active, disabled }

class AlertsNotifier extends StateNotifier<AsyncValue<List<AlertModel>>> {
  final AlertsDataSourceRef _ref;
  
  AlertsNotifier(this._ref) : super(const AsyncValue.loading()) {
    loadAlerts();
  }

  Future<void> loadAlerts() async {
    state = const AsyncValue.loading();
    try {
      final repository = _ref.read(alertsRepositoryProvider);
      final alertEntities = await repository.getAlerts();
      final alertModels = alertEntities
          .map((e) => AlertModel.fromEntity(e))
          .toList();
      state = AsyncValue.data(alertModels);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleAlertStatus(String id) async {
    // تحديث الحالة محلياً أولاً للاستجابة السريعة
    bool newStatus = false;
    state.whenData((alerts) {
      final alert = alerts.firstWhere((a) => a.id == id);
      newStatus = !alert.isActive;
      final updated = [
        for (final alert in alerts)
          if (alert.id == id) alert.copyWith(isActive: newStatus) else alert
      ];
      state = AsyncValue.data(updated);
    });

    // ثم إرسال التحديث للسيرفر
    try {
      final repository = _ref.read(alertsRepositoryProvider);
      await repository.toggleAlertStatus(id, newStatus);
    } catch (e) {
      // إعادة تحميل البيانات من السيرفر في حالة الخطأ
      await loadAlerts();
    }
  }

  Future<void> deleteAlert(String id) async {
    // حفظ الحالة السابقة
    final previousState = state;
    
    // حذف محلي فوري
    state.whenData((alerts) {
      state = AsyncValue.data(
        alerts.where((alert) => alert.id != id).toList(),
      );
    });

    // إرسال الحذف للسيرفر
    try {
      final repository = _ref.read(alertsRepositoryProvider);
      await repository.deleteAlert(id);
    } catch (e) {
      // إعادة الحالة السابقة في حالة الخطأ
      state = previousState;
      rethrow;
    }
  }

  Future<void> addAlert(AlertModel alert) async {
    try {
      final repository = _ref.read(alertsRepositoryProvider);
      await repository.addAlert(alert.toEntity());
      // إعادة تحميل القائمة من السيرفر لضمان التزامن
      await loadAlerts();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> updateAlert(AlertModel updatedAlert) async {
    try {
      final repository = _ref.read(alertsRepositoryProvider);
      await repository.updateAlert(updatedAlert.toEntity());
      // إعادة تحميل القائمة من السيرفر لضمان التزامن
      await loadAlerts();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

typedef AlertsDataSourceRef = Ref;

final alertsProvider = StateNotifierProvider<AlertsNotifier, AsyncValue<List<AlertModel>>>((ref) {
  return AlertsNotifier(ref);
});

final alertFilterProvider = StateProvider<AlertFilter>((ref) => AlertFilter.all);

final filteredAlertsProvider = Provider<AsyncValue<List<AlertModel>>>((ref) {
  final alertsAsync = ref.watch(alertsProvider);
  final filter = ref.watch(alertFilterProvider);

  return alertsAsync.whenData((alerts) {
    switch (filter) {
      case AlertFilter.all:
        return alerts;
      case AlertFilter.active:
        return alerts.where((a) => a.isActive).toList();
      case AlertFilter.disabled:
        return alerts.where((a) => !a.isActive).toList();
    }
  });
});
