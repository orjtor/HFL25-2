import 'package:v04/v04.dart';
import 'package:test/test.dart';

void main() {
  group('HeroModel', () {
    test('toMap and fromMap (nested)', () {
      final hero = HeroModel(
        id: 1,
        name: 'Batman',
        powerstats: Powerstats(strength: '85'),
        appearance: Appearance(gender: 'Male', race: 'Human'),
        biography: Biography(alignment: 'good'),
      );
      final map = hero.toMap();
      expect(map, {
        'id': 1,
        'name': 'Batman',
        'powerstats': {'strength': '85'},
        'appearance': {'gender': 'Male', 'race': 'Human'},
        'biography': {'alignment': 'good'},
        'source': 'local',
      });

      final newHero = HeroModel.fromMap(map);
      expect(newHero.name, 'Batman');
      expect(newHero.powerstats.strength, '85');
      expect(newHero.appearance.gender, 'Male');
      expect(newHero.appearance.race, 'Human');
      expect(newHero.biography?.alignment, 'good');
      expect(newHero.source, 'local');
      expect(newHero.apiId, isNull);
    });

    test('fromMap legacy fallback (flat strength)', () {
      final map = {'id': 2, 'name': 'Superman', 'strength': 99};
      final hero = HeroModel.fromMap(map);
      expect(hero.name, 'Superman');
      expect(hero.powerstats.strength, '99');
      expect(hero.appearance.gender, '');
      expect(hero.appearance.race, '');
      expect(hero.biography, isNull);
      expect(hero.source, 'local');
    });

    test('API hero with source and apiId', () {
      final map = {
        'id': '70',
        'name': 'Batman',
        'powerstats': {'strength': '26', 'intelligence': '100'},
        'appearance': {'gender': 'Male', 'race': 'Human'},
        'biography': {'publisher': 'DC Comics', 'alignment': 'good'},
        'source': 'api',
        'apiId': 70,
      };

      final hero = HeroModel.fromMap(map);
      expect(hero.name, 'Batman');
      expect(hero.id, 70);
      expect(hero.source, 'api');
      expect(hero.apiId, 70);
      expect(hero.biography?.publisher, 'DC Comics');
    });

    test('full hero with all optional fields', () {
      final hero = HeroModel(
        id: 1,
        name: 'Superman',
        powerstats: Powerstats(
          strength: '100',
          intelligence: '94',
          speed: '100',
          durability: '100',
          power: '100',
          combat: '85',
        ),
        appearance: Appearance(
          gender: 'Male',
          race: 'Kryptonian',
          height: ['6\'3', '191 cm'],
          weight: ['225 lb', '101 kg'],
          eyeColor: 'Blue',
          hairColor: 'Black',
        ),
        biography: Biography(
          fullName: 'Clark Kent',
          publisher: 'DC Comics',
          alignment: 'good',
          aliases: ['Man of Steel', 'Last Son of Krypton'],
        ),
        work: Work(occupation: 'Reporter', base: 'Metropolis'),
        connections: Connections(
          groupAffiliation: 'Justice League',
          relatives: 'Lois Lane (wife)',
        ),
        image: ImageModel(url: 'https://example.com/superman.jpg'),
        source: 'api',
        apiId: 644,
      );

      final map = hero.toMap();
      expect(map['name'], 'Superman');
      expect(map['source'], 'api');
      expect(map['apiId'], 644);
      expect(map['work']['occupation'], 'Reporter');
      expect(map['connections']['group-affiliation'], 'Justice League');
      expect(map['image']['url'], 'https://example.com/superman.jpg');

      final reconstructed = HeroModel.fromMap(map);
      expect(reconstructed.name, hero.name);
      expect(reconstructed.source, hero.source);
      expect(reconstructed.apiId, hero.apiId);
      expect(reconstructed.work?.occupation, hero.work?.occupation);
    });

    test('copyWith preserves and updates fields correctly', () {
      final original = HeroModel(
        id: 1,
        name: 'Batman',
        powerstats: Powerstats(strength: '85'),
        appearance: Appearance(gender: 'Male', race: 'Human'),
        source: 'local',
      );

      final updated = original.copyWith(id: 2, source: 'api', apiId: 70);

      expect(updated.id, 2);
      expect(updated.name, 'Batman'); // unchanged
      expect(updated.source, 'api');
      expect(updated.apiId, 70);
      expect(updated.powerstats.strength, '85'); // unchanged
    });
  });

  group('Powerstats', () {
    test('strengthValue converts string to int', () {
      final stats1 = Powerstats(strength: '85');
      expect(stats1.strengthValue, 85);

      final stats2 = Powerstats(strength: 'invalid');
      expect(stats2.strengthValue, 0);

      final stats3 = Powerstats(strength: '');
      expect(stats3.strengthValue, 0);
    });

    test('toMap includes all non-null fields', () {
      final stats = Powerstats(
        strength: '85',
        intelligence: '100',
        speed: null,
      );

      final map = stats.toMap();
      expect(map, {'strength': '85', 'intelligence': '100'});
      expect(map.containsKey('speed'), false);
    });
  });

  group('Appearance', () {
    test('handles arrays for height and weight', () {
      final appearance = Appearance(
        gender: 'Male',
        race: 'Human',
        height: ['6\'2', '188 cm'],
        weight: ['210 lb', '95 kg'],
      );

      final map = appearance.toMap();
      expect(map['height'], ['6\'2', '188 cm']);
      expect(map['weight'], ['210 lb', '95 kg']);

      final reconstructed = Appearance.fromMap(map);
      expect(reconstructed.height, ['6\'2', '188 cm']);
      expect(reconstructed.weight, ['210 lb', '95 kg']);
    });
  });

  group('Biography', () {
    test('handles aliases array', () {
      final bio = Biography(
        fullName: 'Bruce Wayne',
        aliases: ['Dark Knight', 'Caped Crusader'],
        publisher: 'DC Comics',
      );

      final map = bio.toMap();
      expect(map['aliases'], ['Dark Knight', 'Caped Crusader']);

      final reconstructed = Biography.fromMap(map);
      expect(reconstructed.aliases, ['Dark Knight', 'Caped Crusader']);
    });

    test('handles null aliases gracefully', () {
      final bio = Biography(fullName: 'Clark Kent');
      final map = bio.toMap();
      expect(map.containsKey('aliases'), false);
    });
  });

  group('Work and Connections', () {
    test('Work serialization', () {
      final work = Work(occupation: 'Detective', base: 'Gotham');
      final map = work.toMap();
      expect(map, {'occupation': 'Detective', 'base': 'Gotham'});

      final reconstructed = Work.fromMap(map);
      expect(reconstructed.occupation, 'Detective');
      expect(reconstructed.base, 'Gotham');
    });

    test('Connections serialization', () {
      final conn = Connections(
        groupAffiliation: 'Justice League',
        relatives: 'Alfred (butler)',
      );

      final map = conn.toMap();
      final reconstructed = Connections.fromMap(map);
      expect(reconstructed.groupAffiliation, 'Justice League');
      expect(reconstructed.relatives, 'Alfred (butler)');
    });
  });

  group('Edge Cases', () {
    test('handles missing or null ID gracefully', () {
      final map1 = {'name': 'Test Hero'};
      final hero1 = HeroModel.fromMap(map1);
      expect(hero1.id, 0);

      final map2 = {'id': null, 'name': 'Test Hero'};
      final hero2 = HeroModel.fromMap(map2);
      expect(hero2.id, 0);
    });

    test('handles string ID conversion', () {
      final map = {'id': '123', 'name': 'Test Hero'};
      final hero = HeroModel.fromMap(map);
      expect(hero.id, 123);
    });

    test('default source is local', () {
      final hero = HeroModel(
        id: 1,
        name: 'Test',
        powerstats: Powerstats(strength: '50'),
        appearance: Appearance(gender: 'Male', race: 'Human'),
      );
      expect(hero.source, 'local');
      expect(hero.apiId, isNull);
    });
  });
}
