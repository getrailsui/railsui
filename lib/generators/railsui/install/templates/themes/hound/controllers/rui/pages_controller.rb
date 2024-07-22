class Rui::PagesController < ApplicationController
  layout "rui/railsui"

  Railsui.config.pages.each do |page|
    define_method(page.to_sym) do
      render "rui/pages/#{page}"
    end
  end
end
