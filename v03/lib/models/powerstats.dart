import '../interfaces/i_powerstats.dart';

class Powerstats implements IPowerstats {
  @override
  final String strength;

  Powerstats({required this.strength});

  Map<String, dynamic> toMap() => {'strength': strength};

  factory Powerstats.fromMap(Map<String, dynamic> map) =>
      Powerstats(strength: (map['strength'] ?? '').toString());

  int get strengthValue => int.tryParse(strength) ?? 0;
}
