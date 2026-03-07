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
      id: json['id'] as int,
      name: (json['name'] ?? '') as String,
      avatarUrl: (json['avatar']?['large'] ?? '') as String,
      bannerUrl: (json['bannerImage'] ?? '') as String,
      totalAnimeWatched: (json['statistics']?['anime']?['count'] ?? 0) as int,
      daysWatched: ((json['statistics']?['anime']?['minutesWatched'] ?? 0) as int) ~/ 1440,
    );
  }
}
