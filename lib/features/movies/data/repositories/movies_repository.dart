import '../models/movies_response_model.dart';

abstract class MoviesRepository {
  /// If [query] is provided, searches movies by query, otherwise returns popular movies
  Future<MoviesResponseModel> getMovies({required int page, String? query});
}
