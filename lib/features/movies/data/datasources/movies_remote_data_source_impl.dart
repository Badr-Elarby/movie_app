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

    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        endpoint,
        queryParameters: queryParams,
      );

      print('[DataSource] Response status code: ${response.statusCode}');
      print('[DataSource] Response received for page $page');

      if (response.data == null) {
        throw Exception('Empty response from API');
      }

      return MoviesResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      print('[DataSource] DioException: ${e.message}');
      print('[DataSource] Response: ${e.response?.data}');
      // Provide more context in error message
      if (e.response != null) {
        throw Exception(
          'Failed to load movies: ${e.response?.statusCode} - ${e.response?.statusMessage}',
        );
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection. Please check your network.');
      } else {
        throw Exception('Failed to load movies: ${e.message}');
      }
    } catch (e) {
      print('[DataSource] Unexpected error: $e');
      rethrow;
    }
  }

  @override
  Future<MoviesResponseModel> searchMovies({
    required int page,
    required String query,
  }) async {
    final String baseUrl = _dio.options.baseUrl;
    final String endpoint = 'search/movie';
    final Map<String, dynamic> queryParams = <String, dynamic>{
      'include_adult': 'false',
      'language': 'en-US',
      'page': page,
      'query': query,
    };
    final Uri fullUri = Uri.parse(baseUrl + endpoint).replace(
      queryParameters: queryParams.map(
        (String k, dynamic v) => MapEntry(k, v.toString()),
      ),
    );

    print('[DataSource] Searching movies from: $fullUri');

    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        endpoint,
        queryParameters: queryParams,
      );

      print('[DataSource] Response status code: ${response.statusCode}');
      print('[DataSource] Search response received for page $page');

      if (response.data == null) {
        throw Exception('Empty response from API');
      }

      return MoviesResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      print('[DataSource] DioException (search): ${e.message}');
      if (e.response != null) {
        throw Exception(
          'Failed to search movies: ${e.response?.statusCode} - ${e.response?.statusMessage}',
        );
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection. Please check your network.');
      } else {
        throw Exception('Failed to search movies: ${e.message}');
      }
    } catch (e) {
      print('[DataSource] Unexpected error (search): $e');
      rethrow;
    }
  }
}
