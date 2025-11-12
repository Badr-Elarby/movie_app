import '../datasources/movie_details_remote_data_source.dart';
import '../models/movie_details_model.dart';
import 'movie_details_repository.dart';

class MovieDetailsRepositoryImpl implements MovieDetailsRepository {
  MovieDetailsRepositoryImpl(this._remoteDataSource);

  final MovieDetailsRemoteDataSource _remoteDataSource;

  @override
  Future<MovieDetailsModel> getMovieDetails({required int movieId}) async {
    print('[Repository] Fetching movie details for movie ID: $movieId');
    try {
      final MovieDetailsModel details =
          await _remoteDataSource.getMovieDetails(movieId: movieId);
      print('[Repository] Successfully parsed movie: "${details.title}"');
      print('[Repository] Genres: ${details.genres?.length ?? 0}');
      return details;
    } catch (e) {
      print('[Repository] Error fetching movie details: $e');
      // Re-throw with more context for better error handling
      throw Exception(
        'Failed to load movie details: ${e.toString()}',
      );
    }
  }
}
