import 'package:dio/dio.dart';
import '../../core/services/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/task_model.dart';

abstract class TasksDataSource {
  Future<List<TaskModel>> getTasks();
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
}

class RemoteTasksDataSource implements TasksDataSource {
  final ApiClient _apiClient;

  RemoteTasksDataSource(this._apiClient);

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      final response = await _apiClient.get(ApiConstants.getTasks);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        List<dynamic> items = [];
        
        if (data is Map) {
          // GPSWox يرجع { status: 1, items: { total, data: [...] } }
          if (data.containsKey('items')) {
            final itemsObj = data['items'];
            if (itemsObj is Map && itemsObj.containsKey('data')) {
              items = itemsObj['data'] as List<dynamic>;
            } else if (itemsObj is List) {
              items = itemsObj;
            }
          } else if (data.containsKey('data')) {
            final dataObj = data['data'];
            if (dataObj is List) items = dataObj;
          }
        } else if (data is List) {
          items = data;
        }

        return items.map((json) {
          return TaskModel.fromGpswoxJson(json as Map<String, dynamic>);
        }).toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<void> addTask(TaskModel task) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.addTask,
        data: task.toGpswoxJson(),
      );

      if (response.statusCode != 200 || response.data == null) {
        throw Exception('Failed to add task: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        throw Exception('خطأ في السيرفر: ${e.response?.data}');
      }
      throw Exception('Network error while adding task: ${e.message}');
    }
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    try {
      final body = task.toGpswoxJson();

      final response = await _apiClient.post(
        '${ApiConstants.editTaskBase}/${task.id}',
        data: body,
      );

      if (response.statusCode != 200 || response.data == null) {
        throw Exception('Failed to update task: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        throw Exception('خطأ في السيرفر: ${e.response?.data}');
      }
      throw Exception('Network error while updating task: ${e.message}');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.destroyTask,
        data: {'id': id},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete task: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error while deleting task: ${e.message}');
    }
  }
}
