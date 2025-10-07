# v02 — Superhero CLI (Dart)

Ett litet terminalprogram i Dart för att lägga till, visa och söka hjältar. Data sparas som JSON i projektroten så att det finns kvar mellan körningar.

## Vad kan man göra?

- Lägga till hjälte (namn, styrka, kön, ras, valfri alignment)
- Lista hjältar sorterade efter styrka (högst först)
- Sökning på namn (case‑insensitive contains)
- Automatisk rensning av konsolen mellan visningar
- Säker hantering av å/ä/ö via UTF‑8 för fil- och terminal‑I/O

## Så kör du

```powershell
# Från mappen v02
dart run
# eller
dart .\bin\v02.dart
```

## Testa

```powershell
dart test
```

## Projektstruktur

- `bin/v02.dart` — programstart (sätter UTF‑8 för in/utström och startar menyn)
- `lib/v02.dart` — app‑logik (laddning/sparning, menyåtgärder, inmatning)
- `lib/models/` — modellklasser
	- `superhero.dart` (Superhero med `powerstats`, `appearance`, valfri `biography`)
	- `powerstats.dart` (lagrar `strength` som sträng; `strengthValue` ger heltal för sortering)
	- `appearance.dart` (kön/ras)
	- `biography.dart` (alignment, valfritt)
	- `models.dart` (barrel som exporterar modellerna)
- `test/` — enhetstester
- `heroes.json` — persistensfil (skapas automatiskt vid första sparning)

## JSON-format (array)

Varje hjälte sparas med nästlad struktur. Exempel:

```json
[
	{
		"name": "Batman",
		"powerstats": { "strength": "85" },
		"appearance": { "gender": "Male", "race": "Human" },
		"biography": { "alignment": "good" }
	}
]
```

Notera:
- `biography` är valfritt och kan utelämnas.
- `powerstats.strength` lagras som sträng i JSON men tolkas som heltal i appen när vi sorterar.

## Tekniska detaljer

- Fil‑I/O och terminal‑I/O körs i UTF‑8 för att å/ä/ö ska fungera på Windows/VS Code
- Rensning av konsol görs via ANSI‑sekvenser (fallback till många radbrytningar om ANSI saknas)
- `lib/v02.dart` re‑exporterar modellerna: andra filer kan skriva `import 'package:v02/v02.dart';` och nå `Superhero` direkt

## Vanliga frågor

- “Var sparas filen?” — `heroes.json` i projektroten (`v02/`)
- “Kan jag ändra filformat?” — Ja, men håll `saveHeroes()` och `loadHeroes()` i samma format
- “Varför är strength en sträng i JSON?” — matchar givna specifikationer; i koden används `strengthValue` för jämförelser

## Nästa steg (förslag)

- Lägga till borttagning/redigering av hjälte
- Filtrering/sortering på fler fält (kön/ras/alignment)
- Validering och felmeddelanden per fält
