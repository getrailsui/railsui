module Railsui
  module Controller
    extend ActiveSupport::Concern

    included do
      prepend_before_action :start, if: -> { Rails.env.development? }
    end

    def start
      redirect_to railsui.root_path(welcome: true) unless File.exist?(Rails.root.join("config", "railsui.yml"))
    end
  end
end
