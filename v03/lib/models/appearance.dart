import '../interfaces/i_appearance.dart';

class Appearance implements IAppearance {
  @override
  final String gender;
  @override
  final String race;

  Appearance({required this.gender, required this.race});

  Map<String, dynamic> toMap() => {'gender': gender, 'race': race};

  factory Appearance.fromMap(Map<String, dynamic> map) => Appearance(
    gender: (map['gender'] ?? '').toString(),
    race: (map['race'] ?? '').toString(),
  );
}
