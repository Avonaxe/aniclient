import 'package:flutter/material.dart';

import '../../domain/entities/anime.dart';
import '../screens/anime_details_screen.dart';

class AnimePosterCard extends StatelessWidget {
  final Anime anime;
  final String heroTagContext;

  const AnimePosterCard({
    super.key,
    required this.anime,
    required this.heroTagContext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AnimeDetailsScreen(
                  animeId: anime.id,
                  heroTagContext: heroTagContext,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster
              Hero(
                tag: 'anime_poster_${anime.id}_$heroTagContext',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    anime.coverImage,
                    height: 180,
                    width: 120,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        height: 180,
                        width: 120,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
              anime.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "⭐ ${anime.averageScore ?? "N/A"}",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}