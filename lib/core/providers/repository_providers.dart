import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/datasources/mock_auth_datasource.dart'; // For AuthDataSource interface
import '../../data/datasources/remote_auth_datasource.dart';
import 'caching_provider.dart';
import 'api_client_provider.dart';
import '../../data/datasources/mock_device_datasource.dart'; // For DeviceDataSource interface
import '../../data/datasources/remote_device_datasource.dart';
import '../../data/datasources/mock_server_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/device_repository_impl.dart';
import '../../data/repositories/server_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/device_repository.dart';
import '../../domain/repositories/server_repository.dart';
import '../../data/datasources/remote_history_datasource.dart';
import '../../data/repositories/history_repository_impl.dart';
import '../../domain/repositories/history_repository.dart';
import '../../data/datasources/remote_alerts_datasource.dart';
import '../../data/repositories/alerts_repository_impl.dart';
import '../../domain/repositories/alerts_repository.dart';
import '../../data/datasources/remote_geofences_datasource.dart';
import '../../data/repositories/geofences_repository_impl.dart';
import '../../domain/repositories/geofences_repository.dart';

// ==================== Data Source Providers ====================

final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final cachingService = ref.watch(cachingServiceProvider);
  final apiClient = ref.watch(apiClientProvider);
  const secureStorage = FlutterSecureStorage();
  return RemoteAuthDataSource(apiClient, cachingService, secureStorage);
});

final deviceDataSourceProvider = Provider<DeviceDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RemoteDeviceDataSource(apiClient);
});

final serverDataSourceProvider = Provider<ServerDataSource>((ref) {
  return MockServerDataSource();
});

final historyDataSourceProvider = Provider<HistoryDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RemoteHistoryDataSource(apiClient);
});

final alertsDataSourceProvider = Provider<AlertsDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RemoteAlertsDataSource(apiClient);
});

final geofencesDataSourceProvider = Provider<GeofencesDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RemoteGeofencesDataSource(apiClient);
});

// ==================== Repository Providers ====================

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(authDataSourceProvider));
});

final deviceRepositoryProvider = Provider<DeviceRepository>((ref) {
  return DeviceRepositoryImpl(ref.read(deviceDataSourceProvider));
});

final serverRepositoryProvider = Provider<ServerRepository>((ref) {
  final dataSource = ref.watch(serverDataSourceProvider);
  return ServerRepositoryImpl(dataSource);
});

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  final dataSource = ref.watch(historyDataSourceProvider);
  return HistoryRepositoryImpl(dataSource);
});

final alertsRepositoryProvider = Provider<AlertsRepository>((ref) {
  final dataSource = ref.watch(alertsDataSourceProvider);
  return AlertsRepositoryImpl(dataSource);
});

final geofencesRepositoryProvider = Provider<GeofencesRepository>((ref) {
  final dataSource = ref.watch(geofencesDataSourceProvider);
  return GeofencesRepositoryImpl(dataSource);
});
