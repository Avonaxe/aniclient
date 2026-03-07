import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aniclient/features/library/data/repositories/library_repository.dart';
import 'package:aniclient/features/anime/presentation/widgets/anime_card.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listsAsync = ref.watch(userAnimeListsProvider);

    return DefaultTabController(
      length: 5, // Common defaults: Watching, Completed, Paused, Dropped, Planning
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Library"),
          bottom: listsAsync.when(
            data: (lists) {
              if (lists.isEmpty) {
                return const PreferredSize(
                  preferredSize: Size.fromHeight(0), 
                  child: SizedBox(),
                );
              }
              return TabBar(
                isScrollable: true,
                tabs: lists.map((list) => Tab(text: "\${list.name} (\${list.entries.length})")).toList(),
              );
            },
            loading: () => const PreferredSize(
              preferredSize: Size.fromHeight(48),
              child: LinearProgressIndicator(),
            ),
            error: (_, __) => const PreferredSize(
              preferredSize: Size.fromHeight(0), 
              child: SizedBox(),
            ),
          ),
        ),
        body: listsAsync.when(
          data: (lists) {
            if (lists.isEmpty) {
              return const Center(
                child: Text("Your library is empty.", style: TextStyle(color: Colors.grey, fontSize: 16)),
              );
            }
            
            // Re-wrap the Scaffold body in another DefaultTabController specific to data length
            return DefaultTabController(
              length: lists.length,
              child: Column(
                children: [
                   Expanded(
                    child: TabBarView(
                      children: lists.map((userList) {
                        if (userList.entries.isEmpty) {
                           return const Center(child: Text("No anime in this list"));
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: userList.entries.length,
                          itemBuilder: (context, index) {
                            final entry = userList.entries[index];
                            // Reusing our global AnimeCard
                            return AnimeCard(anime: entry.anime);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text("Error fetching library: $error")),
        ),
      ),
    );
  }
}
