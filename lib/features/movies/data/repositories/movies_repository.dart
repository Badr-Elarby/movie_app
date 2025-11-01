import '../models/movies_response_model.dart';

abstract class MoviesRepository {
  Future<MoviesResponseModel> getMovies({required int page});
}


