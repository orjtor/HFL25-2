import 'dart:io';
import 'dart:convert';

class Hero {
  final String name;
  final String power;
  final int strength;

  Hero({required this.name, required this.power, required this.strength});

  Map<String, dynamic> toMap() => {
    'name': name,
    'power': power,
    'strength': strength,
  };

  factory Hero.fromMap(Map<String, dynamic> map) => Hero(
    name: map['name'] as String? ?? '',
    power: map['power'] as String? ?? '',
    strength: (map['strength'] as num?)?.toInt() ?? 0,
  );

  @override
  String toString() => '$name ($power), styrka: $strength';
}

final List<Hero> heroes = [];
final File _heroesFile = File('heroes.json');

void saveHeroes() {
  try {
    final data = heroes.map((h) => h.toMap()).toList();
    _heroesFile.writeAsStringSync(jsonEncode(data));
  } catch (e) {
    stderr.writeln('Kunde inte spara heroes.json: $e');
  }
}

void loadHeroes() {
  try {
    if (!_heroesFile.existsSync()) return;
    final content = _heroesFile.readAsStringSync();
    if (content.trim().isEmpty) return;
    final raw = jsonDecode(content);
    if (raw is List) {
      heroes
        ..clear()
        ..addAll(
          raw.whereType<Map>().map(
            (m) => Hero.fromMap(Map<String, dynamic>.from(m)),
          ),
        );
    }
  } catch (e) {
    stderr.writeln('Kunde inte läsa heroes.json: $e');
  }
}

void addHero() {
  final name = _prompt(
    'Namn: ',
    validate: (s) => s.trim().isEmpty ? 'Namn krävs.' : null,
  ).trim();
  final power = _prompt(
    'Kraft: ',
    validate: (s) => s.trim().isEmpty ? 'Kraft krävs.' : null,
  ).trim();
  final strength = _promptInt('Styrka (0-100): ', min: 0, max: 100);

  heroes.add(Hero(name: name, power: power, strength: strength));
  saveHeroes();
  print('Hjälte tillagd. Tryck Enter för att fortsätta.');
  stdin.readLineSync();
}

void showHeroes() {}
void searchHero() {}
void clearConsole() {
  if (stdout.supportsAnsiEscapes) {
    // Rensa skärmen och flytta markören till toppen
    stdout.write('\x1B[2J\x1B[3J\x1B[H');
    // stdout.write('\x1Bc'); // Reset to Initial State (rensa + återställ)
  } else {
    // Fallback om ANSI inte stöds
    print('\n' * 100);
  }
}

String _prompt(String label, {String? Function(String)? validate}) {
  while (true) {
    stdout.write(label);
    final input = stdin.readLineSync() ?? '';
    final error = validate?.call(input);
    if (error == null) return input;
    print(error);
  }
}

int _promptInt(String label, {int? min, int? max}) {
  while (true) {
    stdout.write(label);
    final s = stdin.readLineSync();
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
