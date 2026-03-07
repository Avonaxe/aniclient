import 'package:aniclient/features/anime/domain/entities/anime.dart';

abstract class AnimeRepository {
  Future<List<Anime>> getTrendingAnime();

  Future<List<Anime>> searchAnime(String query);

  Future<Anime> getAnimeDetails(int id);

  Future<List<Anime>> getPopularAnime();

  Future<List<Anime>> getTopRatedAnime();

  Future<List<Anime>> getAiringAnime();

  Future<List<Anime>> getSeasonalAnime();
}