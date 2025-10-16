import 'package:v03/interfaces/i_powerstats.dart';

class Powerstats implements IPowerstats {
  @override
  final String strength;
  @override
  final String? intelligence;
  @override
  final String? speed;
  @override
  final String? durability;
  @override
  final String? power;
  @override
  final String? combat;

  const Powerstats({
    required this.strength,
    this.intelligence,
    this.speed,
    this.durability,
    this.power,
    this.combat,
  });

  int get strengthValue => int.tryParse(strength) ?? 0;

  factory Powerstats.fromMap(Map<String, dynamic> map) => Powerstats(
    strength: (map['strength'] ?? '').toString(),
    intelligence: map['intelligence']?.toString(),
    speed: map['speed']?.toString(),
    durability: map['durability']?.toString(),
    power: map['power']?.toString(),
    combat: map['combat']?.toString(),
  );

  @override
  Map<String, dynamic> toMap() => {
    'strength': strength,
    if (intelligence != null) 'intelligence': intelligence,
    if (speed != null) 'speed': speed,
    if (durability != null) 'durability': durability,
    if (power != null) 'power': power,
    if (combat != null) 'combat': combat,
  };
}
