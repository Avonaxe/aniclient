import '../../anime/domain/entities/anime.dart';

class AnimeListEntry {
  final int id;
  final String status;
  final int progress;
  final Anime anime;

  const AnimeListEntry({
    required this.id,
    required this.status,
    required this.progress,
    required this.anime,
  });
}

class UserAnimeList {
  final String name;
  final bool isCustomList;
  final List<AnimeListEntry> entries;

  const UserAnimeList({
    required this.name,
    required this.isCustomList,
    required this.entries,
  });
}
