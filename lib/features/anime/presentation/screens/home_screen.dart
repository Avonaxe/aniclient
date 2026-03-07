import 'package:aniclient/features/anime/presentation/screens/search_screen.dart';
import 'package:aniclient/features/anime/presentation/widgets/anime_poster_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/anime_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingAsync = ref.watch(trendingAnimeProvider);
    final popularAsync = ref.watch(popularAnimeProvider);
    final upcomingAsync = ref.watch(seasonalAnimeProvider);
    final topRatedAsync = ref.watch(topRatedAnimeProvider);
    final airingAsync = ref.watch(airingAnimeProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text("Anime Explorer"),
            floating: true,
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
          SliverToBoxAdapter(
            child: _buildSection("Trending Now", trendingAsync, "trending"),
          ),
          SliverToBoxAdapter(
            child: _buildSection("Seasonal Releases", upcomingAsync, "seasonal"),
          ),
          SliverToBoxAdapter(
            child: _buildSection("Popular This Season", popularAsync, "popular"),
          ),
          SliverToBoxAdapter(
            child: _buildSection("Top Rated of All Time", topRatedAsync, "top_rated"),
          ),
          SliverToBoxAdapter(
            child: _buildSection("Currently Airing", airingAsync, "airing"),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }

  Widget _buildSection(
    String title,
    AsyncValue<List<dynamic>> asyncData,
    String heroContext,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 260,
          child: asyncData.when(
            data: (animeList) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: animeList.length,
                itemBuilder: (context, index) {
                  final anime = animeList[index];
                  return AnimePosterCard(
                    anime: anime,
                    heroTagContext: heroContext,
                  );
                },
              );
            },
            loading: () => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 180,
                        width: 120,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B2D42),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 14,
                        width: 100,
                        color: const Color(0xFF2B2D42),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 12,
                        width: 40,
                        color: const Color(0xFF2B2D42),
                      ),
                    ],
                  ),
                );
              },
            ),
            error: (error, stack) => const Center(child: Text("Error loading section")),
          ),
        ),
      ],
    );
  }
}
