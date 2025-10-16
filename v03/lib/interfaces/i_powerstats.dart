abstract class IPowerstats {
  String get strength;
  String? get intelligence;
  String? get speed;
  String? get durability;
  String? get power;
  String? get combat;

  Map<String, dynamic> toMap();
}
