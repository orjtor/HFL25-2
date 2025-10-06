import 'powerstats.dart';
import 'appearance.dart';
import 'biography.dart';

class Superhero {
  final String name;
  final Powerstats powerstats;
  final Appearance appearance;
  final Biography? biography;

  Superhero({
    required this.name,
    required this.powerstats,
    required this.appearance,
    this.biography,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'powerstats': powerstats.toMap(),
    'appearance': appearance.toMap(),
    if (biography != null) 'biography': biography!.toMap(),
  };

  factory Superhero.fromMap(Map<String, dynamic> map) {
    final name = (map['name'] ?? '').toString();
    // Support both nested and legacy flat structure
    final powerstatsMap = map['powerstats'];
    Powerstats ps;
    if (powerstatsMap is Map) {
      ps = Powerstats.fromMap(Map<String, dynamic>.from(powerstatsMap));
    } else {
      // Legacy fallback: read 'strength' at top-level
      final legacyStrength = (map['strength'] as num?)?.toInt();
      ps = Powerstats(strength: (legacyStrength ?? 0).toString());
    }

    final appearanceMap = map['appearance'];
    final ap = appearanceMap is Map
        ? Appearance.fromMap(Map<String, dynamic>.from(appearanceMap))
        : Appearance(gender: '', race: '');

    Biography? bio;
    final bioMap = map['biography'];
    if (bioMap is Map) {
      bio = Biography.fromMap(Map<String, dynamic>.from(bioMap));
    } else {
      bio = null;
    }

    return Superhero(
      name: name,
      powerstats: ps,
      appearance: ap,
      biography: bio,
    );
  }

  @override
  String toString() {
    final parts = <String>[
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
