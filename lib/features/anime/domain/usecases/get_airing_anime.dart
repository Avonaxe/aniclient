import 'package:aniclient/features/anime/domain/entities/anime.dart';
import 'package:aniclient/features/anime/domain/repositories/anime_repository.dart';

class GetAiringAnime {
  final AnimeRepository repository;

  GetAiringAnime(this.repository);

  Future<List<Anime>> call() async {
    return await repository.getAiringAnime();
  }
}
