Kalkylatorn
***********

Startas genom kommadot: dart run bin\v01.dart

En funktion i Dart deklareras med returtypen, funktionens namn, ingående parametrar inom parentes följt av måsvingar.
innanför måsvingarna finns koden och return av någon typ om inte functionen är av typen void eller Never.

Exv:

double additionCalculator( double first, double last) {

	return first + last;
}


Kalkylatorn använder stdin.readLineSync() för att läsa input från användaren.
Försök görs att parsa till datatypen double eller till String för operatorval, vidare 
valideras även om användaren väljer att skriva in 'exit' och då avslutas programmet.
Kalkylatorn tar mot en double och sedan en operator och sist en andra double och gör sedan beräkningen


dart pub get
Resolving dependencies... 
Downloading packages... 
Got dependencies!

dart analyze
Analyzing v01...
No issues found!

dart format .
Formatted bin\v01.dart
Formatted 1 file (1 changed) in 0.14 seconds.