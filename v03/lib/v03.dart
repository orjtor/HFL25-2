import 'dart:io';
import 'dart:convert';

import 'models/models.dart';
import 'package:v03/managers/hero_data_manager.dart';
export 'models/models.dart';

final _manager = HeroDataManager();

Future<void> loadHeroes() => _manager.load();

Future<void> addHero() async {
  print('=== Lägg till ny hjälte ===\n');

  // Grundinfo
  final name = _prompt(
    'Namn: ',
    validate: (s) => s.trim().isEmpty ? 'Namn krävs.' : null,
  ).trim();

  // Powerstats
  print('\n--- Powerstats ---');
  final strength = _promptInt('Styrka (0-100): ', min: 0, max: 100);
  final intelligence = _prompt('Intelligens (valfritt): ').trim();
  final speed = _prompt('Speed (valfritt): ').trim();
  final durability = _prompt('Durability (valfritt): ').trim();
  final power = _prompt('Power (valfritt): ').trim();
  final combat = _prompt('Combat (valfritt): ').trim();

  // Appearance
  print('\n--- Appearance ---');
  final gender = _prompt(
    'Kön: ',
    validate: (s) => s.trim().isEmpty ? 'Kön krävs.' : null,
  ).trim();
  final race = _prompt(
    'Ras: ',
    validate: (s) => s.trim().isEmpty ? 'Ras krävs.' : null,
  ).trim();
  final heightInput = _prompt(
    'Längd (t.ex. "6\'2, 188 cm", valfritt): ',
  ).trim();
  final weightInput = _prompt(
    'Vikt (t.ex. "210 lb, 95 kg", valfritt): ',
  ).trim();
  final eyeColor = _prompt('Ögonfärg (valfritt): ').trim();
  final hairColor = _prompt('Hårfärg (valfritt): ').trim();

  // Biography
  print('\n--- Biography ---');
  final fullName = _prompt('Full Name (valfritt): ').trim();
  final alterEgos = _prompt('Alter Egos (valfritt): ').trim();
  final aliasesInput = _prompt('Aliases (kommaseparerad, valfritt): ').trim();
  final placeOfBirth = _prompt('Place of Birth (valfritt): ').trim();
  final firstAppearance = _prompt('First Appearance (valfritt): ').trim();
  final publisher = _prompt('Publisher (valfritt): ').trim();
  final alignment = _prompt('Alignment (valfritt): ').trim();

  // Work
  print('\n--- Work ---');
  final occupation = _prompt('Occupation (valfritt): ').trim();
  final base = _prompt('Base (valfritt): ').trim();

  // Connections
  print('\n--- Connections ---');
  final groupAffiliation = _prompt('Group Affiliation (valfritt): ').trim();
  final relatives = _prompt('Relatives (valfritt): ').trim();

  // Image
  print('\n--- Image ---');
  final imageUrl = _prompt('Image URL (valfritt): ').trim();

  // Bygg modellen
  final hero = HeroModel(
    id: 0, // Manager sätter rätt id
    name: name,
    powerstats: Powerstats(
      strength: strength.toString(),
      intelligence: intelligence.isEmpty ? null : intelligence,
      speed: speed.isEmpty ? null : speed,
      durability: durability.isEmpty ? null : durability,
      power: power.isEmpty ? null : power,
      combat: combat.isEmpty ? null : combat,
    ),
    appearance: Appearance(
      gender: gender,
      race: race,
      height: heightInput.isEmpty
          ? null
          : heightInput.split(',').map((e) => e.trim()).toList(),
      weight: weightInput.isEmpty
          ? null
          : weightInput.split(',').map((e) => e.trim()).toList(),
      eyeColor: eyeColor.isEmpty ? null : eyeColor,
      hairColor: hairColor.isEmpty ? null : hairColor,
    ),
    biography:
        (fullName.isEmpty &&
            alterEgos.isEmpty &&
            aliasesInput.isEmpty &&
            placeOfBirth.isEmpty &&
            firstAppearance.isEmpty &&
            publisher.isEmpty &&
            alignment.isEmpty)
        ? null
        : Biography(
            fullName: fullName.isEmpty ? null : fullName,
            alterEgos: alterEgos.isEmpty ? null : alterEgos,
            aliases: aliasesInput.isEmpty
                ? null
                : aliasesInput.split(',').map((e) => e.trim()).toList(),
            placeOfBirth: placeOfBirth.isEmpty ? null : placeOfBirth,
            firstAppearance: firstAppearance.isEmpty ? null : firstAppearance,
            publisher: publisher.isEmpty ? null : publisher,
            alignment: alignment.isEmpty ? null : alignment,
          ),
    work: (occupation.isEmpty && base.isEmpty)
        ? null
        : Work(
            occupation: occupation.isEmpty ? null : occupation,
            base: base.isEmpty ? null : base,
          ),
    connections: (groupAffiliation.isEmpty && relatives.isEmpty)
        ? null
        : Connections(
            groupAffiliation: groupAffiliation.isEmpty
                ? null
                : groupAffiliation,
            relatives: relatives.isEmpty ? null : relatives,
          ),
    image: imageUrl.isEmpty ? null : ImageModel(url: imageUrl),
  );

  await _manager.saveHero(hero);
  print('\nHjälte tillagd! Tryck Enter för att fortsätta.');
  stdin.readLineSync(encoding: utf8);
}

