import 'package:aniclient/features/anime/presentation/widgets/anime_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/anime_providers.dart';
import '../../domain/entities/anime.dart';
import 'anime_details_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final resultsAsync =
        ref.watch(searchAnimeResultsProvider(searchQuery));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Anime"),
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search anime...",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          Expanded(
            child: searchQuery.isEmpty
                ? const Center(
                    child: Text("Type something to search"),
                  )
                : resultsAsync.when(
                    data: (List<Anime> animeList) {
                      return ListView.builder(
                        itemCount: animeList.length,
                        itemBuilder: (context, index) {
                          final anime = animeList[index];

                          return AnimeCard(anime: anime);
                        },
                      );
                    },

                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),

                    error: (error, stack) => Center(
                      child: Text("Error: $error"),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}