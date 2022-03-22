module Railsui
  class Default
    BOOTSTRAP = "bootstrap"
    BULMA = "bulma"
    TAILWIND_CSS = "tailwind"

    CSS_FRAMEWORKS = [
      ["Bootstrap", BOOTSTRAP],
      ["Bulma", BULMA],
      ["Tailwind CSS", TAILWIND_CSS],
    ]

    SYSTEM_FONTS  = 'ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji"'

    DEFAULT_PRIMARY_COLOR = "4338CA"
    DEFAULT_SECONDARY_COLOR = "FF8C69"
    DEFAULT_TERTIARY_COLOR = "333333"
    DEFAULT_FONT_FAMILY = SYSTEM_FONTS

    FONTS = {
      inter: "Inter, #{SYSTEM_FONTS}",
      mono: 'ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace',
      system: SYSTEM_FONTS
    }

    THEMES = {
      bootstrap: {
        retriever: "Retriever",
        setter: "Setter"
      },
      tailwind: {
        hound: "Hound",
        shepherd: "Shepherd"
      },
      bulma: {
        collie: "collie",
        terrier: "terrier"
      }
    }
  end
end
