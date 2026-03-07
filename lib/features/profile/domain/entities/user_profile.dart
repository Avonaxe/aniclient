class UserProfile {
  final int id;
  final String name;
  final String avatarUrl;
  final String bannerUrl;
  final int totalAnimeWatched;
  final int daysWatched;

  const UserProfile({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.bannerUrl,
    required this.totalAnimeWatched,
    required this.daysWatched,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'] ?? '',
      avatarUrl: json['avatar']['large'] ?? '',
      bannerUrl: json['bannerImage'] ?? '',
      totalAnimeWatched: json['statistics']?['anime']?['count'] ?? 0,
      daysWatched: (json['statistics']?['anime']?['minutesWatched'] ?? 0) ~/ 1440,
    );
  }
}
