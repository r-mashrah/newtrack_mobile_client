import '../entities/alert_entity.dart';
import '../repositories/alerts_repository.dart';

class GetAlertsUseCase {
  final AlertsRepository repository;
  GetAlertsUseCase(this.repository);

  Future<List<AlertEntity>> call() async {
    return repository.getAlerts();
  }
}

class AddAlertUseCase {
  final AlertsRepository repository;
  AddAlertUseCase(this.repository);

  Future<void> call(AlertEntity alert) async {
    return repository.addAlert(alert);
  }
}

class UpdateAlertUseCase {
  final AlertsRepository repository;
  UpdateAlertUseCase(this.repository);

  Future<void> call(AlertEntity alert) async {
    return repository.updateAlert(alert);
  }
}

class DeleteAlertUseCase {
  final AlertsRepository repository;
  DeleteAlertUseCase(this.repository);

  Future<void> call(String id) async {
    return repository.deleteAlert(id);
  }
}

class ToggleAlertStatusUseCase {
  final AlertsRepository repository;
  ToggleAlertStatusUseCase(this.repository);

  Future<void> call(String id, bool isActive) async {
    return repository.toggleAlertStatus(id, isActive);
  }
}
