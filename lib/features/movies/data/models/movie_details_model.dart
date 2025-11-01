class MovieGenre {
  MovieGenre({required this.id, required this.name});

  final int id;
  final String name;

  factory MovieGenre.fromJson(Map<String, dynamic> json) {
    return MovieGenre(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'name': name};
  }
}

class MovieDetailsModel {
  MovieDetailsModel({
    required this.id,
    required this.title,
    required this.overview,
    this.poster_path,
    this.backdrop_path,
    this.release_date,
    this.vote_average,
    this.runtime,
    this.genres,
    this.tagline,
  });

  final int id;
  final String title;
  final String overview;
  final String? poster_path;
  final String? backdrop_path;
  final String? release_date;
  final double? vote_average;
  final int? runtime;
  final List<MovieGenre>? genres;
  final String? tagline;

  // Convenience getters
  String? get posterPath => poster_path;
  String? get backdropPath => backdrop_path;
  String? get releaseDate => release_date;
  double? get voteAverage => vote_average;

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    print('[Model] Parsing movie details for ID: ${json['id']}');
    print('[Model] Movie: ${json['title']}');

    final List<dynamic>? genresData = json['genres'] as List<dynamic>?;
    print('[Model] Genres found: ${genresData?.length ?? 0}');

    return MovieDetailsModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      poster_path: json['poster_path'] as String?,
      backdrop_path: json['backdrop_path'] as String?,
      release_date: json['release_date'] as String?,
      vote_average: (json['vote_average'] as num?)?.toDouble(),
      runtime: (json['runtime'] as num?)?.toInt(),
      genres: genresData?.map((dynamic e) => MovieGenre.fromJson(e as Map<String, dynamic>)).toList(),
      tagline: json['tagline'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': poster_path,
      'backdrop_path': backdrop_path,
      'release_date': release_date,
      'vote_average': vote_average,
      'runtime': runtime,
      'genres': genres?.map((MovieGenre e) => e.toJson()).toList(),
      'tagline': tagline,
    };
  }
}
