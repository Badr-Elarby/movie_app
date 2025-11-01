import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_movie_app/core/di/injection_container.dart';
import 'package:simple_movie_app/features/movies/presentation/cubits/movies_cubit/movies_cubit.dart';
import 'package:simple_movie_app/features/movies/presentation/screens/movie_details_screen.dart';
import 'package:simple_movie_app/features/movies/presentation/screens/movies_list_screen.dart';

class AppRouter {
  const AppRouter._();

  static const String initialRoute = '/';
  static const String movieDetailsRoute = '/movie-details';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => BlocProvider<MoviesCubit>(
            create: (_) => getIt<MoviesCubit>()..loadFirstPage(),
            child: const MoviesListScreen(),
          ),
          settings: const RouteSettings(name: initialRoute),
        );
      case movieDetailsRoute:
        final int? movieId = settings.arguments as int?;
        if (movieId == null) {
          // Fallback to initial route if no movie ID provided
          return MaterialPageRoute<dynamic>(
            builder: (_) => BlocProvider<MoviesCubit>(
              create: (_) => getIt<MoviesCubit>()..loadFirstPage(),
              child: const MoviesListScreen(),
            ),
            settings: const RouteSettings(name: initialRoute),
          );
        }
        return MaterialPageRoute<dynamic>(
          builder: (_) => MovieDetailsScreen(movieId: movieId),
          settings: RouteSettings(name: movieDetailsRoute, arguments: movieId),
        );
      default:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const MoviesListScreen(),
          settings: const RouteSettings(name: initialRoute),
        );
    }
  }
}
