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
      appBar: AppBar(title: const Text("Anime Details")),
      body: animeAsync.when(
        data: (Anime anime) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'anime_poster_${anime.id}_$heroTagContext',
                  child: Image.network(
                    anime.coverImage,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    anime.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Score: ${anime.averageScore ?? "N/A"}"),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Episodes: ${anime.episodes ?? "Unknown"}"),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Html(data: anime.description ?? ""),
                  ),
                ),
              ],
            ),
          );
        },

        loading: () => const Center(child: CircularProgressIndicator()),

        error: (error, stack) => Center(child: Text("Error: $error")),
      ),
    );
  }
}
