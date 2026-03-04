import '../../domain/entities/anime.dart';
import '../../domain/repositories/anime_repository.dart';

import '../datasources/anilist_remote_datasource.dart';

class AnimeRepositoryImpl implements AnimeRepository {
  final AniListRemoteDataSource remoteDataSource;

  AnimeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Anime>> getTrendingAnime() async {
    return await remoteDataSource.getTrendingAnime();
  }

  @override
  Future<List<Anime>> searchAnime(String query) async {
    return await remoteDataSource.searchAnime(query);
  }

  @override
  Future<Anime> getAnimeDetails(int id) async {
    return await remoteDataSource.getAnimeDetails(id);
  }
}