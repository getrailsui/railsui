# frozen_string_literal: true

module Railsui
  module Themes
    CONFIG_FILE = Railsui::Engine.root.join("config", "theme.yml")

    def self.theme_classes
      @theme_classes ||= load_theme_config
    end

     def self.body_classes(theme_name)
      theme_classes[theme_name]['body_classes'] if theme_classes.key?(theme_name)
    end

    private

    def self.load_theme_config
      return {} unless File.exist?(CONFIG_FILE)
      YAML.safe_load_file(CONFIG_FILE)
    end
  end
end
