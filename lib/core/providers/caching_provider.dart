import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/caching_service.dart';

final cachingServiceProvider = Provider<CachingService>((ref) {
  throw UnimplementedError('cachingServiceProvider must be overridden in ProviderScope');
});
