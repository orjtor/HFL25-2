abstract class IAppearance {
  String get gender;
  String get race;
  List<String>? get height;
  List<String>? get weight;
  String? get eyeColor;
  String? get hairColor;

  Map<String, dynamic> toMap();
}
