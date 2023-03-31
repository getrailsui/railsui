module Railsui
  module Pages

    BASE_PAGES = {
      "about" => {
        title: "About",
        description: "Placeholder markup for company or organization about page.",
      },
      "pricing" => {
        title: "Pricing",
        description: "Placeholder markup for SaaS-like pricing; 3 plans types by default.",
      }
    }.freeze


    def self.all_pages
      BASE_PAGES
    end

    def self.page_enabled?(page)
      Railsui.config.pages.include?(page)
    end

    def self.page_exists?(page)
      Rails.root.join("app/views/page/#{page}.html.erb").exist?
    end
  end
end
