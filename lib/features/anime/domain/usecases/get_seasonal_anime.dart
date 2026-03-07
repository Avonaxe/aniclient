import '../../domain/entities/anime.dart';
import '../../domain/repositories/anime_repository.dart';

class GetSeasonalAnime {
  final AnimeRepository repository;

  GetSeasonalAnime(this.repository);

  Future<List<Anime>> execute() async {
    return await repository.getSeasonalAnime();
  }
}
