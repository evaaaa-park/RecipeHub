# RecipeHub Team Contract

## Project Constraints
- Platform: Flutter (Dart)
- Local-only stack: SQLite, SharedPreferences, Provider, CSV assets
- No cloud/API/Firebase/backend usage

## Frozen Asset Paths
- `assets/data/recipes.csv`
- `assets/data/ingredients.csv`
- `assets/data/categories.csv`
- `assets/images/` (JPG files)

## Frozen Named Routes
- `/dashboard`
- `/ingredients`
- `/my-fridge`
- `/saved-recipes`
- `/recipe-results`
- `/recipe-detail`
- `/settings`

## Frozen Model Contracts
### Recipe
- `int id`
- `String title`
- `String ingredientsRaw`
- `String instructions`
- `String imageName`
- `String cleanedIngredients`

### Ingredient
- `int id`
- `String name`
- `String category`

### Category
- `int id`
- `String name`

### FridgeItem
- `int id`
- `int ingredientId`
- `String ingredientName`
- `String? quantity`
- `String? expiryDate`
- `bool isSelected`
- `String addedAt`

### SavedRecipe
- `int id`
- `int recipeId`
- `String recipeTitle`
- `String savedAt`

## Frozen Table Names
- `categories`
- `ingredients`
- `recipes`
- `fridge_items`
- `saved_recipes`

## Ownership Split
- My scope: architecture, local data layer, SQLite schema/helper, CSV seed import, repositories, provider state wiring, recipe matching/search logic, technical docs, and minimal screen shells.
- Teammate scope: screen UI polish, reusable visual widgets, accessibility refinements, motion/animation, and final visual consistency.

## Coordination Rules
- Route names, model field names, and table names must not be renamed casually.
- If a rename is truly required, both teammates must review the impact and update docs + references in one coordinated change.
- Data layer changes must preserve existing UI integration contracts wherever possible.
- Keep commits reviewable and aligned with course rules.
