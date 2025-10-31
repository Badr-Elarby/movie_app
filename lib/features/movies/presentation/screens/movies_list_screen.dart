import 'package:flutter/material.dart';
import 'package:simple_movie_app/core/routing/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_movie_app/core/theming/cubit/theme_cubit.dart';

class MoviesListScreen extends StatelessWidget {
  const MoviesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    // Temporary dummy items just for UI preview
    final List<_MovieListItemData> movies = <_MovieListItemData>[
      const _MovieListItemData(
        title: 'Fight Club',
        rating: 8.8,
        genre: 'Drama',
      ),
      const _MovieListItemData(
        title: 'Forrest Gump',
        rating: 8.8,
        genre: 'Drama',
      ),
      const _MovieListItemData(
        title: 'The Shawshank Redemption',
        rating: 9.3,
        genre: 'Drama',
      ),
      const _MovieListItemData(
        title: 'The Godfather',
        rating: 9.2,
        genre: 'Crime',
      ),
      const _MovieListItemData(
        title: 'The Matrix',
        rating: 8.7,
        genre: 'Sci‑Fi',
      ),
    ];

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
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: movies.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 12),
                itemBuilder: (BuildContext context, int index) {
                  final _MovieListItemData data = movies[index];
                  return _MovieCard(
                    data: data,
                    onTap: () {
                      Navigator.of(
                        context,
                      ).pushNamed(AppRouter.movieDetailsRoute);
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
                  onPressed: () {},
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
  const _MovieCard({required this.data, required this.onTap});

  final _MovieListItemData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

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
                  width: 56,
                  height: 80,
                  color: colorScheme.surfaceVariant,
                  child: Icon(
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
                      data.title,
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
                        Text('${data.rating}/10', style: textTheme.bodySmall),
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
                      child: Text(data.genre, style: textTheme.labelMedium),
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

class _MovieListItemData {
  const _MovieListItemData({
    required this.title,
    required this.rating,
    required this.genre,
  });

  final String title;
  final double rating;
  final String genre;
}
