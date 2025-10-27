import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dotenv/dotenv.dart';

import '../models/hero_model.dart';

class ApiService {
  // Singleton pattern
  ApiService._();
  static final ApiService _instance = ApiService._();
  factory ApiService() => _instance;

  late final String _baseUrl;
  late final String _apiToken;
  bool _initialized = false;

  /// Initialize API configuration from .env file
  void initialize() {
    if (_initialized) return;

    var env = DotEnv()..load();
    _baseUrl = env['SUPERHERO_API_BASE_URL'] ?? 'https://superheroapi.com/api';
    _apiToken = env['SUPERHERO_API_TOKEN'] ?? '';

    if (_apiToken.isEmpty) {
      stderr.writeln('VARNING: SUPERHERO_API_TOKEN saknas i .env fil');
    }

    _initialized = true;
  }

  /// Search for heroes by name
  Future<List<HeroModel>> searchHeroes(String query) async {
    initialize();

    if (_apiToken.isEmpty) {
      throw Exception('API token saknas i .env fil');
    }

    if (query.trim().isEmpty) {
      return [];
    }

    try {
      final url = '$_baseUrl/$_apiToken/search/${Uri.encodeComponent(query)}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('HTTP fel: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);

      // Handle different response formats
      if (data['response'] == 'success') {
        if (data['results'] is List) {
          // Multiple results
          final List results = data['results'];
          return results.map((heroData) => _createApiHero(heroData)).toList();
        } else {
          // Single result (shouldn't happen with search, but just in case)
          return [_createApiHero(data)];
        }
      } else if (data['response'] == 'error') {
        final errorMsg = data['error'] ?? 'Okänt API-fel';
        throw Exception('API-fel: $errorMsg');
      } else {
        throw Exception('Oväntat API-responsformat');
      }
    } catch (e) {
      stderr.writeln('API-anrop misslyckades: $e');
      rethrow;
    }
  }

  /// Get hero by ID
  Future<HeroModel?> getHeroById(int id) async {
    initialize();

    if (_apiToken.isEmpty) {
      throw Exception('API token saknas i .env fil');
    }

    try {
      final url = '$_baseUrl/$_apiToken/$id';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('HTTP fel: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);

      if (data['response'] == 'success') {
        return _createApiHero(data);
      } else if (data['response'] == 'error') {
        final errorMsg = data['error'] ?? 'Okänt API-fel';
        throw Exception('API-fel: $errorMsg');
      } else {
        throw Exception('Oväntat API-responsformat');
      }
    } catch (e) {
      stderr.writeln('API-anrop misslyckades: $e');
      rethrow;
    }
  }

  /// Check if API is configured and ready
  bool get isConfigured {
    initialize();
    return _apiToken.isNotEmpty;
  }

  /// Get API status info
  String get statusInfo {
    initialize();
    return 'Base URL: $_baseUrl\nAPI Token: ${_apiToken.isEmpty ? "SAKNAS" : "OK"}';
  }

  /// Create a HeroModel from API data with correct source and apiId
  HeroModel _createApiHero(Map<String, dynamic> apiData) {
    final originalId = int.tryParse(apiData['id']?.toString() ?? '0') ?? 0;

    // Add source and apiId to the data
    final enrichedData = Map<String, dynamic>.from(apiData);
    enrichedData['source'] = 'api';
    enrichedData['apiId'] = originalId;

    return HeroModel.fromMap(enrichedData);
  }
}
