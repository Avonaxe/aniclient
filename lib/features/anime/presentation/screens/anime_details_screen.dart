import 'package:aniclient/features/anime/domain/entities/anime.dart';
import 'package:aniclient/features/anime/presentation/providers/anime_providers.dart';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimeDetailsScreen extends ConsumerWidget {
  final int animeId;
  final String heroTagContext;

  const AnimeDetailsScreen({
    super.key, 
    required this.animeId,
    required this.heroTagContext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animeAsync = ref.watch(animeDetailsProvider(animeId));

    return Scaffold(
      body: animeAsync.when(
        data: (Anime anime) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'anime_poster_${anime.id}_$heroTagContext',
                    child: Image.network(
                      anime.coverImage,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        anime.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            "${anime.averageScore ?? 'N/A'}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 24),
                          const Icon(Icons.tv, color: Colors.grey, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            "${anime.episodes ?? '?'} Episodes",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Synopsis",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Html(
                        data: anime.description ?? "No description available.",
                        style: {
                          "body": Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                            fontSize: FontSize(16),
                            lineHeight: LineHeight.em(1.5),
                          ),
                        },
                      ),
                      const SizedBox(height: 48), // Bottom padding
                    ],
                  ),
                ),
              ),
            ],
          );
        },

        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),

        error: (error, stack) => Scaffold(body: Center(child: Text("Error: $error"))),
      ),
    );
  }
}
