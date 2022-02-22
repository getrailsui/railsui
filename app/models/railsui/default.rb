module Railsui
  class Default
    BOOTSTRAP = "Bootstrap"
    BULMA = "Bulma"
    TAILWIND_CSS = "Tailwind CSS"
    NONE = "None"

    CSS_FRAMEWORKS = [BOOTSTRAP, BULMA, TAILWIND_CSS, NONE]
    SYSTEM_FONTS  = 'ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji"'

    DEFAULT_PRIMARY_COLOR = "4338CA"
    DEFAULT_SECONDARY_COLOR = "FF8C69"
    DEFAULT_TERTIARY_COLOR = "333333"
    DEFAULT_FONT_FAMILY = SYSTEM_FONTS

    FONTS = {
      inter: "Inter, #{SYSTEM_FONTS}",
      lato: "Lato, #{SYSTEM_FONTS}",
      open_sans: "Open Sans, #{SYSTEM_FONTS}",
      roboto: "Roboto, #{SYSTEM_FONTS}",
      mono: 'ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace',
      serif: 'ui-serif, Georgia, Cambria, "Times New Roman", Times, serif',
      system: SYSTEM_FONTS
    }
  end
end
