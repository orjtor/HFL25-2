import 'dart:io';
import 'dart:convert';
import 'package:v03/v03.dart' as v03;

void main(List<String> arguments) {
  stdout.encoding = utf8;
  stderr.encoding = utf8;
  v03.loadHeroes();

  while (true) {
    v03.clearConsole();

    print("1. Lägg till hjälte");
    print("2. Visa hjältar");
    print("3. Sök");
    print("4. Avsluta");

    final choice = stdin.readLineSync(encoding: utf8);
    switch (choice) {
      case '1':
        v03.addHero();
        break;
      case '2':
        v03.showHeroes();
        break;
      case '3':
        v03.searchHero();
        break;
      case '4':
        print('Avslutar programmet. Hej då!');
        return;
      default:
        print('Ogiltigt val, försök igen.');
    }
  }
}
