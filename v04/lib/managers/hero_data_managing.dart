import 'package:v04/models/models.dart';

abstract class HeroDataManaging {
  List<HeroModel> get heroes;

  Future<void> load();
  Future<void> save();

  Future<void> saveHero(HeroModel hero);
  Future<List<HeroModel>> getHeroList();
  Future<List<HeroModel>> searchHero(String query);
  Future<void> showHero(HeroModel hero);
  Future<List<HeroModel>> searchHeroApi(String query);
}
