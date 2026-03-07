import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

class AuthNotifier extends StateNotifier<bool> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(false) {
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final token = await _repository.getToken();
    state = token != null;
  }

  Future<void> login() async {
    await _repository.login();
    // The redirect will hit AndroidManifest/Info.plist intents and reopen the app.
    // The main.dart or a global listener will intercept the URI to save the token.
  }

  Future<void> saveTokenFromUri(Uri uri) async {
    final fragment = uri.fragment; // AniList returns the token in the URL fragment (#access_token=...)
    if (fragment.isNotEmpty) {
      final params = Uri.splitQueryString(fragment);
      final token = params['access_token'];
      if (token != null) {
        await _repository.saveToken(token);
        state = true;
      }
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = false;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
