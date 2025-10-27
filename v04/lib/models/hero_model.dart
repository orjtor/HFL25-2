import 'package:v04/interfaces/i_hero_model.dart';

import 'powerstats.dart';
import 'appearance.dart';
import 'biography.dart';
import 'work.dart';
import 'connections.dart';
import 'image_model.dart';

class HeroModel implements IHeroModel {
  @override
  final int id;
  @override
  final String name;
  final int? apiId; // Ursprungligt API-ID (null för lokala hjältar)
  final String source; // "local" eller "api"
  @override
  final Powerstats powerstats;
  @override
  final Appearance appearance;
  @override
  final Biography? biography;
  @override
  final Work? work;
  @override
  final Connections? connections;
  @override
  final ImageModel? image;

  HeroModel({
    required this.id,
    required this.name,
    required this.powerstats,
    required this.appearance,
    this.biography,
    this.work,
    this.connections,
    this.image,
    this.apiId,
    this.source = "local",
  });

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'powerstats': powerstats.toMap(),
    'appearance': appearance.toMap(),
    if (biography != null) 'biography': biography!.toMap(),
    if (work != null) 'work': work!.toMap(),
    if (connections != null) 'connections': connections!.toMap(),
    if (image != null) 'image': image!.toMap(),
    if (apiId != null) 'apiId': apiId,
    'source': source,
  };

  HeroModel copyWith({
    int? id,
    String? name,
    Powerstats? powerstats,
    Appearance? appearance,
    Biography? biography,
    Work? work,
    Connections? connections,
    ImageModel? image,
    int? apiId,
    String? source,
  }) {
    return HeroModel(
      id: id ?? this.id,
      name: name ?? this.name,
      powerstats: powerstats ?? this.powerstats,
      appearance: appearance ?? this.appearance,
      biography: biography ?? this.biography,
      work: work ?? this.work,
      connections: connections ?? this.connections,
      image: image ?? this.image,
      apiId: apiId ?? this.apiId,
      source: source ?? this.source,
    );
  }

  factory HeroModel.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> powerstatsMap = {};
    if (map.containsKey('powerstats')) {
      powerstatsMap = Map<String, dynamic>.from(map['powerstats'] ?? {});
    } else if (map.containsKey('strength')) {
      powerstatsMap = {'strength': map['strength'].toString()};
    }

    final originalApiId = int.tryParse(map['id']?.toString() ?? '0') ?? 0;
    final isFromApi = map['source'] == 'api' || map.containsKey('apiId');

    return HeroModel(
      id: int.tryParse(map['id']?.toString() ?? '0') ?? 0,
      name: (map['name'] ?? '').toString(),
      powerstats: Powerstats.fromMap(powerstatsMap),
      appearance: Appearance.fromMap(
        Map<String, dynamic>.from(map['appearance'] ?? {}),
      ),
      biography: map['biography'] != null
          ? Biography.fromMap(Map<String, dynamic>.from(map['biography']))
          : null,
      work: map['work'] != null
          ? Work.fromMap(Map<String, dynamic>.from(map['work']))
          : null,
      connections: map['connections'] != null
          ? Connections.fromMap(Map<String, dynamic>.from(map['connections']))
          : null,
      image: map['image'] != null
          ? ImageModel.fromMap(Map<String, dynamic>.from(map['image']))
          : null,
      apiId: isFromApi ? (map['apiId'] ?? originalApiId) : null,
      source: map['source']?.toString() ?? (isFromApi ? 'api' : 'local'),
    );
  }

  @override
  String toString() {
    final parts = <String>[
      'ID: $id',
      name,
      '(str: ${powerstats.strength})',
      '${appearance.gender}, ${appearance.race}',
    ];
    final align = biography?.alignment;
    if (align != null && align.isNotEmpty) {
      parts.add('align: $align');
    }
    return parts.join(' | ');
  }
}
