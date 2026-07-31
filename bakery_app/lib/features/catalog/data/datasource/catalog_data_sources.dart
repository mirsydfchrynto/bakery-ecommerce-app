abstract class CatalogRemoteDataSource {
  Future<List<Map<String, dynamic>>> getActiveProducts();
}

abstract class CatalogLocalDataSource {
  Future<List<Map<String, dynamic>>> getCachedProducts();
  Future<void> cacheProducts(List<Map<String, dynamic>> products);
  Future<DateTime?> getLastSyncTime();
  Future<void> setLastSyncTime(DateTime time);
}
