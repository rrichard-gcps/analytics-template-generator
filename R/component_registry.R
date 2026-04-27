# Component Registry
# K-12 Dashboard Architect
# Maps component IDs to metadata and placeholder render functions.
# Each render function returns deterministic HTML for preview.

# ── Placeholder Render Functions ──────────────────────────────────────────
# All functions return HTML strings. No random values.
# Signature: render_<id>(data, options = list(), theme = NULL)

render_dashboard_header <- function(data, options = list(), theme = NULL) {
  title <- if (!is.null(data$area_name)) {
    gsub(
      "\\{area_name\\}",
      data$area_name,
      options$title_template %||% "{area_name}"
    )
  } else {
    "Dashboard"
  }
  bg <- if (!is.null(theme)) theme$colors$primary else "#9B2743"
  sprintf(
    '<div style="background:%s;color:#fff;padding:16px 20px;display:flex;align-items:center;justify-content:space-between;height:72px;border-radius:8px 8px 0 0;"><div style="display:flex;align-items:center;gap:12px;"><div style="width:44px;height:44px;background:rgba(255,255,255,0.2);border-radius:6px;display:flex;align-items:center;justify-content:center;font-size:12px;">LOGO</div><span style="font-size:18px;font-weight:600;">%s</span></div><div style="display:flex;gap:8px;">%s</div></div>',
    bg,
    title,
    paste(
      rep(
        '<div style="width:36px;height:36px;background:rgba(255,255,255,0.15);border-radius:6px;"></div>',
        3
      ),
      collapse = ""
    )
  )
}

render_nav_tabs <- function(data, options = list(), theme = NULL) {
  tabs <- options$nav_items %||% c("Overview", "Schools", "Trends")
  accent <- if (!is.null(theme)) theme$colors$accent_teal else "#2F7C73"
  tab_html <- paste(
    mapply(
      function(t, i) {
        active <- if (i == 1) {
          sprintf("border-bottom:3px solid %s;font-weight:600;", accent)
        } else {
          "border-bottom:3px solid transparent;"
        }
        sprintf(
          '<div style="padding:8px 16px;font-size:13px;cursor:pointer;%s">%s</div>',
          active,
          t
        )
      },
      tabs,
      seq_along(tabs)
    ),
    collapse = ""
  )
  sprintf(
    '<div style="display:flex;gap:0;border-bottom:1px solid #D8DEE8;padding:0 20px;background:#fff;">%s</div>',
    tab_html
  )
}

render_filter_bar <- function(data, options = list(), theme = NULL) {
  filters <- options$filters %||% c("school_year", "school_level")
  defaults <- options$defaults %||%
    list(school_year = "2024-25", school_level = "All Levels")
  filter_html <- paste(
    mapply(
      function(f, i) {
        val <- defaults[[f]]
        if (is.null(val)) {
          val <- "All"
        }
        sprintf(
          '<div style="display:flex;align-items:center;gap:6px;"><span style="font-size:11px;color:#667085;text-transform:uppercase;">%s</span><div style="background:#F6F7F9;border:1px solid #D8DEE8;border-radius:4px;padding:4px 10px;font-size:13px;">%s</div></div>',
          gsub("_", " ", tools::toTitleCase(f)),
          val
        )
      },
      filters,
      seq_along(filters)
    ),
    collapse = ""
  )
  sprintf(
    '<div style="display:flex;gap:16px;padding:10px 20px;background:#fff;border-bottom:1px solid #D8DEE8;">%s</div>',
    filter_html
  )
}

render_kpi_row <- function(data, options = list(), theme = NULL) {
  metric_ids <- options$metric_ids %||% names(data)
  show_change <- options$show_change %||% TRUE
  accent <- if (!is.null(theme)) theme$colors$accent_teal else "#2F7C73"
  danger <- if (!is.null(theme)) theme$colors$danger else "#CF222E"

  cards <- paste(
    sapply(metric_ids, function(mid) {
      m <- data[[mid]]
      if (is.null(m)) {
        return("")
      }
      change_color <- if (m$change > 0) {
        "#1A7F37"
      } else if (m$change < 0) {
        danger
      } else {
        "#667085"
      }
      change_prefix <- if (m$direction == "up") {
        "+"
      } else if (m$direction == "down") {
        ""
      } else {
        ""
      }
      change_html <- if (show_change) {
        sprintf(
          '<div style="font-size:11px;color:%s;margin-top:4px;">%s%.1f%%</div>',
          change_color,
          change_prefix,
          m$change
        )
      } else {
        ""
      }
      val_fmt <- if (m$value >= 1000) {
        format(m$value, big.mark = ",")
      } else {
        as.character(m$value)
      }
      sprintf(
        '<div style="flex:1;background:#fff;border:1px solid #D8DEE8;border-radius:8px;padding:12px 16px;"><div style="font-size:11px;color:#667085;margin-bottom:2px;">%s</div><div style="font-size:24px;font-weight:700;color:#1F2933;">%s</div>%s</div>',
        m$label,
        val_fmt,
        change_html
      )
    }),
    collapse = ""
  )

  sprintf('<div style="display:flex;gap:12px;padding:0 20px;">%s</div>', cards)
}

