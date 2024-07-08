class Railsui::PagesController < ApplicationController
  Railsui.config.pages.each do |page|
    define_method(page.to_sym) do
      render "railsui/pages/#{page}"
    end
  end
end
