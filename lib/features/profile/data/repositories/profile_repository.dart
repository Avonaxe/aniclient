import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aniclient/core/network/graphql_client.dart';
import 'package:aniclient/features/profile/domain/entities/user_profile.dart';

class ProfileRepository {
  final GraphQLClient _client = GraphQLClient();

  Future<UserProfile> getCurrentUserProfile() async {
    const query = '''
    query {
      Viewer {
        id
        name
        avatar {
          large
        }
        bannerImage
        statistics {
          anime {
            count
            minutesWatched
          }
        }
      }
    }
    ''';
    
    final data = await _client.query(query: query);
    
    if (data['Viewer'] == null) {
      throw Exception("User is not authenticated or viewer not found.");
    }
    
    return UserProfile.fromJson(data['Viewer']);
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  final repo = ref.watch(profileRepositoryProvider);
  return await repo.getCurrentUserProfile();
});
