import 'dart:io';
import 'dart:convert';
import 'models/models.dart';
export 'models/models.dart';

final List<Superhero> heroes = [];
final File _heroesFile = File('superheros.json');

void saveHeroes() {
  try {
    final data = heroes.map((h) => h.toMap()).toList();
    _heroesFile.writeAsStringSync(jsonEncode(data), encoding: utf8);
  } catch (e) {
    stderr.writeln('Kunde inte spara superheros.json: $e');
  }
}

void loadHeroes() {
  try {
    if (!_heroesFile.existsSync()) return;
    final content = _heroesFile.readAsStringSync(encoding: utf8);
    if (content.trim().isEmpty) return;
    final raw = jsonDecode(content);
    if (raw is List) {
      heroes
        ..clear()
        ..addAll(
          raw.whereType<Map>().map(
            (m) => Superhero.fromMap(Map<String, dynamic>.from(m)),
          ),
        );
    }
  } catch (e) {
    stderr.writeln('Kunde inte läsa superheros.json: $e');
  }
}

void addHero() {
  final name = _prompt(
    'Namn: ',
    validate: (s) => s.trim().isEmpty ? 'Namn krävs.' : null,
  ).trim();
  final strength = _promptInt('Styrka (0-100): ', min: 0, max: 100);
  final gender = _prompt(
    'Kön: ',
    validate: (s) => s.trim().isEmpty ? 'Kön krävs.' : null,
  ).trim();
  final race = _prompt(
    'Ras: ',
    validate: (s) => s.trim().isEmpty ? 'Ras krävs.' : null,
  ).trim();
  final alignment = _prompt('Alignment (valfritt): ').trim();

  final hero = Superhero(
    name: name,
    powerstats: Powerstats(strength: strength.toString()),
    appearance: Appearance(gender: gender, race: race),
    biography: alignment.isEmpty ? null : Biography(alignment: alignment),
  );

  heroes.add(hero);
  saveHeroes();
  print('Hjälte tillagd. Tryck Enter för att fortsätta.');
  stdin.readLineSync(encoding: utf8);
}

void showHeroes() {
  clearConsole();
  if (heroes.isEmpty) {
    print('Inga hjältar ännu.');
  } else {
    final sorted = [...heroes]
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

void searchHero() {
  final q = _prompt('Sök namn: ').trim();
  final results = heroes
      .where((h) => h.name.toLowerCase().contains(q.toLowerCase()))
      .toList();
  if (results.isEmpty) {
    print('Hittade ingen hjälte med namn "$q".');
  } else {
    for (final h in results) {
      print('Hittad: $h');
    }
  }
  print('Tryck Enter för att fortsätta.');
  stdin.readLineSync(encoding: utf8);
}

void clearConsole() {
  if (stdout.supportsAnsiEscapes) {
    // Rensa skärmen och flytta markören till toppen
    stdout.write('\x1B[2J\x1B[3J\x1B[H');
  } else {
    // Fallback om ANSI inte stöds
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
