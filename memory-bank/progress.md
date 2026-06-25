# GCPS Theme Studio — Progress

## Completed

### Part A — Embed the client-side Theme Studio (✅ green)
- Vendored `www/palette-data.js`, `www/theme-studio.js`, `www/theme-studio-app.js`
- Re-scoped all CSS under `.ts-root` in `www/theme-studio.css` (zero global bleed)
- One body reference in `theme-studio-app.js` retargeted to `.ts-root`
- Added the Shiny bridge: `render()` emits `input$ts_theme` on every studio change
- Mounted the studio in the existing `theme_studio_tab` nav_panel via
  `www/_theme_studio_markup.html` (markup → data → engine → app load order)
- `theme-studio.css` linked from the app head
- `www/fonts/README.md` documents the five self-hosted woff2 families

### Part B — Downloadable project templates (✅ green)
- Added `zip` to the requireNamespace block + `source("R/generate_templates.R")`
- `R/generate_templates.R`: `gcps_resolve_theme()` (null-safe default), six
  builders + `theme_gcps.R` / SCSS / `_brand.yml` / CSS-vars export,
  `gcps_write_template_zip()`, `gcps_template_all()`, `gcps_write_all_zip()`
- `templates_tab` nav_panel (six cards + Download-all) inserted after the studio
- Seven `downloadHandler`s wired (one per kind + combined) driven by
  `input$ts_theme`; `ts_theme_summary` badge echoes the active theme
- Acceptance test passes: every bundle's files exist, accent hex + font label
  are baked in, `GCPS-theme.json` parses with `dataColors == palette_hex`,
  zip round-trips match the tree, the all-zip has six subfolders + README

### Part C — Studio is the single source of truth (✅ green)
- `gcps_config_theme_from_studio(ts)` maps the studio list into the
  `build_config()` shape (theme/typography/palette)
- `build_config()` now pulls theme/typography/palette from
  `gcps_config_theme_from_studio(input$ts_theme)`; canvas/header/sidebar/
  content/annotations stay on the Architect sidebar
- Removed the old sidebar colour/font/palette inputs; kept
  `annotations_enabled` under a "Preview Options" section
- `gcps_resolve_theme()` returns the GCPS default on first paint so Preview
  and exports render before the studio JS emits
- Generators (`generate_css/html/shiny_code/dax/json_theme`) untouched; they
  receive the same config shape from a single source

### Part D — Power BI `.pbip` project scaffold (✅ green)
- `gcps_template_pbip(t)` emits the PBIR-enhanced project tree (10 files):
  `GCPS-Report.pbip`, `*.Report/definition.{pbir,report.json,pages/…,
  StaticResources/.../GCPS-theme.json}`, `*.SemanticModel/definition.{pbism,
  database.tmdl}`, `.gitignore`, `README.md`
- Theme JSON under `StaticResources` is byte-identical to the B2 builder
  (single source); `report.json` references it via the correct relative path
- `download_tmpl_pbip` handler + a 7th card added to the Project Templates
  grid; registered in `gcps_template_all()` / `gcps_write_all_zip()` as the
  `powerbi-pbip/` subfolder
- Acceptance test passes: all 10 paths present, pointers parse, theme JSON
  parses and equals B2, zip round-trips (10 entries), all-zip has 7 subfolders
  incl. `powerbi-pbip`
- README documents the two required Desktop preview features + recovery steps

## Files changed (this session)
- `www/palette-data.js`, `www/theme-studio.js`, `www/theme-studio-app.js`,
  `www/theme-studio.css`, `www/_theme_studio_markup.html`, `www/fonts/README.md`
- `R/generate_templates.R` (new)
- `app.R` (studio mount, templates tab + handlers, Part C rewiring)