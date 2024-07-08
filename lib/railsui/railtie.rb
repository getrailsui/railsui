module Railsui
  class Railtie < ::Rails::Railtie
    initializer "railsui.theme_helper" do
      ActiveSupport.on_load :action_controller do
        helper Railsui::ThemeHelper
      end
    end
  end
end
