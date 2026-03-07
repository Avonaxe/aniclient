import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GraphQLClient {
  static const String baseUrl = "https://graphql.anilist.co";
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> query({
    required String query,
    Map<String, dynamic>? variables,
  }) async {
    final token = await _secureStorage.read(key: 'auth_token');
    
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    if (token != null) {
      headers["Authorization"] = "Bearer $token";
    }

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode({
        "query": query,
        if (variables != null) "variables": variables,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("GraphQL Error: ${response.statusCode} - ${response.body}");
    }

    final decoded = jsonDecode(response.body);
    
    if (decoded.containsKey('errors')) {
      throw Exception("GraphQL Error: ${decoded['errors'][0]['message']}");
    }

    return decoded['data'];
  }
}
