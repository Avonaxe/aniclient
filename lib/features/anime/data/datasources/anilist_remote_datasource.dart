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
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"query": query}),
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

  Future<List<AnimeModel>> searchAnime(String queryString) async {
    const query = '''
  query (\$search: String) {
    Page(page: 1, perPage: 20) {
      media(search: \$search, type: ANIME) {
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
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "query": query,
        "variables": {"search": queryString},
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to search anime");
    }

    final decoded = jsonDecode(response.body);

    final List mediaList = decoded['data']['Page']['media'];

    return mediaList
        .map((animeJson) => AnimeModel.fromJson(animeJson))
        .toList();
  }

  Future<AnimeModel> getAnimeDetails(int id) async {
    const query = '''
  query (\$id: Int) {
    Media(id: \$id, type: ANIME) {
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
  ''';

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "query": query,
        "variables": {"id": id},
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch anime details");
    }

    final decoded = jsonDecode(response.body);

    final animeJson = decoded['data']['Media'];

    return AnimeModel.fromJson(animeJson);
  }
  Future<AnimeModel> getAnimeDetails(int id) async {
    const query = '''
  query (\$id: Int) {
    Media(id: \$id, type: ANIME) {
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
  ''';

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "query": query,
        "variables": {"id": id},
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch anime details");
    }

    final decoded = jsonDecode(response.body);

    final animeJson = decoded['data']['Media'];

    return AnimeModel.fromJson(animeJson);
  }

  Future<List<AnimeModel>> getPopularAnime() async {
    const query = '''
    query {
      Page(page: 1, perPage: 20) {
        media(sort: POPULARITY_DESC, type: ANIME) {
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
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"query": query}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch popular anime");
    }

    final decoded = jsonDecode(response.body);
    final List mediaList = decoded['data']['Page']['media'];

    return mediaList
        .map((animeJson) => AnimeModel.fromJson(animeJson))
        .toList();
  }

  Future<List<AnimeModel>> getTopRatedAnime() async {
    const query = '''
    query {
      Page(page: 1, perPage: 20) {
        media(sort: SCORE_DESC, type: ANIME) {
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
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"query": query}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch top rated anime");
    }

    final decoded = jsonDecode(response.body);
    final List mediaList = decoded['data']['Page']['media'];

    return mediaList
        .map((animeJson) => AnimeModel.fromJson(animeJson))
        .toList();
  }

  Future<List<AnimeModel>> getAiringAnime() async {
    const query = '''
    query {
      Page(page: 1, perPage: 20) {
        media(status: RELEASING, sort: POPULARITY_DESC, type: ANIME) {
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
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"query": query}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch airing anime");
    }

    final decoded = jsonDecode(response.body);
    final List mediaList = decoded['data']['Page']['media'];

    return mediaList
        .map((animeJson) => AnimeModel.fromJson(animeJson))
        .toList();
  }
}
