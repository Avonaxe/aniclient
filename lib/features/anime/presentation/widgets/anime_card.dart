import 'package:flutter/material.dart';

import '../../domain/entities/anime.dart';
import '../screens/anime_details_screen.dart';

class AnimeCard extends StatelessWidget {
  final Anime anime;

  const AnimeCard({
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

      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),

        child: Row(
          children: [

            // COVER IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
              child: Image.network(
                anime.coverImage,
                width: 100,
                height: 140,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            // TEXT INFO
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      anime.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Score: ${anime.averageScore ?? "N/A"}",
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Episodes: ${anime.episodes ?? "Unknown"}",
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}