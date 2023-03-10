module Railsui
  module Controller
    extend ActiveSupport::Concern

    included do
      prepend_before_action :railsui_landing, if: -> { Rails.env.development? }
    end

    def railsui_landing
      redirect_to railsui.root_path unless File.exist?(Rails.root.join("config", "railsui.yml"))
    end
  end
end
