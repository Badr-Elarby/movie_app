import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_movie_app/core/di/injection_container.dart';
import 'package:simple_movie_app/features/movies/data/models/movie_details_model.dart';
import 'package:simple_movie_app/features/movies/presentation/cubits/movie_details_cubit/movie_details_cubit.dart';
import 'package:simple_movie_app/features/movies/presentation/cubits/movie_details_cubit/movie_details_state.dart';
import 'package:url_launcher/url_launcher.dart';

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
            onPressed: () {
              // Safe navigation with error handling
              try {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              } catch (e) {
                print('[UI] Navigation error: $e');
              }
            },
          ),
          title: Text('Movie Details', style: textTheme.titleMedium),
          centerTitle: true,
        ),
        body: SafeArea(
          child: BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
            // Performance optimization: only rebuild when state type or content changes
            buildWhen: (previous, current) {
              // Rebuild if state type changes
              if (previous.runtimeType != current.runtimeType) {
                return true;
              }
              // For success states, rebuild if movie details change
              if (previous is MovieDetailsSuccess &&
                  current is MovieDetailsSuccess) {
                return previous.details.id != current.details.id;
              }
              // For failure states, rebuild if error message changes
              if (previous is MovieDetailsFailure &&
                  current is MovieDetailsFailure) {
                return previous.message != current.message;
              }
              return false;
            },
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
                          // Safe cubit access with error handling
                          try {
                            context.read<MovieDetailsCubit>().loadMovieDetails(
                              movieId: movieId,
                            );
                          } catch (e) {
                            print('[UI] Error retrying: $e');
                          }
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
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (BuildContext context, String url) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: colorScheme.secondary,
                            ),
                          );
                        },
                        errorWidget:
                            (BuildContext context, String url, dynamic error) {
                              print(
                                '[UI] ERROR: Failed to load cached poster: $error',
                              );
                              return Icon(
                                Icons.image_not_supported_outlined,
                                color: colorScheme.onSurfaceVariant,
                                size: 40,
                              );
                            },
                        // Cache configuration for better performance
                        memCacheWidth: 640,
                        memCacheHeight: 960,
                        maxWidthDiskCache: 800,
                        maxHeightDiskCache: 1200,
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
          // Trailer button (if available)
          Builder(
            builder: (BuildContext context) {
              final state = context.read<MovieDetailsCubit>().state;
              String? trailerKey;
              if (state is MovieDetailsSuccess) {
                trailerKey = state.trailerKey;
              }

              if (trailerKey != null && trailerKey.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ElevatedButton.icon(
                      icon: const Icon(Icons.play_circle_fill),
                      label: const Text('Watch Trailer'),
                      onPressed: () async {
                        final Uri url = Uri.parse(
                          'https://www.youtube.com/watch?v=$trailerKey',
                        );
                        try {
                          if (!await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          )) {
                            print('[UI] Could not launch trailer URL: $url');
                          }
                        } catch (e) {
                          print('[UI] Error launching trailer: $e');
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }
              // No trailer available - show nothing (minimal UI change)
              return const SizedBox.shrink();
            },
          ),
          // Overview
          Text('Description', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(details.overview, style: textTheme.bodyMedium),
          const SizedBox(height: 20),
          // Cast section
          Text('Cast', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Builder(
            builder: (BuildContext context) {
              final state = context.read<MovieDetailsCubit>().state;
              if (state is MovieDetailsSuccess &&
                  state.cast != null &&
                  state.cast!.isNotEmpty) {
                final List cast = state.cast!;
                return SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: cast.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (BuildContext context, int index) {
                      final dynamic member = cast[index];
                      final String? profilePath = member.profilePath as String?;
                      final String imageUrl =
                          profilePath != null && profilePath.isNotEmpty
                          ? 'https://image.tmdb.org/t/p/w185$profilePath'
                          : '';

                      return SizedBox(
                        width: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 84,
                                height: 84,
                                color: colorScheme.surfaceVariant,
                                child: imageUrl.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(
                                            color: colorScheme.secondary,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(
                                              Icons.person_2_outlined,
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                              size: 36,
                                            ),
                                      )
                                    : Icon(
                                        Icons.person_2_outlined,
                                        color: colorScheme.onSurfaceVariant,
                                        size: 36,
                                      ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              member.name ?? '',
                              style: textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              member.character ?? '',
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
              // No cast available
              return Text(
                'No cast information available.',
                style: textTheme.bodySmall,
              );
            },
          ),
        ],
      ),
    );
  }
}
