import 'dart:async';

class LazyLoadingService {
  static final Map<String, dynamic> _cache = {};
  static final Map<String, bool> _loadingStates = {};
  static final Map<String, Timer> _debounceTimers = {};

  // Cache data with a key
  static void cacheData(String key, dynamic data) {
    _cache[key] = data;
  }

  // Get cached data
  static dynamic getCachedData(String key) {
    return _cache[key];
  }

  // Check if data is cached
  static bool isDataCached(String key) {
    return _cache.containsKey(key);
  }

  // Set loading state
  static void setLoading(String key, bool isLoading) {
    _loadingStates[key] = isLoading;
  }

  // Get loading state
  static bool isLoading(String key) {
    return _loadingStates[key] ?? false;
  }

  // Clear cache for a specific key
  static void clearCache(String key) {
    _cache.remove(key);
    _loadingStates.remove(key);
  }

  // Clear all cache
  static void clearAllCache() {
    _cache.clear();
    _loadingStates.clear();
  }

  // Debounced data loading
  static void debounceLoad(String key, Future<void> Function() loadFunction, {Duration delay = const Duration(milliseconds: 300)}) {
    _debounceTimers[key]?.cancel();
    _debounceTimers[key] = Timer(delay, () {
      loadFunction();
      _debounceTimers.remove(key);
    });
  }

  // Cancel debounced loading
  static void cancelDebounce(String key) {
    _debounceTimers[key]?.cancel();
    _debounceTimers.remove(key);
  }

  // Preload data in background
  static Future<void> preloadData(String key, Future<dynamic> Function() dataLoader) async {
    if (!isDataCached(key) && !isLoading(key)) {
      setLoading(key, true);
      try {
        final data = await dataLoader();
        cacheData(key, data);
      } catch (e) {
        print('Error preloading data for $key: $e');
      } finally {
        setLoading(key, false);
      }
    }
  }

  // Load data with cache check
  static Future<dynamic> loadDataWithCache(String key, Future<dynamic> Function() dataLoader) async {
    if (isDataCached(key)) {
      return getCachedData(key);
    }

    if (isLoading(key)) {
      // Wait for current loading to complete
      while (isLoading(key)) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      return getCachedData(key);
    }

    setLoading(key, true);
    try {
      final data = await dataLoader();
      cacheData(key, data);
      return data;
    } catch (e) {
      print('Error loading data for $key: $e');
      rethrow;
    } finally {
      setLoading(key, false);
    }
  }

  // Refresh data (clear cache and reload)
  static Future<dynamic> refreshData(String key, Future<dynamic> Function() dataLoader) async {
    clearCache(key);
    return await loadDataWithCache(key, dataLoader);
  }

  // Batch load multiple data sources
  static Future<Map<String, dynamic>> batchLoadData(Map<String, Future<dynamic> Function()> dataLoaders) async {
    final results = <String, dynamic>{};
    final futures = <Future<void>>[];

    for (final entry in dataLoaders.entries) {
      futures.add(
        loadDataWithCache(entry.key, entry.value).then((data) {
          results[entry.key] = data;
        }),
      );
    }

    await Future.wait(futures);
    return results;
  }
} 