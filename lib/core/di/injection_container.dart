import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_movie_app/core/network/dio_interceptor.dart';
import 'package:simple_movie_app/features/movies/data/datasources/movie_details_remote_data_source.dart';
import 'package:simple_movie_app/features/movies/data/datasources/movie_details_remote_data_source_impl.dart';
import 'package:simple_movie_app/features/movies/data/datasources/movies_local_data_source.dart';
import 'package:simple_movie_app/features/movies/data/datasources/movies_remote_data_source.dart';
import 'package:simple_movie_app/features/movies/data/datasources/movies_remote_data_source_impl.dart';
import 'package:simple_movie_app/features/movies/data/models/movie_model.dart';
import 'package:simple_movie_app/features/movies/data/models/movies_response_model.dart';
import 'package:simple_movie_app/features/movies/data/repositories/movie_details_repository.dart';
import 'package:simple_movie_app/features/movies/data/repositories/movie_details_repository_impl.dart';
import 'package:simple_movie_app/features/movies/data/repositories/movies_repository.dart';
import 'package:simple_movie_app/features/movies/data/repositories/movies_repository_impl.dart';
import 'package:simple_movie_app/features/movies/presentation/cubits/movie_details_cubit/movie_details_cubit.dart';
import 'package:simple_movie_app/features/movies/presentation/cubits/movies_cubit/movies_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Initialize Hive for offline caching
  await Hive.initFlutter();
  print('[DI] Initialized Hive for offline caching');

  // Register TypeAdapters
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(MovieModelAdapter());
    print('[DI] Registered MovieModel adapter (typeId: 0)');
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(MoviesResponseModelAdapter());
    print('[DI] Registered MoviesResponseModel adapter (typeId: 1)');
  }

  // Open Hive box for movies cache
  final Box<MoviesResponseModel> moviesBox =
      await Hive.openBox<MoviesResponseModel>('movies_cache');
  print('[DI] Opened Hive box: movies_cache');

  // Core/network
  getIt.registerLazySingleton<AuthInterceptor>(() => AuthInterceptor());
  getIt.registerLazySingleton<Dio>(() => createDio(getIt<AuthInterceptor>()));

  // Connectivity
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  // Data sources
  getIt.registerLazySingleton<MoviesRemoteDataSource>(
    () => MoviesRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<MoviesLocalDataSource>(
    () => MoviesLocalDataSourceImpl(moviesBox),
  );
  getIt.registerLazySingleton<MovieDetailsRemoteDataSource>(
    () => MovieDetailsRemoteDataSourceImpl(getIt<Dio>()),
  );

  // Repositories
  getIt.registerLazySingleton<MoviesRepository>(
    () => MoviesRepositoryImpl(
      getIt<MoviesRemoteDataSource>(),
      getIt<MoviesLocalDataSource>(),
      getIt<Connectivity>(),
    ),
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

  print('[DI] ✅ Dependency injection setup completed');
}
