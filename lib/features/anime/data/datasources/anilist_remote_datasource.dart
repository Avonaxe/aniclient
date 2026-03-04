import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/anime_model.dart';

class AniListRemoteDataSource {
  static const String _baseUrl = "https://graphql.anilist.co";

  Future<List<AnimeModel>> getTrendingAnime() async {
    const query = '''
    query {
      Page(page: 1, perPage: 20) {
        media(sort: TRENDING_DESC, type: ANIME) {
          id
          title {
            romaji
          }
          coverImage {
            large
          }
          averageScore
          episodes
          description
        }
      }
    }
    ''';

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "query": query,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch trending anime");
    }

    final decoded = jsonDecode(response.body);

    final List mediaList = decoded['data']['Page']['media'];

    return mediaList
        .map((animeJson) => AnimeModel.fromJson(animeJson))
        .toList();
  }
}