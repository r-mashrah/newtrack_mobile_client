import '../entities/history_entity.dart';

abstract class HistoryRepository {
  Future<List<HistoryEntity>> getHistory(String deviceId, String fromDate, String toDate);
}
