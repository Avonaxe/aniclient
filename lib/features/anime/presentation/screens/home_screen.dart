import 'package:aniclient/features/anime/presentation/screens/search_screen.dart';
import 'package:aniclient/features/anime/presentation/widgets/anime_poster_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/anime_providers.dart';

class TrendingAnimeScreen extends ConsumerWidget {
  const TrendingAnimeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animeAsync = ref.watch(trendingAnimeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Anime Explorer"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: animeAsync.when(
        data: (animeList) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Trending Anime",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),

                SizedBox(
                  height: 270,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: animeList.length,
                    itemBuilder: (context, index) {
                      final anime = animeList[index];

                      return AnimePosterCard(anime: anime);
                    },
                  ),
                ),
              ],
            ),
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
