import 'dart:async';
import '../../domain/entities/server_entity.dart';

abstract class ServerDataSource {
  Future<List<ServerEntity>> getServers();
  Future<ServerEntity> getDefaultServer();
  Future<void> setDefaultServer(String serverId);
  Future<void> addServer(ServerEntity server);
  Future<void> updateServer(ServerEntity server);
  Future<void> deleteServer(String id);
}

class MockServerDataSource implements ServerDataSource {
  final List<ServerEntity> _mockServers = [
    ServerEntity(
      id: 'server_1',
      name: 'Production',
      url: 'https://api.newtrack.com',
      apiUrl: 'https://api.newtrack.com/api',
      description: 'الخادم الرئيسي للإنتاج',
      isActive: true,
      isDefault: true,
      config: {
        'timeout': 30000,
        'retryCount': 3,
      },
    ),
    ServerEntity(
      id: 'server_2',
      name: 'Demo',
      url: 'https://demo.newtrack.com',
      apiUrl: 'https://demo.newtrack.com/api',
      description: 'خادم العرض التوضيحي',
      isActive: true,
      isDefault: false,
      config: {
        'timeout': 15000,
        'retryCount': 2,
      },
    ),
    ServerEntity(
      id: 'server_3',
      name: 'Development',
      url: 'https://dev.newtrack.com',
      apiUrl: 'https://dev.newtrack.com/api',
      description: 'خادم التطوير',
      isActive: true,
      isDefault: false,
      config: {
        'timeout': 10000,
        'retryCount': 1,
      },
    ),
  ];

  @override
  Future<List<ServerEntity>> getServers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockServers);
  }

  @override
  Future<ServerEntity> getDefaultServer() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final defaultServer = _mockServers.firstWhere(
      (server) => server.isDefault,
      orElse: () => _mockServers.first,
    );
    return defaultServer;
  }

  @override
  Future<void> setDefaultServer(String serverId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    for (var server in _mockServers) {
      server = server.copyWith(isDefault: server.id == serverId);
    }
  }

  @override
  Future<void> addServer(ServerEntity server) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockServers.add(server);
  }

  @override
  Future<void> updateServer(ServerEntity server) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockServers.indexWhere((s) => s.id == server.id);
    if (index != -1) {
      _mockServers[index] = server;
    }
  }

  @override
  Future<void> deleteServer(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _mockServers.removeWhere((server) => server.id == id);
  }
}
