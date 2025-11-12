import 'package:connectivity_plus/connectivity_plus.dart';
import '../datasources/movies_local_data_source.dart';
import '../datasources/movies_remote_data_source.dart';
import '../models/movies_response_model.dart';
import 'movies_repository.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  MoviesRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._connectivity,
  );

  final MoviesRemoteDataSource _remoteDataSource;
  final MoviesLocalDataSource _localDataSource;
  final Connectivity _connectivity;

  @override
  Future<MoviesResponseModel> getMovies({
    required int page,
    String? query,
  }) async {
    print('[Repository] Fetching movies for page $page');

    // Check network connectivity
    final List<ConnectivityResult> connectivityResults = await _connectivity
        .checkConnectivity();
    final bool isConnected = connectivityResults.any(
      (ConnectivityResult result) => result != ConnectivityResult.none,
    );

    print(
      '[Repository] Network status: ${isConnected ? "✅ ONLINE" : "❌ OFFLINE"}',
    );

    if (isConnected) {
      // Online: Fetch from API and cache
      try {
        print('[Repository] Fetching from API...');
        final MoviesResponseModel response = (query != null && query.isNotEmpty)
            ? await _remoteDataSource.searchMovies(page: page, query: query)
            : await _remoteDataSource.getPopularMovies(page: page);
        print(
          '[Repository] ✅ API response received: ${response.results.length} movies from page ${response.page}',
        );
        print('[Repository] Total pages available: ${response.total_pages}');

        // Cache the response only for popular/discover calls
        if (query == null || query.isEmpty) {
          await _localDataSource.cacheMovies(response);
          print('[Repository] ✅ Cached API response for offline access');
        }

        return response;
      } catch (e) {
        print(
          '[Repository] ⚠️ API error: $e - Attempting to load from cache...',
        );
        // If API fails, try to load from cache as fallback
        final MoviesResponseModel? cached = await _localDataSource
            .getCachedMovies(page: page);
        if (cached != null) {
          print('[Repository] ✅ Loaded from cache as fallback');
          return cached;
        }
        rethrow;
      }
    } else {
      // Offline: Load from cache
      print('[Repository] Offline mode - Loading from cache...');
      final MoviesResponseModel? cached = await _localDataSource
          .getCachedMovies(page: page);

      if (cached != null) {
        print('[Repository] ✅ Cache HIT - Returning cached data');
        print(
          '[Repository] Cached data: ${cached.results.length} movies from page ${cached.page}',
        );
        return cached;
      }

      print(
        '[Repository] ❌ Cache MISS - No cached data available for page $page',
      );
      throw Exception(
        'No internet connection and no cached data available for page $page',
      );
    }
  }
}
