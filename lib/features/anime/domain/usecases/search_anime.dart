import 'package:aniclient/features/anime/domain/entities/anime.dart';
import 'package:aniclient/features/anime/domain/repositories/anime_repository.dart';

class SearchAnime {
  final AnimeRepository repository;

  SearchAnime(this.repository);

  Future<List<Anime>> call(String query) async{
    return await repository.searchAnime(query);
  }
}