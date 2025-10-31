import 'package:flutter/material.dart';

class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text('Movie Details', style: textTheme.titleMedium),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 320),
                    height: 220,
                    color: colorScheme.surfaceVariant,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: colorScheme.onSurfaceVariant,
                      size: 40,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('The Matrix', style: textTheme.headlineSmall),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Icon(Icons.star_rounded, color: colorScheme.secondary, size: 20),
                  const SizedBox(width: 6),
                  Text('8.7 / 10', style: textTheme.bodyMedium),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colorScheme.outlineVariant),
                    ),
                    child: Text('Sci‑Fi', style: textTheme.labelMedium),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Description', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                'A computer programmer discovers that reality as he knows it is a simulation created by machines.',
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


