import 'package:dio/dio.dart';
import '../../core/services/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/history_model.dart';
import '../../domain/entities/history_entity.dart';

abstract class HistoryDataSource {
  Future<List<HistoryEntity>> getHistory(String deviceId, String fromDate, String toDate);
}

class RemoteHistoryDataSource implements HistoryDataSource {
  final ApiClient _apiClient;

  RemoteHistoryDataSource(this._apiClient);

  @override
  Future<List<HistoryEntity>> getHistory(String deviceId, String fromDate, String toDate) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.getHistory,
        queryParameters: {
          'device_id': deviceId,
          'from_date': fromDate,
          'to_date': toDate,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        List<dynamic> items = [];
        
        if (data is List) {
          items = data;
        } else if (data is Map && data.containsKey('items')) {
          items = data['items'];
        } else if (data is Map && data.containsKey('data')) {
          if (data['data'] is Map && data['data'].containsKey('items')) {
            items = data['data']['items'];
          } else if (data['data'] is List) {
            items = data['data'];
          }
        }

        return items.map((json) {
          return HistoryModel.fromGpswoxJson(json as Map<String, dynamic>).toEntity();
        }).toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
