import '../entities/history_entity.dart';
import '../repositories/history_repository.dart';

class GetHistoryUseCase {
  final HistoryRepository repository;

  GetHistoryUseCase(this.repository);

  Future<List<HistoryEntity>> call(String deviceId, String fromDate, String toDate) async {
    return repository.getHistory(deviceId, fromDate, toDate);
  }
}
