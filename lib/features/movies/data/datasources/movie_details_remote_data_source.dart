import 'package:dio/dio.dart';
import '../models/movie_details_model.dart';

abstract class MovieDetailsRemoteDataSource {
  Future<MovieDetailsModel> getMovieDetails({required int movieId});
}
