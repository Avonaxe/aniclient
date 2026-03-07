import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aniclient/features/auth/data/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

class AuthNotifier extends Notifier<bool> {
  late AuthRepository _repository;

  @override
  bool build() {
    _repository = ref.watch(authRepositoryProvider);
    _checkStatus();
    return false; // Initial state while checking
  }

  Future<void> _checkStatus() async {
    final token = await _repository.getToken();
    state = token != null;
  }

  Future<void> login() async {
    await _repository.login();
  }

  void continueAsGuest() {
    state = true;
  }

  Future<void> saveTokenFromUri(Uri uri) async {
    final fragment = uri.fragment;
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

final authProvider = NotifierProvider<AuthNotifier, bool>(() {
  return AuthNotifier();
});
