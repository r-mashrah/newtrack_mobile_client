import 'dart:async';
import '../../core/services/caching_service.dart';
import '../../core/constants/api_constants.dart';
import '../../domain/entities/server_entity.dart';
import 'server_datasource.dart'; // For ServerDataSource interface

class RemoteServerDataSource implements ServerDataSource {
  final CachingService _cachingService;

  static const String _defaultServerIdKey = 'default_server_id';

  // For now, we define the main server from ApiConstants as the default.
  // In a full multi-server app, this would be fetched from a master API or DB.
  final List<ServerEntity> _servers = [
    ServerEntity(
      id: 'server_main',
      name: 'Main Tracking Server',
      url: ApiConstants.baseUrl,
      apiUrl: ApiConstants.apiBase,
      description: 'الخادم الرئيسي',
      isActive: true,
      isDefault: true,
      config: {'timeout': ApiConstants.connectTimeout, 'retryCount': 3},
    ),
  ];

  RemoteServerDataSource(this._cachingService);

  @override
  Future<List<ServerEntity>> getServers() async {
    return _servers;
  }

  @override
  Future<ServerEntity> getDefaultServer() async {
    // Try to get saved default server id
    // (If not found, returns the main server)
    final savedId = _cachingService.getString(_defaultServerIdKey);
    if (savedId != null) {
      try {
        return _servers.firstWhere((s) => s.id == savedId);
      } catch (_) {}
    }
    return _servers.first;
  }

  @override
  Future<void> setDefaultServer(String serverId) async {
    await _cachingService.setString(_defaultServerIdKey, serverId);
  }

  @override
  Future<void> addServer(ServerEntity server) async {
    // Not supported in this simplified version
    throw UnimplementedError('إضافة خادم غير مدعومة حالياً');
  }

  @override
  Future<void> updateServer(ServerEntity server) async {
    throw UnimplementedError('تعديل خادم غير مدعومة حالياً');
  }

  @override
  Future<void> deleteServer(String id) async {
    throw UnimplementedError('حذف خادم غير مدعومة حالياً');
  }
}