render_metric_selector_card <- function(data, options = list(), theme = NULL) {
  metric <- options$metric %||% "enrollment"
  m <- data[[metric]]
  if (is.null(m)) {
    m <- list(value = 0, label = metric, change = 0, direction = "flat")
  }
  val_fmt <- if (m$value >= 1000) {
    format(m$value, big.mark = ",")
  } else {
    as.character(m$value)
  }
  sprintf(
    '<div style="background:#fff;border:1px solid #D8DEE8;border-radius:8px;padding:16px;display:flex;flex-direction:column;align-items:center;justify-content:center;"><div style="font-size:11px;color:#667085;">%s</div><div style="font-size:28px;font-weight:700;color:#1F2933;">%s</div></div>',
    m$label,
    val_fmt
  )
}

render_trend_chart <- function(data, options = list(), theme = NULL) {
  title <- options$title %||% "Trend"
  n_years <- nrow(data)
  accent <- if (!is.null(theme)) theme$colors$accent_teal else "#2F7C73"

  # Simple bar chart placeholder using inline styles
  max_val <- max(data$pct_pd, na.rm = TRUE)
  bars <- paste(
    sapply(seq_len(n_years), function(i) {
      pct <- data$pct_pd[i]
      h <- round((pct / max_val) * 100)
      yr <- data$school_year[i]
      sprintf(
        '<div style="display:flex;flex-direction:column;align-items:center;flex:1;"><div style="width:100%%;height:%d%%;background:%s;border-radius:3px 3px 0 0;min-height:20px;"></div><div style="font-size:9px;color:#667085;margin-top:4px;">%s</div></div>',
        h,
        accent,
        yr
      )
    }),
    collapse = ""
  )

  sprintf(
    '<div style="background:#fff;border:1px solid #D8DEE8;border-radius:8px;padding:16px;"><div style="font-size:13px;font-weight:600;color:#1F2933;margin-bottom:12px;">%s</div><div style="display:flex;align-items:flex-end;gap:4px;height:120px;">%s</div></div>',
    title,
    bars
  )
}

render_student_group_comparison <- function(
  data,
  options = list(),
  theme = NULL
) {
  title <- options$title %||% "Student Group Comparison"
  show_gap <- options$show_gap %||% TRUE
  accent <- if (!is.null(theme)) theme$colors$accent_blue else "#374E8E"
  danger <- if (!is.null(theme)) theme$colors$danger else "#CF222E"

  rows <- paste(
    sapply(seq_len(nrow(data)), function(i) {
      name <- data$group_name[i]
      pct <- data$pct_pd[i]
      gap <- data$gap_vs_district[i]
      bar_w <- round(pct)
      gap_color <- if (gap >= 0) accent else danger
      gap_prefix <- if (gap >= 0) "+" else ""
      gap_html <- if (show_gap) {
        sprintf(
          '<span style="font-size:11px;color:%s;margin-left:8px;">%s%.1f</span>',
          gap_color,
          gap_prefix,
          gap
        )
      } else {
        ""
      }
      sprintf(
        '<div style="display:flex;align-items:center;gap:8px;margin-bottom:6px;"><div style="width:140px;font-size:11px;color:#1F2933;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">%s</div><div style="flex:1;background:#F6F7F9;border-radius:3px;height:16px;position:relative;"><div style="height:100%%;width:%d%%;background:%s;border-radius:3px;"></div></div><span style="font-size:11px;font-weight:600;color:#1F2933;">%.1f%%</span>%s</div>',
        name,
        bar_w,
        accent,
        pct,
        gap_html
      )
    }),
    collapse = ""
  )

  sprintf(
    '<div style="background:#fff;border:1px solid #D8DEE8;border-radius:8px;padding:16px;"><div style="font-size:13px;font-weight:600;color:#1F2933;margin-bottom:12px;">%s</div>%s</div>',
    title,
    rows
  )
}

