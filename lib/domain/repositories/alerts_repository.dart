import '../../domain/entities/alert_entity.dart';

abstract class AlertsRepository {
  Future<List<AlertEntity>> getAlerts();
  Future<void> addAlert(AlertEntity alert);
  Future<void> updateAlert(AlertEntity alert);
  Future<void> deleteAlert(String id);
  Future<void> toggleAlertStatus(String id, bool isActive);
}
