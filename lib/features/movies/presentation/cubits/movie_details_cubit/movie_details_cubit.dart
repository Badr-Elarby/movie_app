import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/movie_details_repository.dart';
import 'movie_details_state.dart';
import '../../../data/models/video_model.dart';
import '../../../data/models/videos_response_model.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  MovieDetailsCubit(this._repository) : super(const MovieDetailsInitial());

  final MovieDetailsRepository _repository;

  Future<void> loadMovieDetails({required int movieId}) async {
    print('[Cubit] State: Loading movie details for ID: $movieId');
    // Prevent duplicate loading states
    if (state is MovieDetailsLoading) {
      return;
    }
    emit(const MovieDetailsLoading());
    try {
      final details = await _repository.getMovieDetails(movieId: movieId);
      // Fetch videos (trailers) for this movie
      String? trailerKey;
      List<VideoModel>? videos;
      try {
        final VideosResponseModel videosResponse = await _repository
            .getMovieVideos(movieId: movieId);
        videos = videosResponse.results;
        // Find first YouTube trailer (case-insensitive)
        final List<VideoModel> trailers = videos
            .where(
              (VideoModel v) =>
                  v.site.toLowerCase() == 'youtube' &&
                  v.type.toLowerCase() == 'trailer',
            )
            .toList();
        if (trailers.isNotEmpty && trailers.first.key.isNotEmpty) {
          trailerKey = trailers.first.key;
        }
      } catch (e) {
        // Non-fatal: log and continue without trailer
        print('[Cubit] Warning: Failed to load videos for movie $movieId: $e');
      }
      print('[Cubit] State: Success - Loaded movie: "${details.title}"');
      emit(
        MovieDetailsSuccess(details, trailerKey: trailerKey, videos: videos),
      );
    } catch (e) {
      print('[Cubit] State: Failure - Error loading movie details: $e');
      // Provide user-friendly error message
      final String errorMessage = e.toString().replaceAll('Exception: ', '');
      emit(
        MovieDetailsFailure(
          errorMessage.isEmpty ? 'Failed to load movie details' : errorMessage,
        ),
      );
    }
  }
}
