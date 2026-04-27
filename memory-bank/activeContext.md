# Active Context

## Current Focus

Evolve Dashboard Layout Architect into a K–12 Dashboard Architect.

Phases 0–3 are complete. The project now has five registry/data files in `R/` alongside the monolithic `app.R`.

## Completed Phases

- **Phase 0**: Architecture inventory of `app.R` (2,159 lines). Identified all function locations, config structure, and extraction priorities.
- **Phase 1**: Created `R/theme_registry.R` (4 themes), `R/metric_registry.R` (10 metrics), `R/demo_data_k12.R` (5 deterministic datasets). All verified via `Rscript` sourcing. No changes to `app.R`.
- **Phase 2**: Created `R/template_registry.R` with BOE Area Snapshot template. 8 sections (header, filter_bar, kpi_row, map, school_table, trend, student_groups, source_footer), 6 KPI metrics, layout defaults, audience/context metadata. Verified via `Rscript` sourcing.
- **Phase 3**: Created `R/component_registry.R` with 12 component entries and 12 placeholder render functions. All return deterministic HTML using inline styles. Verified with `Rscript` sourcing and HTML output testing.

## Current Priority

**Phase 4**: Wire template/theme/audience controls into the existing `app.R` sidebar. Add `source()` calls for the new R/ files. Minimal disruption to existing behavior.

## Next Cline Prompt

```text
Implement Phase 4 only.

Wire the new registries into app.R:

1. Add source() calls at the top of app.R for all 5 R/ files
2. Add a template selector dropdown to the sidebar (populated from template_registry)
3. When BOE Area Snapshot is selected, show a summary of its sections in the sidebar
4. Preserve all existing app behavior (layout controls, preview, export)

Do not change the preview renderer yet.
Do not add new export logic.

After editing, confirm the app still starts and the template dropdown appears.
```

## Working Assumptions

- The project root contains `app.R`.
- The current app works or mostly works before refactor.
- `_app_archive/` should be ignored unless explicitly needed.
- The first serious template should be BOE Area Snapshot.
- Promise Schools and Assessment Performance should come after the BOE template pattern works.
- Existing export behavior should be preserved during early refactor phases.
- Avoid drag-and-drop for now.
