# Template Registry
# K-12 Dashboard Architect
# Dashboard templates as structured lists.
# Each template defines sections, metrics, layout defaults, and metadata.

template_registry <- list(
  boe_area_snapshot = list(
    id = "boe_area_snapshot",
    name = "BOE Area Snapshot",
    description = "Board member area summary with KPIs, map, school table, trends, and source notes.",

    # Valid audiences for this template
    audience = c(
      "Board Member",
      "District Leadership",
      "School Leadership",
      "Public"
    ),

    # Reporting contexts this template supports
    contexts = c("BOE Area", "District", "Cluster"),

    # Layout defaults (override DEFAULT_CONFIG when this template is selected)
    layout = list(
      canvas = list(width = 1600, height = 900),
      header = list(
        height = 72,
        padding = 16,
        logo_width = 160,
        logo_height = 44,
        nav_button_count = 3
      ),
      sidebar = list(
        width = 0,
        padding = 0,
        nav_item_count = 0
      ),
      content = list(
        kpi_height = 90,
        kpi_count = 6,
        kpi_gap = 12,
        grid_rows = 3,
        grid_cols = 2,
        grid_gap = 12,
        padding = 16,
        layout_type = "byrow"
      )
    ),

    # Default theme for this template
    default_theme = "gcps_light",

    # Ordered sections defining the dashboard structure
    sections = list(
      list(
        id = "header",
        type = "header",
        component = "dashboard_header",
        row = 0,
        col = 0,
        span = "full",
        options = list(
          show_logo = TRUE,
          show_title = TRUE,
          title_template = "{area_name} — Board Area Snapshot",
          show_nav = TRUE,
          nav_items = c("Overview", "Schools", "Trends")
        )
      ),
      list(
        id = "filter_bar",
        type = "filters",
        component = "filter_bar",
        row = 0,
        col = 0,
        span = "full",
        options = list(
          filters = c("school_year", "school_level"),
          defaults = list(school_year = "2024-25", school_level = "All Levels")
        )
      ),
      list(
        id = "kpi_row",
        type = "kpi_row",
        component = "kpi_row",
        row = 0,
        col = 0,
        span = "full",
        options = list(
          metric_ids = c(
            "enrollment",
            "school_count",
            "proficient_distinguished",
            "chronic_absenteeism",
            "graduation_rate",
            "ccrpi_score"
          ),
          show_change = TRUE,
          show_sparkline = FALSE
        )
      ),
      list(
        id = "map",
        type = "chart",
        component = "map_school_points",
        row = 1,
        col = 1,
        span = 1,
        options = list(
          title = "School Locations",
          show_labels = TRUE,
          color_by = "level",
          size_by = "enrollment"
        )
      ),
      list(
        id = "school_table",
        type = "table",
        component = "school_summary_table",
        row = 1,
        col = 2,
        span = 1,
        options = list(
          title = "Schools in Area",
          columns = c(
            "school_name",
            "level",
            "enrollment",
            "pct_pd",
            "chronic_absent",
            "ccrpi"
          ),
          sortable = TRUE,
          highlight_promise = TRUE
        )
      ),
      list(
        id = "trend",
        type = "chart",
        component = "trend_chart_placeholder",
        row = 2,
        col = 1,
        span = 1,
        options = list(
          title = "District Trend (5 Years)",
          metrics = c("pct_pd", "chronic_absent", "graduation_rate"),
          x_var = "school_year",
          show_labels = TRUE
        )
      ),
      list(
        id = "student_groups",
        type = "comparison",
        component = "student_group_comparison",
        row = 2,
        col = 2,
        span = 1,
        options = list(
          title = "Student Group Performance",
          metric = "pct_pd",
          show_gap = TRUE,
          sort_by = "gap_vs_district"
        )
      ),
      list(
        id = "source_footer",
        type = "footer",
        component = "source_footer",
        row = 3,
        col = 0,
        span = "full",
        options = list(
          show_source = TRUE,
          show_methodology = TRUE,
          show_refresh_date = TRUE,
          show_disclosure = TRUE
        )
      )
    ),

    # Key into demo_data_k12 datasets
    data_key = "boe_area",

    # KPI metrics in display order
    kpi_metrics = c(
      "enrollment",
      "school_count",
      "proficient_distinguished",
      "chronic_absenteeism",
      "graduation_rate",
      "ccrpi_score"
    ),

    # Footer notes
    preview_notes = list(
      source = "Source: GA DOE Student Record System (SRS), Fall 2024 FTE Count.",
      methodology = "Chronic absenteeism: missing 10%+ of enrolled days. %P/D: Georgia Milestones Proficient + Distinguished.",
      refresh_date = "Data as of October 2024.",
      disclosure = "Cell sizes below 10 are suppressed. Preview uses synthetic data only."
    )
  )
)
