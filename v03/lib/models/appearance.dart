import 'package:v03/interfaces/i_appearance.dart';

class Appearance implements IAppearance {
  @override
  final String gender;
  @override
  final String race;
  @override
  final List<String>? height;
  @override
  final List<String>? weight;
  @override
  final String? eyeColor;
  @override
  final String? hairColor;

  const Appearance({
    required this.gender,
    required this.race,
    this.height,
    this.weight,
    this.eyeColor,
    this.hairColor,
  });

  factory Appearance.fromMap(Map<String, dynamic> map) => Appearance(
    gender: (map['gender'] ?? '').toString(),
    race: (map['race'] ?? '').toString(),
    height: (map['height'] as List?)?.map((e) => e.toString()).toList(),
    weight: (map['weight'] as List?)?.map((e) => e.toString()).toList(),
    eyeColor: map['eye-color']?.toString(),
    hairColor: map['hair-color']?.toString(),
  );

  @override
  Map<String, dynamic> toMap() => {
    'gender': gender,
    'race': race,
    if (height != null) 'height': height,
    if (weight != null) 'weight': weight,
    if (eyeColor != null) 'eye-color': eyeColor,
    if (hairColor != null) 'hair-color': hairColor,
  };
}
