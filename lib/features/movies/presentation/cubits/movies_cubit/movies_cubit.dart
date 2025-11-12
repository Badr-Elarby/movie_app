import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/movies_repository.dart';
import '../../../data/models/movie_model.dart';
import 'movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  MoviesCubit(this._repository) : super(const MoviesInitial());

  final MoviesRepository _repository;

  String? _currentQuery;

  /// Loads the first page. If [query] is provided performs a search.
  Future<void> loadFirstPage({String? query}) async {
    print('[Cubit] State: Loading first page (query: ${query ?? "(none)"})');
    // Prevent duplicate loading states
    if (state is MoviesLoading) {
      return;
    }
    emit(const MoviesLoading());
    try {
      _currentQuery = query;
      final response = await _repository.getMovies(page: 1, query: query);
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
      final String errorMessage = e.toString().replaceAll('Exception: ', '');
      emit(
        MoviesFailure(
          errorMessage.isEmpty ? 'Failed to load movies' : errorMessage,
        ),
      );
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
    // Prevent loading if already loading or in error state
    if (state is MoviesLoading) {
      return;
    }
    final nextPage = current.page + 1;
    print('[Cubit] State: Loading next page ($nextPage)');
    try {
      final response = await _repository.getMovies(
        page: nextPage,
        query: _currentQuery,
      );
      final int totalMovies = current.movies.length + response.results.length;
      print(
        '[Cubit] State: Success - Loaded page $nextPage, total movies now: $totalMovies',
      );
      final currentState = state;
      if (currentState is MoviesSuccess && currentState.page == current.page) {
        emit(
          currentState.copyWith(
            movies: <MovieModel>[...currentState.movies, ...response.results],
            page: response.page,
          ),
        );
      }
    } catch (e) {
      print('[Cubit] State: Failure - Error loading next page: $e');
    }
  }

  /// Helper to perform search by query and reset pagination
  Future<void> search(String query) async {
    await loadFirstPage(query: query);
  }
}
