# v04 — Hero CLI (Dart)

Ett litet terminalprogram i Dart för att lägga till, visa och söka hjältar. Data sparas som JSON i projektroten så att det finns kvar mellan körningar. Integrerat med SuperheroAPI för att hämta hjältar från extern källa.

## Vad kan man göra?

- Lägga till hjälte (manuellt eller från SuperheroAPI)
- Lista hjältar sorterade efter styrka (högst första)
- Sökning på namn (case‑insensitive contains)
- Radera hjälte (tryck R efter visning)
- Automatisk dubbletthantering (samma namn+publisher)
- Spårning av källa (lokal/API) för varje hjälte
- Automatisk rensning av konsolen mellan visningar
- Säker hantering av å/ä/ö via UTF‑8 för fil- och terminal‑I/O

## Konfiguration

Skapa en `.env` fil i projektroten med din SuperheroAPI-token:

```properties
SUPERHERO_API_BASE_URL=https://superheroapi.com/api
SUPERHERO_API_TOKEN=din_api_token_här
```

## Så kör du

```powershell
# Från mappen v04
dart run
# eller
dart .\bin\v04.dart
```

## Testa

```powershell
dart test
```

## Projektstruktur

- `bin/v04.dart` — programstart (sätter UTF‑8 för in/utström och startar menyn)
- `lib/v04.dart` — app‑logik (laddning/sparning, menyåtgärder, inmatning)
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
- `lib/services/` — API-tjänster
	- `api_service.dart` (SuperheroAPI integration med .env konfiguration)
- `lib/api/` — API-responshantering
	- `api_response.dart` (wrapper för API-svar med success/error)
- `lib/managers/` — hanteringslogik (dubbletthantering, datapersistens)
- `lib/helper/` — hjälpfunktioner
- `test/` — enhetstester (15 tester för CI/CD)
- `.env` — API-konfiguration (SuperheroAPI token)
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
- `source` och `apiId` spårar om hjälte kommer från API eller är lokalt skapad
- Alla stats lagras som strängar i JSON (matchar SuperheroAPI format)
- Automatisk dubbletthantering baserat på `name` + `publisher`

## Tekniska detaljer

- **SuperheroAPI integration:** Hämtar hjältar från extern API med dotenv konfiguration
- **Dubbletthantering:** Förhindrar dubletter baserat på namn+publisher kombination
- **Källspårning:** Håller reda på om hjälte kommer från API eller är lokalt skapad
- **UTF‑8 encoding:** Fil‑I/O och terminal‑I/O körs i UTF‑8 för att å/ä/ö ska fungera på Windows/VS Code
- **Interface-baserad design:** Alla modeller implementerar interfaces för bättre testbarhet
- **Singleton pattern:** ApiService använder singleton för effektiv resurshantering

## Dependencies

- `http: ^1.1.2` — HTTP requests till SuperheroAPI
- `dotenv: ^4.2.0` — Hantering av miljövariabler (.env fil)
- `path: ^1.9.0` — Filsökvägshantering

## Vanliga frågor

- "Var sparas filen?" — `superheros.json` i projektroten (`v04/`)
- "Hur fungerar dubbletthantering?" — Jämför `name` + `publisher`, förhindrar duplicering
- "Varför .env fil?" — Säker hantering av API-token, ej versionshanterad
- "Varför är stats strängar?" — Matchar SuperheroAPI format; konverteras vid behov

## CI/CD

Projektet innehåller 15 enhetstester som körs utan externa dependencies:

```powershell
dart test
```

Testerna täcker:
- Modell serialisering/deserialisering
- Edge cases och null-hantering  
- API integration logik
- Dubbletthantering

## Nästa steg (förslag)

- Redigering av hjälte
- Batch-import från API
- Caching av API-requests
