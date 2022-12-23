require_dependency "railsui/application_controller"

module Railsui
  module Systems
    class FormsController < ApplicationController
      pages = %w[inputs input_groups selects checkboxes_and_radios layout action_text validation scaffolding]

      pages.each do |page|
        define_method(page) do
        end
      end
    end
  end
end