render_map_school_points <- function(data, options = list(), theme = NULL) {
  title <- options$title %||% "School Locations"
  n_schools <- nrow(data$schools)
  accent <- if (!is.null(theme)) theme$colors$accent_teal else "#2F7C73"
  primary <- if (!is.null(theme)) theme$colors$primary else "#9B2743"

  # Placeholder dots positioned roughly
  dots <- paste(
    sapply(seq_len(n_schools), function(i) {
      x <- round(
        20 +
          (data$schools$lon[i] - min(data$schools$lon)) /
            (max(data$schools$lon) - min(data$schools$lon)) *
            200
      )
      y <- round(
        140 -
          (data$schools$lat[i] - min(data$schools$lat)) /
            (max(data$schools$lat) - min(data$schools$lat)) *
            120
      )
      col <- if (data$schools$level[i] == "High") primary else accent
      sprintf(
        '<div style="position:absolute;left:%dpx;top:%dpx;width:8px;height:8px;background:%s;border-radius:50%%;"></div>',
        x,
        y,
        col
      )
    }),
    collapse = ""
  )

  sprintf(
    '<div style="background:#fff;border:1px solid #D8DEE8;border-radius:8px;padding:16px;"><div style="font-size:13px;font-weight:600;color:#1F2933;margin-bottom:8px;">%s</div><div style="position:relative;width:240px;height:160px;background:#F6F7F9;border-radius:6px;">%s</div><div style="font-size:10px;color:#667085;margin-top:6px;">%d schools shown</div></div>',
    title,
    dots,
    n_schools
  )
}

render_school_summary_table <- function(data, options = list(), theme = NULL) {
  title <- options$title %||% "Schools"
  columns <- options$columns %||%
    c("school_name", "level", "enrollment", "pct_pd")

  col_labels <- c(
    school_name = "School",
    level = "Level",
    enrollment = "Enrollment",
    pct_pd = "%P/D",
    chronic_absent = "Chron. Absent %",
    ccrpi = "CCRPI"
  )

  header_cells <- paste(
    sapply(columns, function(c) {
      sprintf(
        '<th style="padding:6px 10px;font-size:11px;color:#667085;text-align:left;border-bottom:2px solid #D8DEE8;">%s</th>',
        col_labels[c]
      )
    }),
    collapse = ""
  )

  body_rows <- paste(
    sapply(seq_len(nrow(data)), function(i) {
      cells <- paste(
        sapply(columns, function(c) {
          val <- data[[c]][i]
          fmt <- if (is.numeric(val)) {
            if (c == "enrollment") {
              format(val, big.mark = ",")
            } else {
              sprintf("%.1f", val)
            }
          } else {
            as.character(val)
          }
          sprintf(
            '<td style="padding:5px 10px;font-size:12px;border-bottom:1px solid #F0F0F0;">%s</td>',
            fmt
          )
        }),
        collapse = ""
      )
      sprintf('<tr>%s</tr>', cells)
    }),
    collapse = ""
  )

  sprintf(
    '<div style="background:#fff;border:1px solid #D8DEE8;border-radius:8px;padding:16px;"><div style="font-size:13px;font-weight:600;color:#1F2933;margin-bottom:8px;">%s</div><table style="width:100%%;border-collapse:collapse;"><thead><tr>%s</tr></thead><tbody>%s</tbody></table></div>',
    title,
    header_cells,
    body_rows
  )
}

render_metric_matrix_table <- function(data, options = list(), theme = NULL) {
  title <- options$title %||% "Metric Matrix"
  sprintf(
    '<div style="background:#fff;border:1px solid #D8DEE8;border-radius:8px;padding:16px;"><div style="font-size:13px;font-weight:600;color:#1F2933;margin-bottom:8px;">%s</div><div style="color:#667085;font-size:12px;">Metric matrix placeholder — school-by-metric summary table.</div></div>',
    title
  )
}

render_source_footer <- function(data, options = list(), theme = NULL) {
  show_source <- options$show_source %||% TRUE
  show_methodology <- options$show_methodology %||% TRUE
  show_refresh <- options$show_refresh_date %||% TRUE
  show_disclosure <- options$show_disclosure %||% TRUE

  lines <- c()
  if (show_source && !is.null(data$source_note)) {
    lines <- c(lines, data$source_note)
  }
  if (show_methodology && !is.null(data$methodology_note)) {
    lines <- c(lines, data$methodology_note)
  }
  if (show_refresh && !is.null(data$refresh_date)) {
    lines <- c(lines, paste("Data as of", data$refresh_date))
  }
  if (show_disclosure && !is.null(data$disclosure_note)) {
    lines <- c(lines, data$disclosure_note)
  }

  note_html <- paste(
    sapply(lines, function(l) {
      sprintf(
        '<div style="font-size:10px;color:#667085;line-height:1.5;">%s</div>',
        l
      )
    }),
    collapse = ""
  )

  sprintf(
    '<div style="padding:12px 20px;border-top:1px solid #D8DEE8;background:#F6F7F9;border-radius:0 0 8px 8px;">%s</div>',
    note_html
  )
}

