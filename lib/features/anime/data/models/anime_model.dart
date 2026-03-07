import '../../domain/entities/anime.dart';
import '../../domain/entities/anime_character.dart';
import '../../domain/entities/anime_staff.dart';

class AnimeModel extends Anime {
  const AnimeModel({
    required super.id,
    required super.title,
    required super.coverImage,
    super.bannerImage,
    super.averageScore,
    super.episodes,
    super.description,
    super.genres,
    super.studio,
    super.nextAiringEpisode,
    super.timeUntilAiring,
    super.characters,
    super.staff,
  });

  factory AnimeModel.fromJson(Map<String, dynamic> json) {
    // Parse Studio
    String? studioStr;
    if (json['studios'] != null && json['studios']['nodes'] != null) {
      final nodes = json['studios']['nodes'] as List;
      if (nodes.isNotEmpty) {
        studioStr = nodes.first['name'];
      }
    }

    // Parse Next Airing Episode
    int? nextEpisode;
    int? timeUntil;
    if (json['nextAiringEpisode'] != null) {
      nextEpisode = json['nextAiringEpisode']['episode'];
      timeUntil = json['nextAiringEpisode']['timeUntilAiring'];
    }

    // Parse Characters
    List<AnimeCharacter> chars = [];
    if (json['characters'] != null && json['characters']['edges'] != null) {
      for (var edge in json['characters']['edges']) {
        final node = edge['node'];
        if (node != null) {
          chars.add(AnimeCharacter(
            id: node['id'],
            name: node['name']['userPreferred'] ?? node['name']['full'] ?? '',
            image: node['image']['large'] ?? '',
            role: edge['role'] ?? '',
          ));
        }
      }
    }

    // Parse Staff
    List<AnimeStaff> staffList = [];
    if (json['staff'] != null && json['staff']['edges'] != null) {
      for (var edge in json['staff']['edges']) {
        final node = edge['node'];
        if (node != null) {
          staffList.add(AnimeStaff(
            id: node['id'],
            name: node['name']['userPreferred'] ?? node['name']['full'] ?? '',
            image: node['image']['large'] ?? '',
            primaryOccupations: (node['primaryOccupations'] as List?)?.join(', ') ?? '',
          ));
        }
      }
    }

    return AnimeModel(
      id: json['id'],
      title: json['title']['romaji'] ?? json['title']['english'] ?? '',
      coverImage: json['coverImage']['large'] ?? '',
      bannerImage: json['bannerImage'],
      averageScore: (json['averageScore'] as num?)?.toDouble(),
      episodes: json['episodes'],
      description: json['description'],
      genres: (json['genres'] as List?)?.map((e) => e.toString()).toList() ?? [],
      studio: studioStr,
      nextAiringEpisode: nextEpisode,
      timeUntilAiring: timeUntil,
      characters: chars,
      staff: staffList,
    );
  }
}