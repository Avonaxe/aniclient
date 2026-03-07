import 'package:aniclient/features/anime/domain/entities/anime.dart';
import 'package:aniclient/features/anime/domain/repositories/anime_repository.dart';

class GetTopRatedAnime {
  final AnimeRepository repository;

  GetTopRatedAnime(this.repository);

  Future<List<Anime>> call() async {
    return await repository.getTopRatedAnime();
  }
}
