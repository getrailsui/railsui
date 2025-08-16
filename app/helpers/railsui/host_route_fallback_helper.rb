module Railsui
  module HostRouteFallbackHelper
    def main_app
      Rails.application.routes.url_helpers
    end

    def method_missing(name, *args, &blk)
      if name.to_s.end_with?('_path', '_url') && main_app.respond_to?(name)
        return main_app.public_send(name, *args, &blk)
      end
      super
    end

    def respond_to_missing?(name, include_private = false)
      (name.to_s.end_with?('_path', '_url') && main_app.respond_to?(name)) || super
    end
  end
end
