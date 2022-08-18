module Railsui
  class Default
    BOOTSTRAP = "bootstrap"
    TAILWIND_CSS = "tailwind"

    CSS_FRAMEWORKS = [
      ["Bootstrap", BOOTSTRAP],
      ["Tailwind CSS", TAILWIND_CSS],
    ]

    DEFAULT_PRIMARY_COLOR = "4338CA"
    DEFAULT_SECONDARY_COLOR = "FF8C69"
    DEFAULT_TERTIARY_COLOR = "333333"

    THEMES = {
      bootstrap: {
        retriever: "Retriever",
        setter: "Setter"
      },
      tailwind: {
        hound: "Hound",
        shepherd: "Shepherd"
      },
    }

    THEME_PREVIEW_LINK = {
      retriever: "https://retriever.com",
      setter: "https://setter.com",
      hound: "https://hound.com",
      shepherd: "https://shepherd.com"
    }
  end
end
