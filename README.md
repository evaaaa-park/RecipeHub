# RecipeHub

RecipeHub is a local-first Flutter app for ingredient browsing, fridge tracking, recipe matching, recipe details, and local save/unsave flow.

## Tech Stack
- Flutter / Dart
- SQLite (`sqflite`)
- SharedPreferences
- Provider
- CSV asset parsing
- Local image assets only

## Frozen Asset Expectations
- `assets/data/recipes.csv`
- `assets/data/ingredients.csv`
- `assets/data/categories.csv`
- `assets/images/` (JPG files)

## Setup
1. Install Flutter `3.41.4` or compatible stable SDK.
2. From project root:
   - `flutter pub get`
3. Run:
   - `flutter run`

## Local Database Notes
- SQLite DB file: `recipehub.db` (managed via `sqflite`).
- Tables:
  - `categories`
  - `ingredients`
  - `recipes`
  - `fridge_items`
  - `saved_recipes`
- First app launch flow:
  - parse CSV from `assets/data/`
  - seed SQLite inside one transaction
  - set SharedPreferences flag `seed_completed_v1 = true`
- Subsequent launches read from SQLite repositories.

## Main Routes
- `/dashboard`
- `/ingredients`
- `/my-fridge`
- `/saved-recipes`
- `/recipe-results`
- `/recipe-detail`
- `/settings`

## Development Checks
- `flutter analyze`
- `flutter test`

## Notes
- No cloud storage/API/Firebase/backend is used.
- UI in this branch is intentionally minimal shell UI to validate architecture/data flow.
- See [ARCHITECTURE.md](ARCHITECTURE.md) for design details.
