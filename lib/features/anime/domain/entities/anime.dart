class Anime {
  final int id;
  final String title;
  final String coverImage;
  final double? averageScore;
  final int? episodes;
  final String? description;

  const Anime({
    required this.id,
    required this.title,
    required this.coverImage,
    this.averageScore,
    this.episodes,
    this.description,
  });
}