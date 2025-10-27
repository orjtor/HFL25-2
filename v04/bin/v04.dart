import 'dart:io';
import 'dart:convert';
import 'package:v04/v04.dart' as v04;
import 'package:dotenv/dotenv.dart';

Future<void> main(List<String> arguments) async {
  var env = DotEnv()..load();

  String? apiToken = env['SUPERHERO_API_TOKEN'];
  String? baseUrl = env['SUPERHERO_API_BASE_URL'];

  stdout.encoding = utf8;
  stderr.encoding = utf8;

  await v04.loadHeroes();

  while (true) {
    v04.clearConsole();

    print("1. Lägg till hjälte");
    print("2. Visa hjältar");
    print("3. Sök i fil");
    print("4. Sök via API");
    print("5. Avsluta");

    final choice = stdin.readLineSync(encoding: utf8);
    switch (choice) {
      case '1':
        await v04.addHero();
        break;
      case '2':
        await v04.showHeroes();
        break;
      case '3':
        await v04.searchHero();
        break;
      case '4':
        await v04.searchHeroApi();
        break;
      case '5':
        print('Avslutar programmet. Hej då!');
        return;
      default:
        print('Ogiltigt val, försök igen.');
    }
  }
}
