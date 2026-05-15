import '../../domain/entities/alert_entity.dart';
import '../../domain/repositories/alerts_repository.dart';
import '../datasources/remote_alerts_datasource.dart';

class AlertsRepositoryImpl implements AlertsRepository {
  final AlertsDataSource _dataSource;

  AlertsRepositoryImpl(this._dataSource);

  @override
  Future<List<AlertEntity>> getAlerts() async {
    return await _dataSource.getAlerts();
  }

  @override
  Future<void> addAlert(AlertEntity alert) async {
    return await _dataSource.addAlert(alert);
  }

  @override
  Future<void> updateAlert(AlertEntity alert) async {
    return await _dataSource.updateAlert(alert);
  }

  @override
  Future<void> deleteAlert(String id) async {
    return await _dataSource.deleteAlert(id);
  }

  @override
  Future<void> toggleAlertStatus(String id, bool isActive) async {
    return await _dataSource.toggleAlertStatus(id, isActive);
  }
}
