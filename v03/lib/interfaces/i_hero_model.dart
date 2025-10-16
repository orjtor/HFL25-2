import 'i_powerstats.dart';
import 'i_appearance.dart';
import 'i_biography.dart';
import 'i_work.dart';
import 'i_connections.dart';
import 'i_image_model.dart';

abstract class IHeroModel {
  int get id;
  String get name;
  IPowerstats get powerstats;
  IAppearance get appearance;
  IBiography? get biography;
  IWork? get work;
  IConnections? get connections;
  IImageModel? get image;

  Map<String, dynamic> toMap();
}
