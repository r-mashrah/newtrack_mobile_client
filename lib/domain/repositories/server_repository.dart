import '../entities/server_entity.dart';

abstract class ServerRepository {
  Future<List<ServerEntity>> getServers();

  Future<ServerEntity> getDefaultServer();

  Future<void> setDefaultServer(String serverId);

  Future<void> addServer(ServerEntity server);

  Future<void> updateServer(ServerEntity server);

  Future<void> deleteServer(String id);
}
