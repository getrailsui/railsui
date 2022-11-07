require_dependency "railsui/application_controller"

module Railsui
  module Systems
    class MailersController < ApplicationController
      pages = %w[layout minimal promotion transaction]

      pages.each do |page|
        define_method(page) do
        end
      end
    end
  end
end
