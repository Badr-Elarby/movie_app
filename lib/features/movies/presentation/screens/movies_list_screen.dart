import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:simple_movie_app/core/routing/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_movie_app/core/theming/cubit/theme_cubit.dart';
import 'package:simple_movie_app/features/movies/presentation/cubits/movies_cubit/movies_cubit.dart';
import 'package:simple_movie_app/features/movies/presentation/cubits/movies_cubit/movies_state.dart';
import 'package:simple_movie_app/features/movies/data/models/movie_model.dart';

class MoviesListScreen extends StatelessWidget {
  const MoviesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Movies', style: textTheme.titleMedium),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () => context.read<ThemeCubit>().toggle(),
            icon: Icon(
              Icons.brightness_6_rounded,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: BlocBuilder<MoviesCubit, MoviesState>(
                builder: (BuildContext context, MoviesState state) {
                  if (state is MoviesLoading || state is MoviesInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is MoviesFailure) {
                    return Center(
                      child: Text(state.message, style: textTheme.bodyMedium),
                    );
                  }
                  final MoviesSuccess data = state as MoviesSuccess;
                  print('[UI] Building list with ${data.movies.length} movies');
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: data.movies.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (BuildContext context, int index) {
                      final MovieModel movie = data.movies[index];
                      print(
                        '[UI] Building movie card for "${movie.title}" (ID: ${movie.id}, Index: $index)',
                      );
                      return _MovieCard(
                        movie: movie,
                        onTap: () {
                          print(
                            '[UI] Navigating to movie details for "${movie.title}" (ID: ${movie.id})',
                          );
                          Navigator.of(context).pushNamed(
                            AppRouter.movieDetailsRoute,
                            arguments: movie.id,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: FilledButton.tonal(
                  onPressed: () => context.read<MoviesCubit>().loadNextPage(),
                  child: const Text('Load More Movies'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  const _MovieCard({required this.movie, required this.onTap});

  final MovieModel movie;
  final VoidCallback onTap;

  // TMDB base image URL for posters
  // Issue fixed: The original code was not constructing the full image URL.
  // TMDB requires the base URL + size (w500) + poster_path to display images.
  static const String _imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    // Build the full image URL from TMDB poster_path
    // Original issue: poster_path was stored but never used to build the image URL.
    // The UI was showing a placeholder icon instead of fetching the actual image.
    final String? posterPath = movie.poster_path;
    final String? imageUrl = (posterPath != null && posterPath.isNotEmpty)
        ? '$_imageBaseUrl$posterPath'
        : null;

    print('[UI] Movie "${movie.title}" - Poster path: ${posterPath ?? 'null'}');
    print(
      '[UI] Movie "${movie.title}" - Image URL: ${imageUrl ?? 'null (will show placeholder)'}',
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 70,
                  height: 100,
                  color: colorScheme.surfaceVariant,
                  child: imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (BuildContext context, String url) {
                            print('[UI] Loading cached image for "${movie.title}" from $url');
                            return Center(
                              child: CircularProgressIndicator(
                                color: colorScheme.secondary,
                              ),
                            );
                          },
                          errorWidget: (
                            BuildContext context,
                            String url,
                            dynamic error,
                          ) {
                            print(
                              '[UI] ERROR: Failed to load cached image for "${movie.title}": $error',
                            );
                            return Icon(
                              Icons.image_not_supported_outlined,
                              color: colorScheme.onSurfaceVariant,
                            );
                          },
                          // Cache configuration
                          memCacheWidth: 140,
                          memCacheHeight: 200,
                          maxWidthDiskCache: 300,
                          maxHeightDiskCache: 450,
                        )
                      : Icon(
                          Icons.image_not_supported_outlined,
                          color: colorScheme.onSurfaceVariant,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      movie.title,
                      style: textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.star_rounded,
                          color: colorScheme.secondary,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${(movie.vote_average ?? 0).toStringAsFixed(1)}/10',
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Text(
                        movie.genre_ids?.isNotEmpty == true ? 'Movie' : 'N/A',
                        style: textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
