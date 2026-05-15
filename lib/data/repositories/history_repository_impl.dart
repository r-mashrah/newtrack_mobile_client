import '../../domain/entities/history_entity.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/remote_history_datasource.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryDataSource _dataSource;

  HistoryRepositoryImpl(this._dataSource);

  @override
  Future<List<HistoryEntity>> getHistory(String deviceId, String fromDate, String toDate) async {
    try {
      return await _dataSource.getHistory(deviceId, fromDate, toDate);
    } catch (e) {
      throw Exception('Failed to get history: ${e.toString()}');
    }
  }
}
