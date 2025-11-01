import 'movie_model.dart';

class MoviesResponseModel {
  MoviesResponseModel({
    required this.page,
    required this.total_pages,
    required this.results,
  });

  final int page;
  final int total_pages;
  final List<MovieModel> results;

  // Convenience getter to keep existing references working (optional)
  int get totalPages => total_pages;

  factory MoviesResponseModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> items =
        (json['results'] as List<dynamic>? ?? <dynamic>[]);
    return MoviesResponseModel(
      page: (json['page'] as num).toInt(),
      total_pages: (json['total_pages'] as num).toInt(),
      results: items
          .map((dynamic e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'page': page,
      'total_pages': total_pages,
      'results': results.map((MovieModel e) => e.toJson()).toList(),
    };
  }
}
