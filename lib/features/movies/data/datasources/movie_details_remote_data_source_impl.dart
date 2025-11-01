import 'package:dio/dio.dart';
import 'package:simple_movie_app/features/movies/data/datasources/movie_details_remote_data_source.dart';
import 'package:simple_movie_app/features/movies/data/models/movie_details_model.dart';

class MovieDetailsRemoteDataSourceImpl implements MovieDetailsRemoteDataSource {
  MovieDetailsRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<MovieDetailsModel> getMovieDetails({required int movieId}) async {
    // Build the full URL for logging
    final String baseUrl = _dio.options.baseUrl;
    final String endpoint = 'movie/$movieId';
    final Map<String, dynamic> queryParams = <String, dynamic>{
      'language': 'en-US',
    };
    final Uri fullUri = Uri.parse(baseUrl + endpoint).replace(
      queryParameters: queryParams.map(
        (String k, dynamic v) => MapEntry(k, v.toString()),
      ),
    );

    print('[DataSource] Requesting movie details from: $fullUri');
    print('[DataSource] Movie ID: $movieId');

    final Response<dynamic> response = await _dio.get<dynamic>(
      endpoint,
      queryParameters: queryParams,
    );

    print('[DataSource] Response status code: ${response.statusCode}');
    print('[DataSource] Movie details received successfully');

    return MovieDetailsModel.fromJson(response.data as Map<String, dynamic>);
  }
}
