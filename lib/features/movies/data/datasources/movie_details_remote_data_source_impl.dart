import 'package:dio/dio.dart';
import 'package:simple_movie_app/features/movies/data/datasources/movie_details_remote_data_source.dart';
import 'package:simple_movie_app/features/movies/data/models/movie_details_model.dart';

class MovieDetailsRemoteDataSourceImpl implements MovieDetailsRemoteDataSource {
  MovieDetailsRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<MovieDetailsModel> getMovieDetails({required int movieId}) async {
    // Validate movieId
    if (movieId <= 0) {
      throw Exception('Invalid movie ID: $movieId');
    }

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

    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        endpoint,
        queryParameters: queryParams,
      );

      print('[DataSource] Response status code: ${response.statusCode}');
      print('[DataSource] Movie details received successfully');

      if (response.data == null) {
        throw Exception('Empty response from API');
      }

      return MovieDetailsModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      print('[DataSource] DioException: ${e.message}');
      print('[DataSource] Response: ${e.response?.data}');
      // Provide more context in error message
      if (e.response != null) {
        if (e.response?.statusCode == 404) {
          throw Exception('Movie not found');
        }
        throw Exception(
          'Failed to load movie details: ${e.response?.statusCode} - ${e.response?.statusMessage}',
        );
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection. Please check your network.');
      } else {
        throw Exception('Failed to load movie details: ${e.message}');
      }
    } catch (e) {
      print('[DataSource] Unexpected error: $e');
      rethrow;
    }
  }
}
