import '../models/movie_details_model.dart';
import '../models/videos_response_model.dart';

abstract class MovieDetailsRemoteDataSource {
  Future<MovieDetailsModel> getMovieDetails({required int movieId});
  Future<VideosResponseModel> getMovieVideos({required int movieId});
}
