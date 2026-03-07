import '../models/anime_model.dart';
import '../../../../core/network/graphql_client.dart';

class AniListRemoteDataSource {
  final GraphQLClient client = GraphQLClient();

  // Reusable fragment for common anime fields
  static const String _animeFields = '''
    id
    title {
      romaji
      english
    }
    coverImage {
      large
    }
    bannerImage
    averageScore
    episodes
    description
    genres
    studios(isMain: true) {
      nodes {
        name
      }
    }
    nextAiringEpisode {
      episode
      timeUntilAiring
    }
  ''';

  Future<List<AnimeModel>> _queryAnimeList(String query, [Map<String, dynamic>? variables]) async {
    final data = await client.query(query: query, variables: variables);
    final List mediaList = data['Page']['media'];
    return mediaList.map((animeJson) => AnimeModel.fromJson(animeJson)).toList();
  }

  Future<List<AnimeModel>> getTrendingAnime() async {
    const query = '''
    query {
      Page(page: 1, perPage: 20) {
        media(sort: TRENDING_DESC, type: ANIME) {
          $_animeFields
        }
      }
    }
    ''';
    return _queryAnimeList(query);
  }

  Future<List<AnimeModel>> searchAnime(String queryString) async {
    const query = '''
    query (\$search: String) {
      Page(page: 1, perPage: 20) {
        media(search: \$search, type: ANIME) {
          $_animeFields
        }
      }
    }
    ''';
    return _queryAnimeList(query, {"search": queryString});
  }

  Future<AnimeModel> getAnimeDetails(int id) async {
    const query = '''
    query (\$id: Int) {
      Media(id: \$id, type: ANIME) {
        $_animeFields
        characters(sort: [ROLE, RELEVANCE, ID], perPage: 10) {
          edges {
            role
            node {
              id
              name {
                userPreferred
              }
              image {
                large
              }
            }
          }
        }
        staff(perPage: 5) {
          edges {
            node {
              id
              name {
                userPreferred
              }
              image {
                large
              }
              primaryOccupations
            }
          }
        }
        recommendations(sort: [RATING_DESC, ID], perPage: 10) {
          nodes {
            mediaRecommendation {
              id
              title {
                romaji
                english
              }
              coverImage {
                large
              }
              averageScore
              episodes
            }
          }
        }
      }
    }
    ''';
    
    final data = await client.query(query: query, variables: {"id": id});
    return AnimeModel.fromJson(data['Media']);
  }

  Future<List<AnimeModel>> getPopularAnime() async {
    const query = '''
    query {
      Page(page: 1, perPage: 20) {
        media(sort: POPULARITY_DESC, type: ANIME) {
           $_animeFields
        }
      }
    }
    ''';
    return _queryAnimeList(query);
  }

  Future<List<AnimeModel>> getTopRatedAnime() async {
    const query = '''
    query {
      Page(page: 1, perPage: 20) {
        media(sort: SCORE_DESC, type: ANIME) {
           $_animeFields
        }
      }
    }
    ''';
    return _queryAnimeList(query);
  }

  Future<List<AnimeModel>> getAiringAnime() async {
    const query = '''
    query {
      Page(page: 1, perPage: 20) {
        media(status: RELEASING, sort: POPULARITY_DESC, type: ANIME) {
           $_animeFields
        }
      }
    }
    ''';
    return _queryAnimeList(query);
  }
  
  Future<List<AnimeModel>> getSeasonalAnime() async {
    // Basic seasonal query (CURRENT season based on time is complex via GraphQL without dynamic variables)
    // We will use a standard sort for newest starting anime
    const query = '''
    query {
      Page(page: 1, perPage: 20) {
        media(sort: START_DATE_DESC, status: RELEASING, type: ANIME) {
           $_animeFields
        }
      }
    }
    ''';
    return _queryAnimeList(query);
  }
}
