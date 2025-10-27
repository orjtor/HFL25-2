import 'dart:convert';
import 'dart:io';

import 'package:v04/managers/hero_data_managing.dart';
import 'package:v04/models/models.dart';
import 'package:v04/services/api_service.dart';

class HeroDataManager implements HeroDataManaging {
  // Singleton
  HeroDataManager._();
  static final HeroDataManager _instance = HeroDataManager._();
  factory HeroDataManager() => _instance;
  final String storageFileName = 'superheros.json';

  // Lagring
  late final File _file = File(storageFileName);

  @override
  List<HeroModel> heroes = [];

  @override
  Future<void> load() async {
    try {
      if (!await _file.exists()) return;
      final content = await _file.readAsString(encoding: utf8);
      if (content.trim().isEmpty) return;

      final raw = jsonDecode(content);
      if (raw is List) {
        heroes
          ..clear()
          ..addAll(
            raw.whereType<Map>().map(
              (m) => HeroModel.fromMap(Map<String, dynamic>.from(m)),
            ),
          );
      }
    } catch (e) {
      stderr.writeln('Kunde inte läsa $storageFileName: $e');
    }
  }

  @override
  Future<void> save() async {
    try {
      final data = heroes.map((h) => h.toMap()).toList();
      await _file.writeAsString(jsonEncode(data), encoding: utf8);
    } catch (e) {
      stderr.writeln('Kunde inte spara $storageFileName: $e');
    }
  }

  int _nextId() {
    if (heroes.isEmpty) return 1;
    return heroes.map((h) => h.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  @override
  Future<void> saveHero(HeroModel hero) async {
    // Check for duplicates based on name + publisher
    if (_isDuplicate(hero)) {
      final publisher = hero.biography?.publisher ?? "okänd publisher";
      stderr.writeln('Hjälte "${hero.name}" finns redan ($publisher)');
      return;
    }

    final heroWithId = hero.copyWith(
      id: _nextId(),
      // Behåll source och apiId som redan är satta
      source: hero.source,
      apiId: hero.apiId,
    );
    heroes.add(heroWithId);
    await save();
    print('Hjälte "${hero.name}" sparad!');
  }

  /// Check if hero already exists (same name + publisher)
  bool _isDuplicate(HeroModel newHero) {
    final newName = newHero.name.toLowerCase().trim();
    final newPublisher =
        newHero.biography?.publisher?.toLowerCase().trim() ?? '';

    return heroes.any((existing) {
      final existingName = existing.name.toLowerCase().trim();
      final existingPublisher =
          existing.biography?.publisher?.toLowerCase().trim() ?? '';

      // Same name and same publisher = duplicate
      if (newName == existingName && newPublisher == existingPublisher) {
        return true;
      }

      // Special case: if from API, check if same apiId
      if (newHero.source == 'api' &&
          existing.source == 'api' &&
          newHero.apiId != null &&
          existing.apiId != null) {
        return newHero.apiId == existing.apiId;
      }

      return false;
    });
  }

  @override
  Future<List<HeroModel>> getHeroList() async {
    // Returnera en kopia för att undvika extern mutation
    return List<HeroModel>.unmodifiable(heroes);
  }

  @override
  Future<List<HeroModel>> searchHero(String query) async {
    if (query.trim().isEmpty) return [];

    final lowerQuery = query.toLowerCase();
    return heroes
        .where((h) => h.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  @override
  Future<List<HeroModel>> searchHeroApi(String query) async {
    final apiService = ApiService();

    if (!apiService.isConfigured) {
      stderr.writeln('API inte konfigurerat. Kolla .env filen.');
      return [];
    }

    try {
      return await apiService.searchHeroes(query);
    } catch (e) {
      stderr.writeln('API-sökning misslyckades: $e');
      return [];
    }
  }

  @override
  Future<void> showHero(HeroModel hero, bool showFooter) async {
    print('\n====================== Hjältedetaljer ======================');
    print(
      'ID: ${hero.id} | Källa: ${hero.source} ${hero.apiId != null ? '| API ID: ${hero.apiId}' : ''}',
    );
    print('Namn: ${hero.name}');

    print('\n--- Powerstats ---');
    print('Styrka: ${hero.powerstats.strength}');
    print('Intelligens: ${hero.powerstats.intelligence ?? ''}');
    print('Speed: ${(hero.powerstats as dynamic).speed ?? ''}');
    print('Durability: ${(hero.powerstats as dynamic).durability ?? ''}');
    print('Power: ${(hero.powerstats as dynamic).power ?? ''}');
    print('Combat: ${(hero.powerstats as dynamic).combat ?? ''}');

    print('\n--- Appearance ---');
    print('Kön: ${hero.appearance.gender}');
    print('Ras: ${hero.appearance.race}');
    print('Längd: ${(hero.appearance as dynamic).height ?? ''}');
    print('Vikt: ${(hero.appearance as dynamic).weight ?? ''}');
    print('Ögonfärg: ${(hero.appearance as dynamic).eyeColor ?? ''}');
    print('Hårfärg: ${(hero.appearance as dynamic).hairColor ?? ''}');

    print('\n--- Biography ---');
    print('Full Name: ${hero.biography?.fullName ?? ''}');
    print('Alter Egos: ${hero.biography?.alterEgos ?? ''}');
    print('Aliases: ${hero.biography?.aliases?.join(", ") ?? ''}');
    print('Place of Birth: ${hero.biography?.placeOfBirth ?? ''}');
    print('First Appearance: ${hero.biography?.firstAppearance ?? ''}');
    print('Publisher: ${hero.biography?.publisher ?? ''}');
    print('Alignment: ${hero.biography?.alignment ?? ''}');

    print('\n--- Work ---');
    print('Occupation: ${hero.work?.occupation ?? ''}');
    print('Base: ${hero.work?.base ?? ''}');

    print('\n--- Connections ---');
    print('Group Affiliation: ${hero.connections?.groupAffiliation ?? ''}');
    print('Relatives: ${hero.connections?.relatives ?? ''}');

    print('\n--- Image ---');
    print('Bild-URL: ${hero.image?.url ?? ''}');

    print('==============================================================');

    if (showFooter) {
      print('Tryck Enter för att gå tillbaka till sökresultat.');
    }
  }
}
