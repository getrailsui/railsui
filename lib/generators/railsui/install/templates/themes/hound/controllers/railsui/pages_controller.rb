class Railsui::PagesController < ApplicationController
  layout "railsui/railsui"

  Railsui.config.pages.each do |page|
    define_method(page.to_sym) do
      render "railsui/pages/#{page}"
    end
  end
end
