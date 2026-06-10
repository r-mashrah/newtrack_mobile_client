import 'package:dio/dio.dart';
import '../../core/services/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/history_model.dart';
import '../../domain/entities/history_entity.dart';

abstract class HistoryDataSource {
  Future<List<HistoryEntity>> getHistory(
    String deviceId,
    String fromDate,
    String toDate,
  );
}

class RemoteHistoryDataSource implements HistoryDataSource {
  final ApiClient _apiClient;

  RemoteHistoryDataSource(this._apiClient);

  @override
  Future<List<HistoryEntity>> getHistory(
    String deviceId,
    String fromDate,
    String toDate,
  ) async {
    try {
      final fromParts = fromDate.split(' ');
      final toParts = toDate.split(' ');

      final response = await _apiClient.get(
        ApiConstants.getHistory,
        queryParameters: {
          'device_id': deviceId,
          'from_date': fromParts[0],
          'from_time': fromParts.length > 1 ? fromParts[1].substring(0, 5) : '00:00',
          'to_date': toParts[0],
          'to_time': toParts.length > 1 ? toParts[1].substring(0, 5) : '23:59',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        // دالة مساعدة للبحث المعمق عن النقاط التي تحتوي على إحداثيات داخل هيكل البيانات المعقد
        List<dynamic> extractPoints(dynamic currentData) {
          if (currentData is List) {
            if (currentData.isNotEmpty && currentData.first is Map && (currentData.first.containsKey('lat') || currentData.first.containsKey('latitude'))) {
              return currentData;
            } else {
              List<dynamic> result = [];
              for (var item in currentData) {
                result.addAll(extractPoints(item));
              }
              return result;
            }
          } else if (currentData is Map) {
            if (currentData.containsKey('lat') || currentData.containsKey('latitude')) {
               return [currentData];
            } else if (currentData.containsKey('items')) {
               return extractPoints(currentData['items']);
            } else if (currentData.containsKey('data')) {
               return extractPoints(currentData['data']);
            } else {
               List<dynamic> result = [];
               currentData.forEach((key, value) {
                 if (value is Map || value is List) {
                   result.addAll(extractPoints(value));
                 }
               });
               return result;
            }
          }
          return [];
        }

        final items = extractPoints(data);

        return items.map((json) {
          return HistoryModel.fromGpswoxJson(
            json as Map<String, dynamic>,
          ).toEntity();
        }).toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error: ${e.message}';
      if (e.response?.data != null && e.response?.data is Map) {
        final data = e.response!.data as Map;
        if (data.containsKey('message')) {
          errorMessage = data['message'].toString();
        }
        if (data.containsKey('errors') && data['errors'] is Map) {
          final errorsMap = data['errors'] as Map;
          final errorList = [];
          for (var key in errorsMap.keys) {
            final val = errorsMap[key];
            if (val is List) {
              errorList.add('$key: ${val.join(", ")}');
            } else {
              errorList.add('$key: $val');
            }
          }
          if (errorList.isNotEmpty) {
            errorMessage += '\n' + errorList.join('\n');
          }
        }
      }
      throw Exception(errorMessage);
    }
  }
}
