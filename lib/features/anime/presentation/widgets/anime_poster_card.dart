import 'package:flutter/material.dart';

import '../../domain/entities/anime.dart';
import '../screens/anime_details_screen.dart';

class AnimePosterCard extends StatelessWidget {
  final Anime anime;

  const AnimePosterCard({
    super.key,
    required this.anime,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AnimeDetailsScreen(
              animeId: anime.id,
            ),
          ),
        );
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Poster
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                anime.coverImage,
                height: 200,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 6),

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
    );
  }
}