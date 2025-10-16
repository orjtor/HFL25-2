abstract class IBiography {
  String? get fullName;
  String? get alterEgos;
  List<String>? get aliases;
  String? get placeOfBirth;
  String? get firstAppearance;
  String? get publisher;
  String? get alignment;

  Map<String, dynamic> toMap();
}
