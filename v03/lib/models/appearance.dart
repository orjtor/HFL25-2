class Appearance {
  final String gender;
  final String race;

  Appearance({required this.gender, required this.race});

  Map<String, dynamic> toMap() => {'gender': gender, 'race': race};

  factory Appearance.fromMap(Map<String, dynamic> map) => Appearance(
    gender: (map['gender'] ?? '').toString(),
    race: (map['race'] ?? '').toString(),
  );
}
