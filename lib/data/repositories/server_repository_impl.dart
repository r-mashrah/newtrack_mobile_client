import '../../domain/entities/server_entity.dart';
import '../../domain/repositories/server_repository.dart';
import '../datasources/mock_server_datasource.dart';

class ServerRepositoryImpl implements ServerRepository {
  final ServerDataSource _dataSource;

  ServerRepositoryImpl(this._dataSource);

  @override
  Future<List<ServerEntity>> getServers() async {
    try {
      return await _dataSource.getServers();
    } catch (e) {
      throw Exception('Failed to get servers: ${e.toString()}');
    }
  }

  @override
  Future<ServerEntity> getDefaultServer() async {
    try {
      return await _dataSource.getDefaultServer();
    } catch (e) {
      throw Exception('Failed to get default server: ${e.toString()}');
    }
  }

  @override
  Future<void> setDefaultServer(String serverId) async {
    try {
      await _dataSource.setDefaultServer(serverId);
    } catch (e) {
      throw Exception('Failed to set default server: ${e.toString()}');
    }
  }

  @override
  Future<void> addServer(ServerEntity server) async {
    try {
      await _dataSource.addServer(server);
    } catch (e) {
      throw Exception('Failed to add server: ${e.toString()}');
    }
  }

  @override
  Future<void> updateServer(ServerEntity server) async {
    try {
      await _dataSource.updateServer(server);
    } catch (e) {
      throw Exception('Failed to update server: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteServer(String id) async {
    try {
      await _dataSource.deleteServer(id);
    } catch (e) {
      throw Exception('Failed to delete server: ${e.toString()}');
    }
  }
}
