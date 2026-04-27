# Active Context

## Current Focus

Evolve Dashboard Layout Architect into a K–12 Dashboard Architect.

Phases 0, 1, and 2 are complete. The project now has four registry files in `R/` alongside the monolithic `app.R`.

## Completed Phases

- **Phase 0**: Architecture inventory of `app.R` (2,159 lines). Identified all function locations, config structure, and extraction priorities.
- **Phase 1**: Created `R/theme_registry.R` (4 themes), `R/metric_registry.R` (10 metrics), `R/demo_data_k12.R` (5 deterministic datasets). All verified via `Rscript` sourcing. No changes to `app.R`.
- **Phase 2**: Created `R/template_registry.R` with BOE Area Snapshot template. 8 sections (header, filter_bar, kpi_row, map, school_table, trend, student_groups, source_footer), 6 KPI metrics, layout defaults, audience/context metadata. Verified via `Rscript` sourcing.

## Current Priority

**Phase 3**: Create `R/component_registry.R` with component entries mapping component IDs to placeholder render/export functions. Do not modify existing app behavior.

## Next Cline Prompt

```text
Implement Phase 3 only.

Create R/component_registry.R.

Add registry entries for:
- dashboard_header
- nav_tabs
- filter_bar
- kpi_row
- metric_selector_card
- trend_chart_placeholder
- student_group_comparison
- map_school_points
- school_summary_table
- metric_matrix_table
- source_footer
- disclosure_note

Add placeholder render functions only if needed.
Do not wire them into app.R yet.

After editing, summarize how components will connect to templates.
```

## Working Assumptions

- The project root contains `app.R`.
- The current app works or mostly works before refactor.
- `_app_archive/` should be ignored unless explicitly needed.
- The first serious template should be BOE Area Snapshot.
- Promise Schools and Assessment Performance should come after the BOE template pattern works.
- Existing export behavior should be preserved during early refactor phases.
- Avoid drag-and-drop for now.
