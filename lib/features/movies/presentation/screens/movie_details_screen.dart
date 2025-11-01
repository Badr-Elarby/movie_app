import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_movie_app/core/di/injection_container.dart';
import 'package:simple_movie_app/features/movies/data/models/movie_details_model.dart';
import 'package:simple_movie_app/features/movies/presentation/cubits/movie_details_cubit/movie_details_cubit.dart';
import 'package:simple_movie_app/features/movies/presentation/cubits/movie_details_cubit/movie_details_state.dart';

class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({super.key, required this.movieId});

  final int movieId;

  @override
  Widget build(BuildContext context) {
    print('[UI] Building MovieDetailsScreen for movie ID: $movieId');
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return BlocProvider<MovieDetailsCubit>(
      create: (_) =>
          getIt<MovieDetailsCubit>()..loadMovieDetails(movieId: movieId),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: Text('Movie Details', style: textTheme.titleMedium),
          centerTitle: true,
        ),
        body: SafeArea(
          child: BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
            builder: (BuildContext context, MovieDetailsState state) {
              if (state is MovieDetailsLoading) {
                print('[UI] State: Loading');
                return const Center(child: CircularProgressIndicator());
              }

              if (state is MovieDetailsFailure) {
                print('[UI] State: Error - ${state.message}');
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading movie details',
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<MovieDetailsCubit>().loadMovieDetails(
                            movieId: movieId,
                          );
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is MovieDetailsSuccess) {
                print(
                  '[UI] State: Success - Building UI for "${state.details.title}"',
                );
                return _buildMovieDetails(
                  context,
                  state.details,
                  colorScheme,
                  textTheme,
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMovieDetails(
    BuildContext context,
    MovieDetailsModel details,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    // TMDB base image URL for posters
    const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
    final String? posterPath = details.poster_path;
    final String? imageUrl = (posterPath != null && posterPath.isNotEmpty)
        ? '$imageBaseUrl$posterPath'
        : null;

    print(
      '[UI] Movie "${details.title}" - Image URL: ${imageUrl ?? 'null (placeholder)'}',
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Large poster
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 320),
                height: 480,
                color: colorScheme.surfaceVariant,
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder:
                            (
                              BuildContext context,
                              Widget child,
                              ImageChunkEvent? loadingProgress,
                            ) {
                              if (loadingProgress == null) {
                                print('[UI] Poster loaded successfully');
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                        errorBuilder:
                            (
                              BuildContext context,
                              Object error,
                              StackTrace? stackTrace,
                            ) {
                              print(
                                '[UI] ERROR: Failed to load poster: $error',
                              );
                              return Icon(
                                Icons.image_not_supported_outlined,
                                color: colorScheme.onSurfaceVariant,
                                size: 40,
                              );
                            },
                      )
                    : Icon(
                        Icons.image_not_supported_outlined,
                        color: colorScheme.onSurfaceVariant,
                        size: 40,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Title
          Text(details.title, style: textTheme.headlineSmall),
          // Tagline
          if (details.tagline != null && details.tagline!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              details.tagline!,
              style: textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 12),
          // Rating and genres
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: <Widget>[
              // Rating
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.star_rounded,
                    color: colorScheme.secondary,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${(details.vote_average ?? 0).toStringAsFixed(1)} / 10',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
              // Genres
              if (details.genres != null && details.genres!.isNotEmpty)
                ...details.genres!.map((MovieGenre genre) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colorScheme.outlineVariant),
                    ),
                    child: Text(genre.name, style: textTheme.labelMedium),
                  );
                }),
            ],
          ),
          // Release date and runtime
          if (details.release_date != null || details.runtime != null) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: <Widget>[
                if (details.release_date != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(details.release_date!, style: textTheme.bodySmall),
                    ],
                  ),
                if (details.runtime != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${details.runtime} min',
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
              ],
            ),
          ],
          const SizedBox(height: 24),
          // Overview
          Text('Description', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(details.overview, style: textTheme.bodyMedium),
          ElevatedButton(
            onPressed: () {
              FirebaseCrashlytics.instance.crash();
            },
            child: const Text("💥 Crash App"),
          ),
        ],
      ),
    );
  }
}
