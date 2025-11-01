import 'package:hive_flutter/hive_flutter.dart';
import '../models/movies_response_model.dart';

abstract class MoviesLocalDataSource {
  Future<MoviesResponseModel?> getCachedMovies({required int page});
  Future<void> cacheMovies(MoviesResponseModel response);
  Future<void> clearCache();
}

class MoviesLocalDataSourceImpl implements MoviesLocalDataSource {
  MoviesLocalDataSourceImpl(this._box);

  final Box<MoviesResponseModel> _box;
  static const String _pageKeyPrefix = 'movies_page_';

  @override
  Future<MoviesResponseModel?> getCachedMovies({required int page}) async {
    final String key = '$_pageKeyPrefix$page';
    print('[LocalDataSource] Checking cache for page $page (key: $key)');

    final MoviesResponseModel? cached = _box.get(key);
    if (cached != null) {
      print('[LocalDataSource] ✅ Cache HIT for page $page - Found ${cached.results.length} movies');
      return cached;
    }

    print('[LocalDataSource] ❌ Cache MISS for page $page');
    return null;
  }

  @override
  Future<void> cacheMovies(MoviesResponseModel response) async {
    final String key = '$_pageKeyPrefix${response.page}';
    print('[LocalDataSource] Caching page ${response.page} with ${response.results.length} movies');

    await _box.put(key, response);
    print('[LocalDataSource] ✅ Successfully cached page ${response.page}');
  }

  @override
  Future<void> clearCache() async {
    print('[LocalDataSource] Clearing all cached movies');
    await _box.clear();
    print('[LocalDataSource] ✅ Cache cleared');
  }
}
