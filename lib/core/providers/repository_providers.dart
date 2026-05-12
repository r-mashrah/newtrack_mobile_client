import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/datasources/mock_auth_datasource.dart';
import 'caching_provider.dart';
// import '../services/caching_service.dart';
import '../../data/datasources/mock_device_datasource.dart';
import '../../data/datasources/mock_server_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/device_repository_impl.dart';
import '../../data/repositories/server_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/device_repository.dart';
import '../../domain/repositories/server_repository.dart';

// ==================== Data Source Providers ====================

final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final cachingService = ref.watch(cachingServiceProvider);
  const secureStorage = FlutterSecureStorage();
  return MockAuthDataSource(cachingService, secureStorage);
});

final deviceDataSourceProvider = Provider<DeviceDataSource>((ref) {
  return MockDeviceDataSource();
});

final serverDataSourceProvider = Provider<ServerDataSource>((ref) {
  return MockServerDataSource();
});

// ==================== Repository Providers ====================

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(authDataSourceProvider));
});

final deviceRepositoryProvider = Provider<DeviceRepository>((ref) {
  return DeviceRepositoryImpl(ref.read(deviceDataSourceProvider));
});

final serverRepositoryProvider = Provider<ServerRepository>((ref) {
  return ServerRepositoryImpl(ref.read(serverDataSourceProvider));
});
