import '../models/movies_response_model.dart';

abstract class MoviesRemoteDataSource {
  Future<MoviesResponseModel> getPopularMovies({required int page});
  Future<MoviesResponseModel> searchMovies({
    required int page,
    required String query,
  });
}
