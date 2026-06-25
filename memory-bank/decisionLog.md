# GCPS Theme Studio — Decision Log

## ADR: Studio is the single theme source (Part C)

**Status:** Accepted (2026-06-18)

**Context.** Part A5 shipped a deliberate dual-theme state: the new embedded
client-side Theme Studio drove the Project Template downloads, while the
old `colourInput`/`selectInput` controls in the Architect sidebar continued
to drive `build_config()` → Preview / Power BI HTML / DAX / Full HTML. This
kept the existing exports green while the studio stood up, but it left two
independent theme surfaces that could drift.

**Decision.** Make the studio (`input$ts_theme`, emitted by the JS bridge in
`www/theme-studio-app.js`) the single source of truth for the
`theme` / `typography` / `palette` sub-lists of `build_config()`. Layout
fields (canvas, header, sidebar, content, annotations) stay on the
Architect sidebar. `gcps_config_theme_from_studio()` in
`R/generate_templates.R` performs the shape mapping; `gcps_resolve_theme()`
makes it null-safe so first paint uses the GCPS default before the studio
JS emits.

**Consequences.**
- One place to set the theme; changing any studio control propagates to
  Preview, Power BI HTML, DAX, Full HTML, and every Project Template.
- `generate_css/html/shiny_code/dax/json_theme` signatures and bodies are
  unchanged — they still receive the same config shape, now fed from one
  source.
- The old sidebar colour/font/palette inputs are removed; `annotations_enabled`
  is retained (it is layout, not theme).

## ADR: Ship a PBIR `.pbip` scaffold, not a synthetic `.pbip` binary (Part D)

**Status:** Accepted (2026-06-18)

**Context.** The Part B Power BI bundle is a portable **report-theme JSON**
the user imports by hand. Users asked for a template that opens directly in
Power BI Desktop with the theme pre-registered. A true `.pbip` is a
multi-file project folder (PBIR enhanced-report format), not a single file.

**Decision.** Emit the minimal PBIR project tree (`GCPS-Report.pbip` +
`*.Report/…` + `*.SemanticModel/definition/database.tmdl` with one empty
`Placeholder` table) and reuse the Part-B theme JSON verbatim under
`StaticResources/.../GCPS-theme.json`. Keep JSON/TMDL minimal and
schema-valid; document the two required Desktop preview features
(`.pbip save option` + `Store reports using enhanced metadata format (PBIR)`)
in the bundle README.

**Consequences.**
- Single source of truth for the theme JSON (the B2 builder); the `.pbip`
  tree references it by the correct relative path.
- The format is preview-gated and version-sensitive; the README tells the
  user how to recover if a field is rejected (re-save from Desktop, diff).
- D is independent of B's six bundles and does not gate them.

## ADR: Embed the studio as scoped static assets (Part A)

**Status:** Accepted (2026-06-18)

**Context.** Re-porting the studio's palette/type/surface/preview/WCAG/export
interactions into Shiny reactives caused earlier "tabs didn't render / layout
is off" symptoms, and the standalone mock's global CSS bled into the yeti
shell + Architect.

**Decision.** Vendor the studio as scoped static assets under `www/`, mount
its markup inside exactly one `nav_panel` as static UI (not `renderUI`), and
re-scope every CSS rule under a single root class `.ts-root`. The studio owns
its own internal tab bar; init runs once against a present DOM. A single JS
emitter pushes the active theme to `input$ts_theme` for the R side.

**Consequences.**
- 1:1 fidelity with the approved mock; no reactive re-render drift.
- Zero CSS bleed into the Architect sidebar, unified Preview, or the shell.
- `input$ts_theme` is the bridge for every downstream export/template.