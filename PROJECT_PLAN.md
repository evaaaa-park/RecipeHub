# RecipeHub Project Plan

## Scope
- Build a local-first RecipeHub architecture that loads bundled CSV data into SQLite on first launch, then reads from SQLite for app usage.
- Deliver stable contracts for routes, models, and table names to protect teammate UI implementation.
- Provide minimal screen shells and provider wiring for end-to-end local data flow, without final UI polish.

## Milestones
1. Project contracts and planning docs
2. Feature-based folder structure + app routing skeleton
3. Core models + SQLite schema/helper
4. CSV parsing + first-launch seeding
5. Repository layer + fridge CRUD + save/unsave flow
6. Recipe matching logic using selected cleaned ingredients
7. Provider-based state wiring to minimal screens
8. Fallback handling, tests, architecture docs, and final cleanup

## Owned Tasks (My Scope)
- Architecture and technical contracts
- Feature/module folder structure
- Routing and minimal route shells
- Shared theme tokens/constants
- Core model classes and mapping helpers
- SQLite helper and schema
- CSV parse services with defensive handling
- First-launch seed import and SharedPreferences seed flag
- Repositories for categories, ingredients, recipes, fridge items, saved recipes
- Fridge CRUD operations and save/unsave persistence
- Recipe matching search logic
- Provider-based state wiring
- ARCHITECTURE.md, README technical updates, AI_Usage_Log.md
- Basic tests for parser/repository/search logic

## Teammate-Owned Tasks
- Final visual design and polished UI components
- Accessibility enhancements and UX refinements
- Animation/micro-interactions and layout polish
- Final visual QA across screen sizes

## Integration Notes
- UI layer must consume provider/repository contracts instead of direct DB queries.
- Frozen route names and model fields are shared integration contracts.
- Images are loaded from `assets/images/` and should use a fallback pattern for missing assets.
- CSV files are seed sources only; runtime reads should come from SQLite.
- Any breaking contract update requires synchronized PR review by both teammates.
