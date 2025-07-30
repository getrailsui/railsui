module Railsui
  module Pages
    CONFIG_FILE = Railsui::Engine.root.join('config', 'pages.yml')
    VIEWS_FOLDER = Rails.root.join('app/views/rui/pages')

    def self.all_pages
      @all_pages ||= load_pages_config
    end

    def self.theme_pages
      theme = Railsui.config.theme
      return {} if theme.nil?

      pages = all_pages[theme]
      return {} if pages.nil?

      pages
    end

    def self.get_pages(theme)
      all_pages[theme.to_s].keys
    end

    def self.page_enabled?(page)
      Railsui.config.pages.include?(page.to_s)
    end

    def self.page_exists?(page)
      VIEWS_FOLDER.join("#{page}.html.erb").exist?
    end

    def self.all_pages_installed?
      return false if theme_pages.nil? || theme_pages.empty?

      theme_pages.keys.all? { |page| page_exists?(page) }
    end

    def self.installed_pages
      return {} if theme_pages.nil?

      theme_pages.select { |page, details| page_enabled?(page) && page_exists?(page) }
    end

    private

    def self.load_pages_config
      return {} unless File.exist?(CONFIG_FILE)

      YAML.safe_load_file(CONFIG_FILE)
    end
  end
end
