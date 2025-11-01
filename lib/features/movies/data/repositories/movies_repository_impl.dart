import '../datasources/movies_remote_data_source.dart';
import '../models/movies_response_model.dart';
import 'movies_repository.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  MoviesRepositoryImpl(this._remoteDataSource);

  final MoviesRemoteDataSource _remoteDataSource;

  @override
  Future<MoviesResponseModel> getMovies({required int page}) async {
    print('[Repository] Fetching movies for page $page');
    final MoviesResponseModel response = await _remoteDataSource
        .getPopularMovies(page: page);
    print(
      '[Repository] Data received: ${response.results.length} movies parsed from page ${response.page}',
    );
    print('[Repository] Total pages available: ${response.total_pages}');
    return response;
  }
}
