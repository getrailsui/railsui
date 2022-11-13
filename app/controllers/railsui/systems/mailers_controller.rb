require_dependency "railsui/application_controller"

module Railsui
  module Systems
    class MailersController < ApplicationController
      pages = %w[devise layout minimal promotion transaction]

      pages.each do |page|
        define_method(page) do
        end
      end
    end
  end
end
