import 'package:hive/hive.dart';
import 'movie_model.dart';

part 'movies_response_model.g.dart';

@HiveType(typeId: 1)
class MoviesResponseModel extends HiveObject {
  MoviesResponseModel({
    required this.page,
    required this.total_pages,
    required this.results,
  });

  @HiveField(0)
  final int page;

  @HiveField(1)
  final int total_pages;

  @HiveField(2)
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
