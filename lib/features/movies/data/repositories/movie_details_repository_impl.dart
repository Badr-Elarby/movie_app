import '../datasources/movie_details_remote_data_source.dart';
import '../models/movie_details_model.dart';
import '../models/videos_response_model.dart';
import '../models/credits_response_model.dart';
import 'movie_details_repository.dart';

class MovieDetailsRepositoryImpl implements MovieDetailsRepository {
  MovieDetailsRepositoryImpl(this._remoteDataSource);

  final MovieDetailsRemoteDataSource _remoteDataSource;

  @override
  Future<MovieDetailsModel> getMovieDetails({required int movieId}) async {
    print('[Repository] Fetching movie details for movie ID: $movieId');
    try {
      final MovieDetailsModel details = await _remoteDataSource.getMovieDetails(
        movieId: movieId,
      );
      print('[Repository] Successfully parsed movie: "${details.title}"');
      print('[Repository] Genres: ${details.genres?.length ?? 0}');
      return details;
    } catch (e) {
      print('[Repository] Error fetching movie details: $e');
      // Re-throw with more context for better error handling
      throw Exception('Failed to load movie details: ${e.toString()}');
    }
  }

  @override
  Future<VideosResponseModel> getMovieVideos({required int movieId}) async {
    print('[Repository] Fetching movie videos for movie ID: $movieId');
    try {
      final VideosResponseModel videos = await _remoteDataSource.getMovieVideos(
        movieId: movieId,
      );
      print('[Repository] Successfully parsed ${videos.results.length} videos');
      return videos;
    } catch (e) {
      print('[Repository] Error fetching movie videos: $e');
      throw Exception('Failed to load movie videos: ${e.toString()}');
    }
  }

  @override
  Future<CreditsResponseModel> getMovieCredits({required int movieId}) async {
    print('[Repository] Fetching movie credits for movie ID: $movieId');
    try {
      final CreditsResponseModel credits = await _remoteDataSource
          .getMovieCredits(movieId: movieId);
      print(
        '[Repository] Successfully parsed ${credits.cast.length} cast members',
      );
      return credits;
    } catch (e) {
      print('[Repository] Error fetching movie credits: $e');
      throw Exception('Failed to load movie credits: ${e.toString()}');
    }
  }
}
