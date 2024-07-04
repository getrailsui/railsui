module Railsui
  module ThemeRegistry
    extend self

    THEMES = {
      'default' => 'Themes::Default',
      'hound' => 'Themes::Hound',
      'shepherd' => 'Themes::Shepherd'
    }.freeze

    def get_theme_module(theme)
      THEMES[theme] || THEMES['default']
    end
  end
end
