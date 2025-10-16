import 'package:v03/interfaces/i_hero_model.dart';

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

  const HeroModel({
    required this.id,
    required this.name,
    required this.powerstats,
    required this.appearance,
    this.biography,
    this.work,
    this.connections,
    this.image,
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
    );
  }

  factory HeroModel.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> powerstatsMap = {};
    if (map.containsKey('powerstats')) {
      powerstatsMap = Map<String, dynamic>.from(map['powerstats'] ?? {});
    } else if (map.containsKey('strength')) {
      powerstatsMap = {'strength': map['strength'].toString()};
    }

    return HeroModel(
      id: (map['id'] ?? 0) as int,
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
