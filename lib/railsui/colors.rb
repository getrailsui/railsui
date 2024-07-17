# frozen_string_literal: true

module Railsui
  module Colors
    CONFIG_FILE = Railsui::Engine.root.join("config", "colors.yml")

    def self.all_colors
      @all_colors ||= load_colors_config
    end

    def self.theme_colors(theme_name)
      all_colors[theme_name]
    end

    private

    def self.load_colors_config
      return {} unless File.exist?(CONFIG_FILE)
      YAML.safe_load_file(CONFIG_FILE)
    end
  end
end
