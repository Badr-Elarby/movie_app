import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/movie_details_repository.dart';
import 'movie_details_state.dart';

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
      print('[Cubit] State: Success - Loaded movie: "${details.title}"');
      emit(MovieDetailsSuccess(details));
    } catch (e) {
      print('[Cubit] State: Failure - Error loading movie details: $e');
      // Provide user-friendly error message
      final String errorMessage = e.toString().replaceAll('Exception: ', '');
      emit(MovieDetailsFailure(errorMessage.isEmpty ? 'Failed to load movie details' : errorMessage));
    }
  }
}
