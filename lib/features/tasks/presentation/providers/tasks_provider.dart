import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/task_model.dart';

import '../../../../core/providers/repository_providers.dart';

class TasksNotifier extends StateNotifier<AsyncValue<List<TaskModel>>> {
  final Ref _ref;

  TasksNotifier(this._ref) : super(const AsyncValue.loading()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    state = const AsyncValue.loading();
    try {
      final dataSource = _ref.read(tasksDataSourceProvider);
      final tasks = await dataSource.getTasks();
      state = AsyncValue.data(tasks);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addTask(TaskModel task) async {
    try {
      final dataSource = _ref.read(tasksDataSourceProvider);
      await dataSource.addTask(task);
      // إعادة تحميل القائمة من السيرفر لضمان التزامن
      await loadTasks();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> updateTask(TaskModel updatedTask) async {
    try {
      final dataSource = _ref.read(tasksDataSourceProvider);
      await dataSource.updateTask(updatedTask);
      // إعادة تحميل القائمة من السيرفر لضمان التزامن
      await loadTasks();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> deleteTask(String id) async {
    // حفظ الحالة السابقة
    final previousState = state;
    
    // حذف محلي فوري
    state.whenData((tasks) {
      state = AsyncValue.data(
        tasks.where((task) => task.id != id).toList(),
      );
    });

    // إرسال الحذف للسيرفر
    try {
      final dataSource = _ref.read(tasksDataSourceProvider);
      await dataSource.deleteTask(id);
    } catch (e) {
      // إعادة الحالة السابقة في حالة الخطأ
      state = previousState;
      rethrow;
    }
  }
}

final tasksProvider = StateNotifierProvider<TasksNotifier, AsyncValue<List<TaskModel>>>((ref) {
  return TasksNotifier(ref);
});

final taskSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredTasksProvider = Provider<AsyncValue<List<TaskModel>>>((ref) {
  final tasksAsync = ref.watch(tasksProvider);
  final query = ref.watch(taskSearchQueryProvider).toLowerCase();

  return tasksAsync.whenData((tasks) {
    if (query.isEmpty) return tasks;
    return tasks.where((task) {
      return task.invoiceNumber.toLowerCase().contains(query) ||
             task.address.toLowerCase().contains(query) ||
             task.title.toLowerCase().contains(query);
    }).toList();
  });
});
