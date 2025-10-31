import 'package:flutter/material.dart';
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
          builder: (_) => const MoviesListScreen(),
          settings: const RouteSettings(name: initialRoute),
        );
      case movieDetailsRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const MovieDetailsScreen(),
          settings: const RouteSettings(name: movieDetailsRoute),
        );
      default:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const MoviesListScreen(),
          settings: const RouteSettings(name: initialRoute),
        );
    }
  }
}
