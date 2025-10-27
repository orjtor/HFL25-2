import 'dart:io';
import 'dart:convert';
import 'package:v04/v04.dart' as v04;

Future<void> main(List<String> arguments) async {
  stdout.encoding = utf8;
  stderr.encoding = utf8;

  await v04.loadHeroes();

  while (true) {
    v04.clearConsole();

    print("1. Lägg till hjälte");
    print("2. Visa hjältar");
    print("3. Sök");
    print("4. Avsluta");

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
        print('Avslutar programmet. Hej då!');
        return;
      default:
        print('Ogiltigt val, försök igen.');
    }
  }
}
