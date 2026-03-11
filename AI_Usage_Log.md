# AI Usage Log

## Entry 1
- Date: 2026-03-11
- Tool: Codex
- Prompt summary: Inspect current RecipeHub repository state and identify baseline gaps before changes.
- Output used: Branch/status summary, existing file structure audit, asset/CSV presence verification, and missing document checklist.
- What I reviewed/learned: Confirmed the project had only starter app code, frozen assets were present, and required architecture/data docs were missing.

## Entry 2
- Date: 2026-03-11
- Tool: Codex
- Prompt summary: Create project contract and execution plan for team coordination and ownership boundaries.
- Output used: `TEAM_CONTRACT.md` and `PROJECT_PLAN.md` with frozen routes/models/tables and ownership split.
- What I reviewed/learned: Established non-rename contract boundaries to reduce integration risks between data-layer and UI ownership.

## Entry 3
- Date: 2026-03-11
- Tool: Codex
- Prompt summary: Build Flutter app architecture/data foundation with route shells, models, SQLite schema, CSV parsing, and seed flow.
- Output used: Feature folder structure, `app.dart/routes.dart/theme.dart`, model classes, database helper/schema, parser service, and first-launch seed service.
- What I reviewed/learned: Verified local-first flow where CSV initializes SQLite once and runtime data comes from repositories.

## Entry 4
- Date: 2026-03-11
- Tool: Codex
- Prompt summary: Implement repositories, fridge CRUD, save/unsave persistence, and cleaned-ingredient recipe matching.
- Output used: Repository layer for all tables, fridge CRUD methods, saved recipe persistence, recipe matching service + repository search method.
- What I reviewed/learned: Confirmed separation between persistence logic and UI, with deterministic search ranking by match count.

## Entry 5
- Date: 2026-03-11
- Tool: Codex
- Prompt summary: Wire provider-based app state into minimal screens and enforce fallback/validation behavior.
- Output used: Provider classes, screen-to-provider wiring, initialization/seed flow at app startup, image fallback widget, no-selection/no-match states, malformed CSV handling.
- What I reviewed/learned: Validated end-to-end local data flow with minimal UI and explicit resilience for common failure paths.

## Entry 6
- Date: 2026-03-11
- Tool: Codex
- Prompt summary: Add technical documentation and baseline tests for parser/repository/search logic.
- Output used: `ARCHITECTURE.md`, updated `README.md`, and tests for CSV parser behavior, matching logic, repository search path, and app boot shell.
- What I reviewed/learned: Confirmed analysis/tests pass and documentation reflects implementation constraints and integration contracts.
