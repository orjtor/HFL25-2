import 'package:v03/interfaces/i_biography.dart';

class Biography implements IBiography {
  @override
  final String? fullName;
  @override
  final String? alterEgos;
  @override
  final List<String>? aliases;
  @override
  final String? placeOfBirth;
  @override
  final String? firstAppearance;
  @override
  final String? publisher;
  @override
  final String? alignment;

  const Biography({
    this.fullName,
    this.alterEgos,
    this.aliases,
    this.placeOfBirth,
    this.firstAppearance,
    this.publisher,
    this.alignment,
  });

  factory Biography.fromMap(Map<String, dynamic> map) => Biography(
    fullName: map['full-name']?.toString(),
    alterEgos: map['alter-egos']?.toString(),
    aliases: (map['aliases'] as List?)?.map((e) => e.toString()).toList(),
    placeOfBirth: map['place-of-birth']?.toString(),
    firstAppearance: map['first-appearance']?.toString(),
    publisher: map['publisher']?.toString(),
    alignment: map['alignment']?.toString(),
  );

  @override
  Map<String, dynamic> toMap() => {
    if (fullName != null) 'full-name': fullName,
    if (alterEgos != null) 'alter-egos': alterEgos,
    if (aliases != null) 'aliases': aliases,
    if (placeOfBirth != null) 'place-of-birth': placeOfBirth,
    if (firstAppearance != null) 'first-appearance': firstAppearance,
    if (publisher != null) 'publisher': publisher,
    if (alignment != null) 'alignment': alignment,
  };
}
