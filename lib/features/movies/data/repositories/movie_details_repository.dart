import '../models/movie_details_model.dart';

abstract class MovieDetailsRepository {
  Future<MovieDetailsModel> getMovieDetails({required int movieId});
}
