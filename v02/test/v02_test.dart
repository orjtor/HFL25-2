import 'package:v02/v02.dart';
import 'package:test/test.dart';

void main() {
  group('Hero', () {
    test('toMap and fromMap', () {
      final hero = Hero(name: 'Batman', power: 'Money', strength: 85);
      final map = hero.toMap();
      expect(map, {'name': 'Batman', 'power': 'Money', 'strength': 85});

      final newHero = Hero.fromMap(map);
      expect(newHero.name, 'Batman');
      expect(newHero.power, 'Money');
      expect(newHero.strength, 85);
    });

    test('fromMap with missing fields', () {
      final map = {'name': 'Superman'};
      final hero = Hero.fromMap(map);
      expect(hero.name, 'Superman');
      expect(hero.power, '');
      expect(hero.strength, 0);
    });
  });
}
