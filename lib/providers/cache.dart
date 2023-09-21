import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class GiornalieraCacheManager {
  static const key = 'customCacheObject';
  static CacheManager instance =
      CacheManager(Config(key, stalePeriod: const Duration(hours: 1)));
}
