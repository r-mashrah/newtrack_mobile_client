import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/task_model.dart';
import 'package:uuid/uuid.dart';

class TasksNotifier extends StateNotifier<List<TaskModel>> {
  TasksNotifier() : super(_mockTasks);

  static final List<TaskModel> _mockTasks = [
    TaskModel(
      id: '1',
      title: 'توصيل شحنة أدوية',
      deviceId: 'dev1',
      deviceName: 'Toyota Camry',
      invoiceNumber: 'INV-001',
      address: 'صنعاء، شارع الستين',
      priority: 'High',
      pickupAddress: 'مستودع الأدوية المركزي',
      pickupLat: 15.3694,
      pickupLng: 44.1910,
      pickupFromDate: DateTime.now(),
      pickupToDate: DateTime.now().add(const Duration(hours: 2)),
      deliveryAddress: 'صيدلية الأمل',
      deliveryLat: 15.3500,
      deliveryLng: 44.2000,
      deliveryFromDate: DateTime.now().add(const Duration(hours: 3)),
      deliveryToDate: DateTime.now().add(const Duration(hours: 5)),
    ),
  ];

  void addTask(TaskModel task) {
    state = [...state, task.copyWith(id: const Uuid().v4())];
  }

  void updateTask(TaskModel updatedTask) {
    state = [
      for (final task in state)
        if (task.id == updatedTask.id) updatedTask else task
    ];
  }

  void deleteTask(String id) {
    state = state.where((task) => task.id != id).toList();
  }
}

final tasksProvider = StateNotifierProvider<TasksNotifier, List<TaskModel>>((ref) {
  return TasksNotifier();
});

final taskSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredTasksProvider = Provider<List<TaskModel>>((ref) {
  final tasks = ref.watch(tasksProvider);
  final query = ref.watch(taskSearchQueryProvider).toLowerCase();

  if (query.isEmpty) return tasks;

  return tasks.where((task) {
    return task.invoiceNumber.toLowerCase().contains(query) ||
           task.address.toLowerCase().contains(query) ||
           task.title.toLowerCase().contains(query);
  }).toList();
});
