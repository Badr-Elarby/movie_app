import '../../../data/models/movie_model.dart';

abstract class MoviesState {
  const MoviesState();
}

class MoviesInitial extends MoviesState {
  const MoviesInitial();
}

class MoviesLoading extends MoviesState {
  const MoviesLoading();
}

class MoviesFailure extends MoviesState {
  const MoviesFailure(this.message);
  final String message;
}

class MoviesSuccess extends MoviesState {
  const MoviesSuccess({
    required this.movies,
    required this.page,
    required this.totalPages,
  });

  final List<MovieModel> movies;
  final int page;
  final int totalPages;

  bool get hasMore => page < totalPages;

  MoviesSuccess copyWith({
    List<MovieModel>? movies,
    int? page,
    int? totalPages,
  }) {
    return MoviesSuccess(
      movies: movies ?? this.movies,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
