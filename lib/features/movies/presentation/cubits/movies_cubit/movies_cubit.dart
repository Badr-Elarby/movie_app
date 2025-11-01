import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/movies_repository.dart';
import '../../../data/models/movie_model.dart';
import 'movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  MoviesCubit(this._repository) : super(const MoviesInitial());

  final MoviesRepository _repository;

  Future<void> loadFirstPage() async {
    print('[Cubit] State: Loading first page');
    emit(const MoviesLoading());
    try {
      final response = await _repository.getMovies(page: 1);
      print(
        '[Cubit] State: Success - Loaded ${response.results.length} movies on page ${response.page}',
      );
      print('[Cubit] Total pages available: ${response.totalPages}');
      emit(
        MoviesSuccess(
          movies: response.results,
          page: response.page,
          totalPages: response.totalPages,
        ),
      );
    } catch (e) {
      print('[Cubit] State: Failure - Error loading first page: $e');
      emit(MoviesFailure(e.toString()));
    }
  }

  Future<void> loadNextPage() async {
    final current = state;
    if (current is! MoviesSuccess || !current.hasMore) {
      if (current is MoviesSuccess) {
        print(
          '[Cubit] Cannot load next page: reached last page (${current.page}/${current.totalPages})',
        );
      }
      return;
    }
    final nextPage = current.page + 1;
    print('[Cubit] State: Loading next page ($nextPage)');
    try {
      final response = await _repository.getMovies(page: nextPage);
      final int totalMovies = current.movies.length + response.results.length;
      print(
        '[Cubit] State: Success - Loaded page $nextPage, total movies now: $totalMovies',
      );
      emit(
        current.copyWith(
          movies: <MovieModel>[...current.movies, ...response.results],
          page: response.page,
        ),
      );
    } catch (e) {
      print('[Cubit] State: Failure - Error loading next page: $e');
      emit(MoviesFailure(e.toString()));
    }
  }
}
