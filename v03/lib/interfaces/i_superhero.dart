import 'i_powerstats.dart';
import 'i_appearance.dart';
import 'i_biography.dart';

abstract class ISuperhero {
  String get name;
  IPowerstats get powerstats;
  IAppearance get appearance;
  IBiography? get biography;

  Map<String, dynamic> toMap();
}
