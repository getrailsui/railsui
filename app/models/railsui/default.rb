module Railsui
  class Default
    BOOTSTRAP_VERSION = "5.3"
    TAILWIND_CSS_VERSION = "3.2.7"
    BOOTSTRAP_PACKAGE_VERSION = "5.3.0-alpha1"
    BOOTSTRAP_INSTALL_PACKAGE = "bootstrap@5.3.0-alpha1"

    BOOTSTRAP = "bootstrap"
    TAILWIND_CSS = "tailwind"

    CSS_FRAMEWORKS = [
      ["Bootstrap", BOOTSTRAP],
      ["Tailwind CSS", TAILWIND_CSS],
    ]

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
      retriever: "https://retriever.pages.dev/",
      setter: "https://setter-7xa.pages.dev/",
      hound: "https://hound.pages.dev/",
      shepherd: "https://shepherd-a4r.pages.dev/"
    }
  end
end
