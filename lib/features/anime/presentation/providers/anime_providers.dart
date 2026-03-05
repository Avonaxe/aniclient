import 'package:aniclient/features/anime/data/datasources/anilist_remote_datasource.dart';
import 'package:aniclient/features/anime/data/repositories/anime_repository_impl.dart';
import 'package:aniclient/features/anime/domain/entities/anime.dart';
import 'package:aniclient/features/anime/domain/repositories/anime_repository.dart';
import 'package:aniclient/features/anime/domain/usecases/get_anime_details.dart';
import 'package:aniclient/features/anime/domain/usecases/get_trending_anime.dart';
import 'package:aniclient/features/anime/domain/usecases/search_anime.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final datasourceProvider = Provider<AniListRemoteDataSource>((ref) {
  return AniListRemoteDataSource();
});

final repositoryProvider = Provider<AnimeRepository>((ref) {
  final datasource = ref.watch(datasourceProvider);
  return AnimeRepositoryImpl(datasource);
});

final getTrendingAnimeProvider = Provider<GetTrendingAnime>((ref) {
  final repository = ref.watch(repositoryProvider);
  return GetTrendingAnime(repository);
});

final searchAnimeProvider = Provider<SearchAnime>((ref) {
  final repository = ref.watch(repositoryProvider);
  return SearchAnime(repository);
});

final getAnimeDetailsProvider = Provider<GetAnimeDetails>((ref) {
  final repository = ref.watch(repositoryProvider);
  return GetAnimeDetails(repository);
});

final trendingAnimeProvider = FutureProvider<List<Anime>>((ref) async {
  final usecase = ref.watch(getTrendingAnimeProvider);
  return usecase();
});

final searchAnimeResultsProvider =
    FutureProvider.family<List<Anime>, String>((ref, query) async {
  final usecase = ref.watch(searchAnimeProvider);
  return usecase(query);
});

final animeDetailsProvider =
    FutureProvider.family<Anime, int>((ref, id) async {
  final usecase = ref.watch(getAnimeDetailsProvider);
  return usecase(id);
});