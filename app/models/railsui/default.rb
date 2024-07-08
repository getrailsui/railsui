module Railsui
  class Default
    THEMES = {
      hound: {
        name: "Hound",
        preview_link: "https://hound.pages.dev/",
        thumbnail: "tailwind-hound-thumbnail.jpg"
      },
      shepherd: {
        name: "Shepherd",
        preview_link: "https://shepherd-a4r.pages.dev/",
        thumbnail: "tailwind-shepherd-thumbnail.jpg"
      }
    }

    THEME_COLORS = {
      "default" => {
        primary: {
          "50": "#eef2ff",
          "100": "#e0e7ff",
          "200": "#c7d2fe",
          "300": "#a5b4fc",
          "400": "#818cf8",
          "500": "#6366f1",
          "600": "#4f46e5",
          "700": "#4338ca",
          "800": "#3730a3",
          "900": "#312e81",
          "950": "#1e1b4b"
        },
        secondary: {
          "50": "#f8fafc",
          "100": "#f1f5f9",
          "200": "#e2e8f0",
          "300": "#cbd5e1",
          "400": "#94a3b8",
          "500": "#64748b",
          "600": "#475569",
          "700": "#334155",
          "800": "#1e293b",
          "900": "#0f172a",
          "950": "#020617"
        },
      },
      "hound" => {
        primary: {
          "50": "#eef2ff",
          "100": "#e0e7ff",
          "200": "#c7d2fe",
          "300": "#a5b4fc",
          "400": "#818cf8",
          "500": "#6366f1",
          "600": "#4f46e5",
          "700": "#4338ca",
          "800": "#3730a3",
          "900": "#312e81",
          "950": "#1e1b4b"
        },
        secondary: {
          "50": "#f8fafc",
          "100": "#f1f5f9",
          "200": "#e2e8f0",
          "300": "#cbd5e1",
          "400": "#94a3b8",
          "500": "#64748b",
          "600": "#475569",
          "700": "#334155",
          "800": "#1e293b",
          "900": "#0f172a",
          "950": "#020617"
        },
      },
      "shepherd" => {
        primary: {
          "50": "#fff1f2",
          "100": "#ffe4e6",
          "200": "#fecdd3",
          "300": "#fda4af",
          "400": "#fb7185",
          "500": "#f43f5e",
          "600": "#e11d48",
          "700": "#be123c",
          "800": "#9f1239",
          "900": "#881337",
          "950": "#4c0519",
        },
        secondary: {
          "50": "#eaf6fc",
          "100": "#c1e3f7",
          "200": "#98d1f2",
          "300": "#6FBFED",
          "400": "#46ACE7",
          "500": "#1D9AE2",
          "600": "#187eb9",
          "700": "#126290",
          "800": "#0D4667",
          "900": "#082a3e",
          "950": "#030E15",
        }
      }
    }

    THEME_PAGES = {
      default: ["about", "activity", "assignments", "billing",
      "calendar", "dashboard", "integrations", "message",
      "messages", "notifications", "people", "pricing",
      "profile", "project", "projects", "settings", "team"],
      hound: ["about", "activity", "assignments", "billing",
      "calendar", "dashboard", "integrations", "message",
      "messages", "notifications", "people", "pricing",
      "profile", "project", "projects", "settings", "team"],
      shepherd: ["about", "account_notifications" "account_payment_methods", "account_payouts", "account_preferences", "api", "booking", "bookings", "calendar", "changelog", "contact", "dashboard","edit_booking", "help_center", "inbox", "insights", "new_booking", "pricing", "privacy_policy", "properties", "terms"]
    }

    BODY_CLASSES = {
      default: "antialiased h-full bg-slate-50 dark:bg-slate-900 dark:text-slate-100 text-slate-800",
      hound: "antialiased h-full bg-slate-50 dark:bg-slate-900 dark:text-slate-100 text-slate-800",
      shepherd: "h-full antialiased text-zinc-800 leading-normal selection:bg-primary-100 selection:text-primary-700 dark:bg-zinc-900 bg-white dark:text-zinc-50 dark:selection:bg-zinc-500/40 dark:selection:text-zinc-200"
    }

    def self.theme_colors(theme)
      theme_key = theme.to_s.downcase
      THEME_COLORS[theme_key.to_s] || THEME_COLORS["default"]
    end
  end
end
