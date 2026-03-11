# RecipeHub Architecture

## Why SQLite + SharedPreferences
- SQLite is the primary local relational store for recipes, ingredients, categories, fridge items, and saved recipes.
- This satisfies course requirements for relational/local persistence and supports CRUD operations offline.
- SharedPreferences is used for lightweight key-value settings and flags:
  - first-launch seed completion (`seed_completed_v1`)
  - UI preference (`dark_mode_enabled`)

## Why CSV Is Seed Data Only
- CSV files under `assets/data/` are bundled bootstrap inputs.
- On first launch, the app parses CSV and writes normalized rows into SQLite.
- After seeding, runtime reads happen from SQLite repositories, not repeated CSV parsing.
- This reduces startup/parsing overhead on future launches and keeps one source of truth at runtime.

## Folder Structure
```text
lib/
  app/                 # app entry, routes, theme, provider wiring
  core/
    constants/         # frozen paths + preferences keys
    utils/
    widgets/           # reusable fallback widgets
  data/
    database/          # SQLite helper and table constants
    models/            # frozen contracts + map helpers
    repositories/      # data access abstraction over SQLite
    services/          # CSV parser, seeding, matching
  features/
    dashboard/
    ingredients/
    my_fridge/
    saved_recipes/
    recipe_results/
    recipe_detail/
    settings/
```

## Repository / Provider Separation
- Repositories encapsulate SQLite query details and return typed models.
- Providers (`ChangeNotifier`) coordinate UI state:
  - loading/error flags
  - user actions
  - repository calls
- Screens stay minimal and consume provider state/actions rather than querying DB directly.

## Recipe Search Approach
- Search uses selected fridge items only (`is_selected = 1`).
- Matching compares normalized selected ingredient names against normalized tokens from `recipes.cleaned_ingredients`.
- A recipe is considered a match when ingredient tokens match exactly or by containment (to tolerate mild naming differences).
- Results are sorted by descending match count, then title.

## Error Handling Strategy
- CSV parsing is defensive:
  - malformed rows are skipped
  - extra columns are ignored
  - missing required recipe fields cause row skip
- Missing images are handled with `AssetImageWithFallback` and a visible placeholder.
- Empty ingredient selection and no-match outcomes are explicitly represented in provider/UI state.
- Initialization/seed failures surface as a minimal app-level failure message.