render_disclosure_note <- function(data, options = list(), theme = NULL) {
  note <- data$disclosure_note %||% "Cell sizes below 10 are suppressed."
  sprintf(
    '<div style="padding:8px 16px;background:#FFF8E1;border:1px solid #FFE082;border-radius:4px;font-size:11px;color:#92400E;"><strong>Disclosure:</strong> %s</div>',
    note
  )
}

# ── Component Registry ───────────────────────────────────────────────────

component_registry <- list(
  dashboard_header = list(
    id = "dashboard_header",
    name = "Dashboard Header",
    type = "header",
    description = "Top banner with logo, title, and navigation icons.",
    render_fn = "render_dashboard_header",
    data_keys = c("boe_area"),
    default_options = list(
      show_logo = TRUE,
      show_title = TRUE,
      title_template = "{area_name}",
      show_nav = TRUE,
      nav_items = c("Overview", "Schools", "Trends")
    )
  ),

  nav_tabs = list(
    id = "nav_tabs",
    name = "Navigation Tabs",
    type = "nav",
    description = "Horizontal tab navigation below the header.",
    render_fn = "render_nav_tabs",
    data_keys = character(0),
    default_options = list(
      nav_items = c("Overview", "Schools", "Trends")
    )
  ),

  filter_bar = list(
    id = "filter_bar",
    name = "Filter Bar",
    type = "filters",
    description = "Dropdown filters for school year, level, and other dimensions.",
    render_fn = "render_filter_bar",
    data_keys = character(0),
    default_options = list(
      filters = c("school_year", "school_level"),
      defaults = list(school_year = "2024-25", school_level = "All Levels")
    )
  ),

  kpi_row = list(
    id = "kpi_row",
    name = "KPI Row",
    type = "kpi",
    description = "Row of metric cards with value, label, and change indicator.",
    render_fn = "render_kpi_row",
    data_keys = c("kpi_values"),
    default_options = list(
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

  metric_selector_card = list(
    id = "metric_selector_card",
    name = "Metric Selector Card",
    type = "kpi",
    description = "Single metric card for use in selector layouts.",
    render_fn = "render_metric_selector_card",
    data_keys = c("kpi_values"),
    default_options = list(
      metric = "enrollment"
    )
  ),

  trend_chart_placeholder = list(
    id = "trend_chart_placeholder",
    name = "Trend Chart",
    type = "chart",
    description = "Multi-year trend bar chart placeholder.",
    render_fn = "render_trend_chart",
    data_keys = c("trend_years"),
    default_options = list(
      title = "District Trend (5 Years)",
      metrics = c("pct_pd", "chronic_absent", "graduation_rate"),
      x_var = "school_year",
      show_labels = TRUE
    )
  ),

  student_group_comparison = list(
    id = "student_group_comparison",
    name = "Student Group Comparison",
    type = "comparison",
    description = "Horizontal bar chart comparing student group performance.",
    render_fn = "render_student_group_comparison",
    data_keys = c("student_groups"),
    default_options = list(
      title = "Student Group Performance",
      metric = "pct_pd",
      show_gap = TRUE,
      sort_by = "gap_vs_district"
    )
  ),

  map_school_points = list(
    id = "map_school_points",
    name = "School Map",
    type = "chart",
    description = "Dot map showing school locations with color by level.",
    render_fn = "render_map_school_points",
    data_keys = c("boe_area"),
    default_options = list(
      title = "School Locations",
      show_labels = TRUE,
      color_by = "level",
      size_by = "enrollment"
    )
  ),

  school_summary_table = list(
    id = "school_summary_table",
    name = "School Summary Table",
    type = "table",
    description = "Sortable table of schools with key metrics.",
    render_fn = "render_school_summary_table",
    data_keys = c("schools"),
    default_options = list(
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

  metric_matrix_table = list(
    id = "metric_matrix_table",
    name = "Metric Matrix Table",
    type = "table",
    description = "School-by-metric summary matrix.",
    render_fn = "render_metric_matrix_table",
    data_keys = c("schools"),
    default_options = list(
      title = "Metric Matrix"
    )
  ),

  source_footer = list(
    id = "source_footer",
    name = "Source Footer",
    type = "footer",
    description = "Footer with source, methodology, refresh date, and disclosure notes.",
    render_fn = "render_source_footer",
    data_keys = c("boe_area"),
    default_options = list(
      show_source = TRUE,
      show_methodology = TRUE,
      show_refresh_date = TRUE,
      show_disclosure = TRUE
    )
  ),

  disclosure_note = list(
    id = "disclosure_note",
    name = "Disclosure Note",
    type = "note",
    description = "Standalone disclosure and suppression note.",
    render_fn = "render_disclosure_note",
    data_keys = c("boe_area"),
    default_options = list()
  )
)

# ── Helper for null-coalescing ────────────────────────────────────────────
`%||%` <- function(a, b) if (is.null(a)) b else a
