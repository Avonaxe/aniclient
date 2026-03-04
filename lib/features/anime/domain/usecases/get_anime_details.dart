import '../entities/anime.dart';
import '../repositories/anime_repository.dart';

class GetAnimeDetails {
  final AnimeRepository repository;

  GetAnimeDetails(this.repository);

  Future<List<Anime>> call(int id) async{
    return await repository.getAnimeDetails(id);
  }
}