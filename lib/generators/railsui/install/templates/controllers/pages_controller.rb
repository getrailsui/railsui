class Rui::PagesController < ApplicationController
  Railsui.config.pages.each do |page|
    define_method(page.to_sym) do
      layout = Railsui::Pages.installed_pages[page.to_s]['namespace'] == 'admin' && lookup_context.exists?("layouts/rui/railsui_admin") ? "rui/railsui_admin" : "rui/railsui"
      render "rui/pages/#{page}", layout: layout
    end
  end
end
