import 'package:aniclient/features/anime/presentation/screens/anime_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/anime_providers.dart';
import '../../domain/entities/anime.dart';

class TrendingAnimeScreen extends ConsumerWidget {
  const TrendingAnimeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animeAsync = ref.watch(trendingAnimeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Trending Anime")),
      body: animeAsync.when(
        data: (List<Anime> animeList) {
          return ListView.builder(
            itemCount: animeList.length,
            itemBuilder: (context, index) {
              final anime = animeList[index];

              return ListTile(
                leading: Image.network(anime.coverImage, width: 50),
                title: Text(anime.title),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AnimeDetailsScreen(animeId: anime.id),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stack) {
          return Center(child: Text("Error: $error"));
        },
      ),
    );
  }
}
