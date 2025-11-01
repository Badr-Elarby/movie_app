import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_movie_app/core/network/dio_interceptor.dart';
import 'package:simple_movie_app/features/movies/data/datasources/movie_details_remote_data_source.dart';
import 'package:simple_movie_app/features/movies/data/datasources/movie_details_remote_data_source_impl.dart';
import 'package:simple_movie_app/features/movies/data/datasources/movies_remote_data_source.dart';
import 'package:simple_movie_app/features/movies/data/datasources/movies_remote_data_source_impl.dart';
import 'package:simple_movie_app/features/movies/data/repositories/movie_details_repository.dart';
import 'package:simple_movie_app/features/movies/data/repositories/movie_details_repository_impl.dart';
import 'package:simple_movie_app/features/movies/data/repositories/movies_repository.dart';
import 'package:simple_movie_app/features/movies/data/repositories/movies_repository_impl.dart';
import 'package:simple_movie_app/features/movies/presentation/cubits/movie_details_cubit/movie_details_cubit.dart';
import 'package:simple_movie_app/features/movies/presentation/cubits/movies_cubit/movies_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Core/network
  getIt.registerLazySingleton<AuthInterceptor>(() => AuthInterceptor());
  getIt.registerLazySingleton<Dio>(() => createDio(getIt<AuthInterceptor>()));

  // Data sources
  getIt.registerLazySingleton<MoviesRemoteDataSource>(
    () => MoviesRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<MovieDetailsRemoteDataSource>(
    () => MovieDetailsRemoteDataSourceImpl(getIt<Dio>()),
  );

  // Repositories
  getIt.registerLazySingleton<MoviesRepository>(
    () => MoviesRepositoryImpl(getIt<MoviesRemoteDataSource>()),
  );
  getIt.registerLazySingleton<MovieDetailsRepository>(
    () => MovieDetailsRepositoryImpl(getIt<MovieDetailsRemoteDataSource>()),
  );

  // Cubits
  getIt.registerFactory<MoviesCubit>(
    () => MoviesCubit(getIt<MoviesRepository>()),
  );
  getIt.registerFactory<MovieDetailsCubit>(
    () => MovieDetailsCubit(getIt<MovieDetailsRepository>()),
  );
}
