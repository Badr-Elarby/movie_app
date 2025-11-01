import 'package:dio/dio.dart';
import 'package:simple_movie_app/features/movies/data/datasources/movies_remote_data_source.dart';
import 'package:simple_movie_app/features/movies/data/models/movies_response_model.dart';

class MoviesRemoteDataSourceImpl implements MoviesRemoteDataSource {
  MoviesRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<MoviesResponseModel> getPopularMovies({required int page}) async {
    // Build the full URL for logging
    final String baseUrl = _dio.options.baseUrl;
    final String endpoint = 'discover/movie';
    final Map<String, dynamic> queryParams = <String, dynamic>{
      'include_adult': 'false',
      'include_video': 'false',
      'language': 'en-US',
      'page': page,
      'sort_by': 'popularity.desc',
    };
    final Uri fullUri = Uri.parse(baseUrl + endpoint).replace(
      queryParameters: queryParams.map(
        (String k, dynamic v) => MapEntry(k, v.toString()),
      ),
    );

    print('[DataSource] Requesting movies from: $fullUri');

    final Response<dynamic> response = await _dio.get<dynamic>(
      endpoint,
      queryParameters: queryParams,
    );

    print('[DataSource] Response status code: ${response.statusCode}');
    print('[DataSource] Response received for page $page');

    return MoviesResponseModel.fromJson(response.data as Map<String, dynamic>);
  }
}
