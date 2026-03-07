import 'dart:async';

import 'package:aniclient/features/anime/presentation/widgets/anime_poster_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/anime_providers.dart';
import '../../domain/entities/anime.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String searchQuery = "";
  Timer? _debounce;
  bool _isTyping = false;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    setState(() {
      _isTyping = true;
    });

    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        searchQuery = query;
        _isTyping = false;
      });
    });
  }

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
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Search anime...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: _isTyping
                ? const Center(child: CircularProgressIndicator())
                : searchQuery.isEmpty
                    ? const Center(
                        child: Text(
                          "Type something to search",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : resultsAsync.when(
                        data: (List<Anime> animeList) {
                          if (animeList.isEmpty) {
                            return const Center(
                              child: Text(
                                "No anime found.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }
                          return GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.55,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: animeList.length,
                            itemBuilder: (context, index) {
                              final anime = animeList[index];

                              return AnimePosterCard(
                                anime: anime,
                                heroTagContext: 'search',
                              );
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