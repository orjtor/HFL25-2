# v03 — Hero CLI (Dart)

Ett litet terminalprogram i Dart för att lägga till, visa och söka hjältar. Data sparas som JSON i projektroten så att det finns kvar mellan körningar.

## Vad kan man göra?

- Lägga till hjälte (namn, styrka, kön, ras, valfri alignment)
- Lista hjältar sorterade efter styrka (högst först)
- Sökning på namn (case‑insensitive contains)
- Automatisk rensning av konsolen mellan visningar
- Säker hantering av å/ä/ö via UTF‑8 för fil- och terminal‑I/O

## Så kör du

```powershell
# Från mappen v03
dart run
# eller
dart .\bin\v03.dart
```

## Testa

```powershell
dart test
```

## Projektstruktur

- `bin/v03.dart` — programstart (sätter UTF‑8 för in/utström och startar menyn)
- `lib/v03.dart` — app‑logik (laddning/sparning, menyåtgärder, inmatning)
- `lib/models/` — modellklasser
	- `hero_model.dart` (HeroModel med alla attribut från SuperheroAPI)
	- `powerstats.dart` (strength, intelligence, speed, durability, power, combat)
	- `appearance.dart` (gender, race, height, weight, eyeColor, hairColor)
	- `biography.dart` (fullName, alterEgos, aliases, placeOfBirth, firstAppearance, publisher, alignment)
	- `work.dart` (occupation, base)
	- `connections.dart` (groupAffiliation, relatives)
	- `image_model.dart` (url)
	- `models.dart` (barrel som exporterar modellerna)
- `lib/interfaces/` — interface för alla modeller
	- `i_hero_model.dart`, `i_powerstats.dart`, `i_appearance.dart`, `i_biography.dart`
	- `i_work.dart`, `i_connections.dart`, `i_image_model.dart`
- `lib/api/` — API-responshantering
	- `api_response.dart` (wrapper för API-svar med success/error)
- `lib/managers/` — hanteringslogik
- `lib/helper/` — hjälpfunktioner
- `test/` — enhetstester
- `superheros.json` — persistensfil (skapas automatiskt vid första sparning)

## JSON-format (array)

Varje hjälte sparas med nästlad struktur enligt SuperheroAPI-format. Exempel finns i `example.json` (Batman). 

Huvudstruktur:
```json
[
	{
		"id": 70,
		"name": "Batman",
		"powerstats": { "intelligence": "100", "strength": "26", ... },
		"appearance": { "gender": "Male", "race": "Human", "height": ["6'2", "188 cm"], ... },
		"biography": { "full-name": "Bruce Wayne", "alignment": "good", ... },
		"work": { "occupation": "Businessman", ... },
		"connections": { "group-affiliation": "Justice League", ... },
		"image": { "url": "https://..." }
	}
]
```

Notera:
- `biography`, `work`, `connections`, och `image` är valfria
- `height` och `weight` lagras som array med både imperial och metric värden
- Alla stats lagras som strängar i JSON
- API-respons inkluderar `"response": "success"` för framtida API-integration

## Tekniska detaljer

- **UTF‑8 encoding:** Fil‑I/O och terminal‑I/O körs i UTF‑8 för att å/ä/ö ska fungera på Windows/VS Code
- **Konsolrensning:** ANSI‑sekvenser (fallback till många radbrytningar om ANSI saknas)
- **Interface-baserad design:** Alla modeller implementerar interfaces för bättre testbarhet
- **API-ready:** Struktur förberedd för framtida integration med SuperheroAPI
- **Barrel exports:** `lib/v03.dart` re‑exporterar modellerna för enkel import

## Vanliga frågor

- "Var sparas filen?" — `superheros.json` i projektroten (`v03/`)
- "Kan jag ändra filformat?" — Ja, men håll `saveHeroes()` och `loadHeroes()` i samma format
- "Varför är stats strängar i JSON?" — Matchar SuperheroAPI:ets format; konverteras till int vid behov
- "Varför interfaces?" — Bättre separation of concerns, enklare att testa, följer SOLID-principer

## Nästa steg (förslag)

- Lägga till borttagning/redigering av hjälte
- Filtrering/sortering på fler fält (kön/ras/alignment)
- Validering och felmeddelanden per fält
