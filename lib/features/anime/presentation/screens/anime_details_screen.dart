import 'package:aniclient/features/anime/domain/entities/anime.dart';
import 'package:aniclient/features/anime/presentation/providers/anime_providers.dart';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AnimeDetailsScreen extends ConsumerWidget {
  final int animeId;
  final String heroTagContext;

  const AnimeDetailsScreen({
    super.key, 
    required this.animeId,
    required this.heroTagContext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animeAsync = ref.watch(animeDetailsProvider(animeId));

    return Scaffold(
      body: animeAsync.when(
        data: (Anime anime) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: anime.bannerImage != null ? 220 : 300,
                pinned: true,
                backgroundColor: const Color(0xFF2B2D42),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Banner or Cover
                      CachedNetworkImage(
                        imageUrl: anime.bannerImage ?? anime.coverImage,
                        fit: BoxFit.cover,
                        alignment: anime.bannerImage != null
                            ? Alignment.center
                            : Alignment.topCenter,
                      ),
                      // Gradient overlay for text readability
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              const Color(0xFF141519).withOpacity(0.9),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Poster
                      Transform.translate(
                        offset: const Offset(0, -60),
                        child: Hero(
                          tag: 'anime_poster_${anime.id}_$heroTagContext',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: anime.coverImage,
                              width: 120,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Title and Studio
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Text(
                              anime.title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (anime.studio != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                anime.studio!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF00A8E1),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats Row
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF21232D),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(Icons.star, Colors.amber, "${anime.averageScore ?? 'N/A'}%"),
                            _buildStatItem(Icons.tv, Colors.white, "${anime.episodes ?? '?'} Eps"),
                            if (anime.nextAiringEpisode != null)
                              _buildStatItem(Icons.calendar_today, const Color(0xFF00A8E1), "Ep ${anime.nextAiringEpisode}"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Genres
                      if (anime.genres.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: anime.genres.map((g) => Chip(
                                label: Text(g, style: const TextStyle(fontSize: 12)),
                                backgroundColor: const Color(0xFF2B2D42),
                                side: BorderSide.none,
                              )).toList(),
                        ),
                      const SizedBox(height: 24),
                          Text(
                            "${anime.averageScore ?? 'N/A'}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 24),
                          const Icon(Icons.tv, color: Colors.grey, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            "${anime.episodes ?? '?'} Episodes",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                      // Synopsis
                      const SizedBox(height: 16),
                      const Text(
                        "Synopsis",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Html(
                        data: anime.description ?? "No description available.",
                        style: {
                          "body": Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                            fontSize: FontSize(15),
                            lineHeight: LineHeight.em(1.5),
                            color: const Color(0xFFA0B1C5),
                          ),
                        },
                      ),
                      
                      // Characters
                      if (anime.characters.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Text(
                          "Characters",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 140,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: anime.characters.length,
                            itemBuilder: (context, index) {
                              final char = anime.characters[index];
                              return Container(
                                width: 90,
                                margin: const EdgeInsets.only(right: 12),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage: CachedNetworkImageProvider(char.image),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      char.name,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],

                      // Staff
                      if (anime.staff.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Text(
                          "Staff",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 140,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: anime.staff.length,
                            itemBuilder: (context, index) {
                              final staff = anime.staff[index];
                              return Container(
                                width: 90,
                                margin: const EdgeInsets.only(right: 12),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage: CachedNetworkImageProvider(staff.image),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      staff.name,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],

                      const SizedBox(height: 48), // Bottom padding
                    ],
                  ),
                ),
              ),
            ],
          );
        },

        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),

        error: (error, stack) => Scaffold(body: Center(child: Text("Error: $error"))),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, Color iconColor, String text) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
