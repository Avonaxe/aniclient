import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthRepository {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Your Client ID from AniList Developer Settings
  static const String _clientId = "YOUR_CLIENT_ID_HERE";
  
  // Custom scheme redirect matching the AniList settings
  static const String _redirectUri = "aniclient://callback"; 

  static const String _authUrl = 
      "https://anilist.co/api/v2/oauth/authorize?client_id=$_clientId&response_type=token";

  Future<void> login() async {
    final Uri url = Uri.parse(_authUrl);
    
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // Opens external browser for secure OAuth
      );
    } else {
      throw Exception("Could not launch authenticator.");
    }
  }

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'auth_token');
  }
}
