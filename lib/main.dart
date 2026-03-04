import 'package:flutter/material.dart';

import 'features/anime/data/datasources/anilist_remote_datasource.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final datasource = AniListRemoteDataSource();

  final animeList = await datasource.getTrendingAnime();

  for (var anime in animeList) {
    print(anime.title);
  }

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