import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/alert_model.dart';
import 'package:uuid/uuid.dart';

enum AlertFilter { all, active, disabled }

class AlertsNotifier extends StateNotifier<List<AlertModel>> {
  AlertsNotifier() : super(_mockAlerts);

  static final List<AlertModel> _mockAlerts = [
    AlertModel(
      id: '1',
      name: 'تنبيه السرعة',
      deviceId: 'dev1',
      deviceName: 'Toyota Camry',
      type: 'Over Speed',
      notificationType: 'Push Notification',
      isActive: true,
    ),
    AlertModel(
      id: '2',
      name: 'تنبيه المنطقة المحظورة',
      deviceId: 'dev2',
      deviceName: 'Mercedes Actros',
      type: 'Geofence',
      insideGeofence: true,
      notificationType: 'SMS',
      isActive: false,
    ),
  ];

  void addAlert(AlertModel alert) {
    state = [...state, alert.copyWith(id: const Uuid().v4())];
  }

  void updateAlert(AlertModel updatedAlert) {
    state = [
      for (final alert in state)
        if (alert.id == updatedAlert.id) updatedAlert else alert
    ];
  }

  void deleteAlert(String id) {
    state = state.where((alert) => alert.id != id).toList();
  }

  void toggleAlertStatus(String id) {
    state = [
      for (final alert in state)
        if (alert.id == id) alert.copyWith(isActive: !alert.isActive) else alert
    ];
  }
}

final alertsProvider = StateNotifierProvider<AlertsNotifier, List<AlertModel>>((ref) {
  return AlertsNotifier();
});

final alertFilterProvider = StateProvider<AlertFilter>((ref) => AlertFilter.all);

final filteredAlertsProvider = Provider<List<AlertModel>>((ref) {
  final alerts = ref.watch(alertsProvider);
  final filter = ref.watch(alertFilterProvider);

  switch (filter) {
    case AlertFilter.all:
      return alerts;
    case AlertFilter.active:
      return alerts.where((a) => a.isActive).toList();
    case AlertFilter.disabled:
      return alerts.where((a) => !a.isActive).toList();
  }
});
