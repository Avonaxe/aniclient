import '../../domain/entities/anime.dart';

class AnimeModel extends Anime {
  const AnimeModel({
    required super.id,
    required super.title,
    required super.coverImage,
    super.averageScore,
    super.episodes,
    super.description,
  });

  factory AnimeModel.fromJson(Map<String, dynamic> json) {
    return AnimeModel(
      id: json['id'],
      title: json['title']['romaji'] ?? '',
      coverImage: json['coverImage']['large'] ?? '',
      averageScore: (json['averageScore'] as num?)?.toDouble(),
      episodes: json['episodes'],
      description: json['description'],
    );
  }
}