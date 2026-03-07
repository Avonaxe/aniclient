import 'anime_character.dart';
import 'anime_staff.dart';

class Anime {
  final int id;
  final String title;
  final String coverImage;
  final String coverImage;
  final String? bannerImage;
  final double? averageScore;
  final int? episodes;
  final String? description;
  final List<String> genres;
  final String? studio;
  final int? nextAiringEpisode;
  final int? timeUntilAiring;
  final List<AnimeCharacter> characters;
  final List<AnimeStaff> staff;

  const Anime({
    required this.id,
    required this.title,
    required this.coverImage,
    this.bannerImage,
    this.averageScore,
    this.episodes,
    this.description,
    this.genres = const [],
    this.studio,
    this.nextAiringEpisode,
    this.timeUntilAiring,
    this.characters = const [],
    this.staff = const [],
  });
}