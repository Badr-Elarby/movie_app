import 'package:dio/dio.dart';
import '../models/movies_response_model.dart';

abstract class MoviesRemoteDataSource {
  Future<MoviesResponseModel> getPopularMovies({required int page});
}
