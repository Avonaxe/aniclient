import 'package:flutter/material.dart';

import 'features/anime/data/datasources/anilist_remote_datasource.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final datasource = AniListRemoteDataSource();

  // Test searchAnime()
  final searchResults = await datasource.searchAnime("Naruto");

  print("Search Results:");
  for (var anime in searchResults) {
    print(anime.title);
  }

  // Test getAnimeDetails()
  final animeDetails = await datasource.getAnimeDetails(16498);

  print("\nAnime Details:");
  print(animeDetails.title);
  print(animeDetails.averageScore);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("Check terminal for API output"),
        ),
      ),
    );
  }
}