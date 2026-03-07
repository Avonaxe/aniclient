import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aniclient/core/network/graphql_client.dart';
import 'package:aniclient/features/profile/data/repositories/profile_repository.dart';
import 'package:aniclient/features/anime/data/models/anime_model.dart';
import 'package:aniclient/features/library/domain/entities/user_anime_list.dart';

class LibraryRepository {
  final GraphQLClient _client = GraphQLClient();
  final ProfileRepository _profileRepo;

  LibraryRepository(this._profileRepo);

  Future<List<UserAnimeList>> getUserAnimeLists() async {
    final user = await _profileRepo.getCurrentUserProfile();
    
    const query = '''
    query (\$userId: Int) {
      MediaListCollection(userId: \$userId, type: ANIME) {
        lists {
          name
          isCustomList
          entries {
            id
            status
            progress
            media {
              id
              title {
                romaji
                english
              }
              coverImage {
                large
              }
              averageScore
              episodes
            }
          }
        }
      }
    }
    ''';

    final data = await _client.query(
      query: query,
      variables: {"userId": user.id},
    );

    final List listsJson = data['MediaListCollection']['lists'];

    return listsJson.map((listJson) {
      final List entriesJson = listJson['entries'];
      
      return UserAnimeList(
        name: listJson['name'],
        isCustomList: listJson['isCustomList'],
        entries: entriesJson.map((e) {
          return AnimeListEntry(
            id: e['id'],
            status: e['status'],
            progress: e['progress'] ?? 0,
            anime: AnimeModel.fromJson(e['media']),
          );
        }).toList(),
      );
    }).toList();
  }
}

final libraryRepositoryProvider = Provider<LibraryRepository>((ref) {
  final profileRepo = ref.watch(profileRepositoryProvider);
  return LibraryRepository(profileRepo);
});

final userAnimeListsProvider = FutureProvider<List<UserAnimeList>>((ref) async {
  final repo = ref.watch(libraryRepositoryProvider);
  return await repo.getUserAnimeLists();
});
