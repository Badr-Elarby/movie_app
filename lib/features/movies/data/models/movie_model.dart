class MovieModel {
  MovieModel({
    required this.id,
    required this.title,
    this.overview,
    this.poster_path,
    this.vote_average,
    this.genre_ids,
  });

  final int id;
  final String title;
  final String? overview;
  final String? poster_path;
  final double? vote_average;
  final List<int>? genre_ids;

  // Convenience getters to maintain readability in the UI (optional)
  String? get posterPath => poster_path;
  double? get voteAverage => vote_average;
  List<int>? get genreIds => genre_ids;

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    final String? posterPath = json['poster_path'] as String?;

    // Log poster path issues to diagnose image loading problems
    if (posterPath == null || posterPath.isEmpty) {
      final String title = (json['title'] as String?) ?? 'Unknown';
      print(
        '[Model] WARNING: Movie "$title" (ID: ${json['id']}) has null or empty poster_path - will show placeholder',
      );
    }

    return MovieModel(
      id: (json['id'] as num).toInt(),
      title: (json['title'] as String?) ?? '',
      overview: json['overview'] as String?,
      poster_path: posterPath,
      vote_average: (json['vote_average'] as num?)?.toDouble(),
      genre_ids: (json['genre_ids'] as List<dynamic>?)
          ?.map((dynamic e) => (e as num).toInt())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': poster_path,
      'vote_average': vote_average,
      'genre_ids': genre_ids,
    };
  }
}
