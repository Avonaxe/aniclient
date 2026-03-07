import 'package:aniclient/features/anime/data/datasources/anilist_remote_datasource.dart';
import 'package:aniclient/features/anime/data/repositories/anime_repository_impl.dart';
import 'package:aniclient/features/anime/domain/entities/anime.dart';
import 'package:aniclient/features/anime/domain/repositories/anime_repository.dart';
import 'package:aniclient/features/anime/domain/usecases/get_airing_anime.dart';
import 'package:aniclient/features/anime/domain/usecases/get_anime_details.dart';
import 'package:aniclient/features/anime/domain/usecases/get_popular_anime.dart';
import 'package:aniclient/features/anime/domain/usecases/get_seasonal_anime.dart';
import 'package:aniclient/features/anime/domain/usecases/get_top_rated_anime.dart';
import 'package:aniclient/features/anime/domain/usecases/get_trending_anime.dart';
import 'package:aniclient/features/anime/domain/usecases/search_anime.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- DataSources ---
final aniListRemoteDataSourceProvider = Provider<AniListRemoteDataSource>((ref) {
  return AniListRemoteDataSource();
});

// --- Repositories ---
final animeRepositoryProvider = Provider<AnimeRepository>((ref) {
  final datasource = ref.watch(aniListRemoteDataSourceProvider);
  return AnimeRepositoryImpl(datasource);
});

// --- UseCases ---
final getTrendingAnimeProvider = Provider<GetTrendingAnime>((ref) {
  final repository = ref.watch(animeRepositoryProvider);
  return GetTrendingAnime(repository);
});

final getPopularAnimeProvider = Provider<GetPopularAnime>((ref) {
  final repository = ref.watch(animeRepositoryProvider);
  return GetPopularAnime(repository);
});

final getTopRatedAnimeProvider = Provider<GetTopRatedAnime>((ref) {
  final repository = ref.watch(animeRepositoryProvider);
  return GetTopRatedAnime(repository);
});

final getAiringAnimeUseCaseProvider = Provider<GetAiringAnime>((ref) {
  return GetAiringAnime(ref.watch(animeRepositoryProvider));
});

final getSeasonalAnimeUseCaseProvider = Provider<GetSeasonalAnime>((ref) {
  return GetSeasonalAnime(ref.watch(animeRepositoryProvider));
});

final searchAnimeProvider = Provider<SearchAnime>((ref) {
  final repository = ref.watch(animeRepositoryProvider);
  return SearchAnime(repository);
});

final getAnimeDetailsProvider = Provider<GetAnimeDetails>((ref) {
  final repository = ref.watch(animeRepositoryProvider);
  return GetAnimeDetails(repository);
});

// --- FutureProviders (State Management) ---
final trendingAnimeProvider = FutureProvider<List<Anime>>((ref) async {
  final usecase = ref.watch(getTrendingAnimeProvider);
  return usecase();
});

final popularAnimeProvider = FutureProvider<List<Anime>>((ref) async {
  final usecase = ref.watch(getPopularAnimeProvider);
  return usecase();
});

final topRatedAnimeProvider = FutureProvider<List<Anime>>((ref) async {
  final usecase = ref.watch(getTopRatedAnimeProvider);
  return usecase();
});

final airingAnimeProvider = FutureProvider<List<Anime>>((ref) async {
  final useCase = ref.watch(getAiringAnimeUseCaseProvider);
  return await useCase();
});

final seasonalAnimeProvider = FutureProvider<List<Anime>>((ref) async {
  final useCase = ref.watch(getSeasonalAnimeUseCaseProvider);
  return await useCase.execute();
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