Future<void> showHeroes() async {
  clearConsole();
  final list = await _manager.getHeroList();
  if (list.isEmpty) {
    print('Inga hjältar ännu.');
  } else {
    final sorted = [...list]
      ..sort(
        (a, b) =>
            b.powerstats.strengthValue.compareTo(a.powerstats.strengthValue),
      );
    for (var i = 0; i < sorted.length; i++) {
      print('${i + 1}. ${sorted[i]}');
    }
  }
  print('Tryck Enter för att fortsätta.');
  stdin.readLineSync(encoding: utf8);
}

Future<void> searchHero() async {
  final q = _prompt('Sök namn: ').trim();
  final results = await _manager.searchHero(q);

  if (results.isEmpty) {
    print('Hittade ingen hjälte med namn "$q".');
    print('Tryck Enter för att fortsätta.');
    stdin.readLineSync(encoding: utf8);
    return;
  }

  print('\nTräffar:');
  for (final h in results) {
    final align = h.biography?.alignment ?? '';
    print(
      'ID: ${h.id} | Namn: ${h.name} | Styrka: ${h.powerstats.strength} | Align: $align',
    );
  }

  while (true) {
    final val = _prompt('Ange hjälte-id för detaljer (0 för meny): ').trim();
    final id = int.tryParse(val);
    if (id == null) {
      print('Ange ett giltigt id.');
      continue;
    }
    if (id == 0) return;
    HeroModel hero;
    try {
      hero = results.firstWhere((h) => h.id == id);
    } catch (_) {
      print('Ingen hjälte med id $id i träfflistan.');
      continue;
    }

    _manager.showHero(hero);

    stdin.readLineSync(encoding: utf8);
    break;
  }
}

void clearConsole() {
  if (stdout.supportsAnsiEscapes) {
    stdout.write('\x1B[2J\x1B[3J\x1B[H');
  } else {
    print('\n' * 100);
  }
}

String _prompt(String label, {String? Function(String)? validate}) {
  while (true) {
    stdout.write(label);
    final input = stdin.readLineSync(encoding: utf8) ?? '';
    final error = validate?.call(input);
    if (error == null) return input;
    print(error);
  }
}

int _promptInt(String label, {int? min, int? max}) {
  while (true) {
    stdout.write(label);
    final s = stdin.readLineSync(encoding: utf8);
    final v = int.tryParse(s ?? '');
    if (v == null) {
      print('Ange ett heltal.');
      continue;
    }
    if (min != null && v < min) {
      print('Måste vara ≥ $min.');
      continue;
    }
    if (max != null && v > max) {
      print('Måste vara ≤ $max.');
      continue;
    }
    return v;
  }
}
