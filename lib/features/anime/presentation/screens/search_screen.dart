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
            child: Column(
              children: [
                TextField(
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
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ActionChip(
                        label: const Text('Format'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Format filters coming soon!")),
                          );
                        },
                        backgroundColor: const Color(0xFF2B2D42),
                        side: BorderSide.none,
                      ),
                      const SizedBox(width: 8),
                      ActionChip(
                        label: const Text('Status'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Status filters coming soon!")),
                          );
                        },
                        backgroundColor: const Color(0xFF2B2D42),
                        side: BorderSide.none,
                      ),
                      const SizedBox(width: 8),
                      ActionChip(
                        label: const Text('Genre'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Genre filters coming soon!")),
                          );
                        },
                        backgroundColor: const Color(0xFF2B2D42),
                        side: BorderSide.none,
                      ),
                      const SizedBox(width: 8),
                      ActionChip(
                        label: const Text('Sort'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Sort filters coming soon!")),
                          );
                        },
                        backgroundColor: const Color(0xFF2B2D42),
                        side: BorderSide.none,
                      ),
                    ],
                  ),
                ),
              ],
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
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 140,
                              childAspectRatio: 0.42, // Adjusted for larger font scales
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