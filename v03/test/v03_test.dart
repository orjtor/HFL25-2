import 'package:v03/v03.dart';
import 'package:test/test.dart';

void main() {
  group('Hero', () {
    test('toMap and fromMap (nested)', () {
      final hero = Superhero(
        name: 'Batman',
        powerstats: Powerstats(strength: '85'),
        appearance: Appearance(gender: 'Male', race: 'Human'),
        biography: Biography(alignment: 'good'),
      );
      final map = hero.toMap();
      expect(map, {
        'name': 'Batman',
        'powerstats': {'strength': '85'},
        'appearance': {'gender': 'Male', 'race': 'Human'},
        'biography': {'alignment': 'good'},
      });

      final newHero = Superhero.fromMap(map);
      expect(newHero.name, 'Batman');
      expect(newHero.powerstats.strength, '85');
      expect(newHero.appearance.gender, 'Male');
      expect(newHero.appearance.race, 'Human');
      expect(newHero.biography?.alignment, 'good');
    });

    test('fromMap legacy fallback (flat strength)', () {
      final map = {'name': 'Superman', 'strength': 99};
      final hero = Superhero.fromMap(map);
      expect(hero.name, 'Superman');
      expect(hero.powerstats.strength, '99');
      expect(hero.appearance.gender, '');
      expect(hero.appearance.race, '');
      expect(hero.biography, isNull);
    });
  });
}
